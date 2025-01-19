import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:productivity_app_v1/ui/screens/focus_room_screen/focus_room_screen.dart';
import 'package:productivity_app_v1/ui/screens/log_history_screen/widgets/log_display.dart';
import 'package:productivity_app_v1/utils.dart';
import 'package:provider/provider.dart';

class DbService {
  static createUser(
      {required String uid,
      required String email,
      required String username}) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        "uid": uid,
        "email": email,
        "username": username,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<String> readUser({required String uid}) async {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      return userDoc["username"];
    } catch (e) {
      log(e.toString());
      throw Exception('Failed to read user: $e');
    }
  }

  static Future<bool> moveUserToArea(
      String roomId, String currentUserId, String newAreaId) async {
    final roomRef = FirebaseFirestore.instance.collection('rooms').doc(roomId);
    final areasCollectionRef = roomRef.collection('areas');
    bool canMove = true;

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      String? currentAreaId;
      bool isNewAreaOccupied = false;
      String? currentUserAtNewArea;

      // 1. Fetch all areas in the room
      // QuerySnapshot areasSnapshot = await transaction.get(areasCollectionRef);
      QuerySnapshot areasSnapshot = await areasCollectionRef.get();

      // 2. Find the current area occupied by the user
      for (var doc in areasSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('userId') && data['userId'] == currentUserId) {
          currentAreaId = doc.id;
        }

        // Check if the new area is occupied
        if (doc.id == newAreaId) {
          isNewAreaOccupied = data['occupied'] ?? false;
          currentUserAtNewArea =
              data['userId']; // Store the userId occupying this new area
        }
      }

      // 3. Ensure the new area is not occupied
      if (isNewAreaOccupied) {
        if (currentUserAtNewArea != null) {
          DbService.nudgePlayer(currentUserId, currentUserAtNewArea,
              roomId); // Nudge the player in the area
          canMove = false;
          return;
        }
      }

      // 4. Deoccupy the current area (if exists)
      if (currentAreaId != null) {
        final currentAreaRef = areasCollectionRef.doc(currentAreaId);
        transaction.update(currentAreaRef, {
          'occupied': false,
          'userId': FieldValue.delete(),
        });
      }

      // 5. Occupy the new area
      final newAreaRef = areasCollectionRef.doc(newAreaId);
      transaction.update(newAreaRef, {
        'occupied': true,
        'userId': currentUserId,
      });
    });
    return canMove;
  }

  static Stream<QuerySnapshot> areaStream(String roomId) {
    return FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .collection('areas')
        .snapshots();
  }

  static Future<void> deleteField(
      String documentId, String fieldName, String roomId) async {
    final roomRef = FirebaseFirestore.instance.collection('rooms').doc(roomId);
    final areasCollectionRef = roomRef.collection('areas');

    try {
      await areasCollectionRef.doc(documentId).update({
        fieldName: FieldValue.delete(), // Deletes the specific field
      });
      // ignore: empty_catches
    } catch (e) {}
  }

  static // Method to modify a field in a Firestore document
      Future<void> modifyField(String documentId, String fieldName,
          dynamic newValue, String roomId) async {
    final roomRef = FirebaseFirestore.instance.collection('rooms').doc(roomId);
    final areasCollectionRef = roomRef.collection('areas');
    try {
      await areasCollectionRef.doc(documentId).update({
        fieldName: newValue, // Updates the field with new value
      });
      // ignore: empty_catches
    } catch (e) {}
  }

  // Method to search for a field in Firestore and return the document ID
  static Future<String?> searchField(
      String fieldName, dynamic fieldValue, String roomId) async {
    final roomRef = FirebaseFirestore.instance.collection('rooms').doc(roomId);
    final areasCollectionRef = roomRef.collection('areas');
    try {
      QuerySnapshot querySnapshot = await areasCollectionRef
          .where(fieldName, isEqualTo: fieldValue)
          .get();

      // Iterate through documents to find the matching field value
      for (var doc in querySnapshot.docs) {
        // Get the data and handle potential null case
        final data = doc.data() as Map<String, dynamic>?;

        // Check if document exists and has data
        if (doc.exists && data != null && data[fieldName] == fieldValue) {
          return doc.id; // Return the document ID if match is found
        }
      }
      return null; // No matching document found
    } catch (e) {
      return null;
    }
  }

  static void nudgePlayer(String sender, String receiver, String roomId) async {
    // Write nudge event to Firestore
    await FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .collection('nudges')
        .add({
      'nudgedBy': sender,
      'targetUserId': receiver,
    });
  }

  static void listenForNudges(String receiver, String roomId) {
    FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .collection('nudges')
        .where('targetUserId', isEqualTo: receiver)
        .snapshots()
        .listen((snapshot) {
      for (var doc in snapshot.docs) {
        // Trigger nudge animation or feedback
        String sender = doc.get('nudgedBy');
        if (sender != receiver) {
          processNudge(sender, receiver);
        }

        // Delete the nudge event after processing
        doc.reference.delete();
      }
    });
  }

  static void processNudge(String sender, String receiver) {
    // ADD NUDGE FUNCTION WHICH IS NOTIFICATION
    DbService.triggerNofication(sender, receiver);
    AddLog.addToList(LogDisplay(
        name: sender,
        activity: "nudged $receiver!",
        time: AddLog.formatTime(DateTime.now())));
  }

  static void triggerNofication(String sender, String receiver) {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 10,
            channelKey: 'basic_channel',
            title: '$sender nudged you!',
            body: "You've rested enough, get back to work now!",
            notificationLayout: NotificationLayout.BigText));
  }

  // TIMER
  static Future<void> setSharedTimer(
      String roomId, int durationInMinutes) async {
    final roomRef = FirebaseFirestore.instance.collection('rooms').doc(roomId);

    await roomRef.update({
      'timerDuration': durationInMinutes,
      'timerStarted': false,
    });
  }

  static Future<void> startSharedTimer(
      String roomId, int durationInMinutes) async {
    final roomRef = FirebaseFirestore.instance.collection('rooms').doc(roomId);

    await roomRef.update({
      'timerDuration': durationInMinutes,
      'timerStarted': true,
    });

    // Placeholder: Trigger any additional logic when the timer starts
    // CHANGE START BUTTON TO FALSE
    FocusRoomScreen.globalKey.currentState?.setTimerStarted(true);
  }

  static Stream<Map<String, dynamic>> listenToSharedTimer(String roomId) {
    return FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .snapshots()
        .map((snapshot) => snapshot.data() ?? {});
  }

  static Future<void> resetSharedTimer(String roomId) async {
    final roomRef = FirebaseFirestore.instance.collection('rooms').doc(roomId);

    await roomRef.update({
      'timerStarted': false,
      'timerDuration': FieldValue.delete(),
    });

    // Placeholder: Add any logic when the timer is reset
    // CHANGE BACK START BUTTON TO TRUE
    // Setting the timerStarted value
    FocusRoomScreen.globalKey.currentState?.setTimerStarted(false);
  }
}
