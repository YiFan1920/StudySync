import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:productivity_app_v1/actors/player.dart';
import 'package:productivity_app_v1/services/db_service.dart';
import 'package:productivity_app_v1/ui/screens/log_history_screen/widgets/log_display.dart';
import 'package:productivity_app_v1/utils.dart';
import 'package:provider/provider.dart';

class MyGame extends FlameGame {
  final UserNotifier userNotifier; // Add a field for UserNotifier
  late final Player player;
  bool addTv = false;
  bool addTv1 = false;
  Map<String, Player> uiPlayersMap = {};
  Map<String, String> playerStates = {};
  // late StreamSubscription<QuerySnapshot> _areaSubscription;
  final List<Vector2> tablePosition = [
    Vector2(141, 173),
    Vector2(189, 149),
    Vector2(238, 125)
  ];
  final Vector2 idlePosition = Vector2(162, 130);
  final Vector2 sleepingPosition = Vector2(131, 39);
  final Vector2 relaxPosition = Vector2(74, 113);
  late final SpriteComponent tv;
  PlayerState current = PlayerState.idle;

  // Constructor to accept the UserNotifier
  MyGame(this.userNotifier);

  @override
  Color backgroundColor() {
    return const Color(0x00000000);
  }

  @override
  Future<void> onLoad() async {
    await images.loadAllImages();
    // Load background image
    final backgroundSprite = await Flame.images.load('room1.png');
    // Load tv image
    final tvSprite = await Flame.images.load('sprite_tv.png');

    // Create SpriteComponent for the background
    final background = SpriteComponent(
        sprite: Sprite(backgroundSprite),
        size: Vector2(520, 295), // Adjust to fit the game screen
        position: Vector2(-80, -10));

    // Create SpriteComponent for the tv
    tv = SpriteComponent(
        sprite: Sprite(tvSprite),
        size: Vector2(87, 87), // Adjust to fit the game screen
        position: Vector2(45, 81));

    // Add the background to the game
    add(background);

    player = createNewPlayer(userNotifier.username, 'idle');

    // player1 = Player(character: "character1", position: idlePosition);
    // uiPlayersMap['player1'] = player1;

    Player npc1 = Player(character: "character1", position: tablePosition[1]);
    Player npc2 = Player(character: "character1", position: tablePosition[2]);

    // add(player1);
    add(npc1);
    add(npc2);

    npc1.setAnimation(PlayerState.studying);
    npc2.setAnimation(PlayerState.studying);
  }

  @override
  void update(double dt) {
    monitorOtherPlayers('123abc', userNotifier.username);
    // TODO: implement update
    super.update(dt);
  }

  void changePlayerAnimation(PlayerState state, String username) {
    if (current != state) {
      player.setAnimation(state);
      player.position = tablePosition[0];
      if (state == PlayerState.studying) {
        AddLog.addToList(LogDisplay(
            name: username,
            activity: "Dived into study mode, locking in",
            time: AddLog.formatTime(DateTime.now())));
        current = PlayerState.studying;
        if (addTv) {
          remove(tv);
          addTv = false;
        }
      }
      if (state == PlayerState.idle) {
        AddLog.addToList(LogDisplay(
            name: username,
            activity: "Is idling",
            time: AddLog.formatTime(DateTime.now())));
        current = PlayerState.idle;
        player.position = idlePosition;
        if (addTv) {
          remove(tv);
          addTv = false;
        }
      }
      if (state == PlayerState.sleeping) {
        AddLog.addToList(LogDisplay(
            name: username,
            activity: "Drifted off for a quick recharge",
            time: AddLog.formatTime(DateTime.now())));
        current = PlayerState.sleeping;
        player.position = sleepingPosition;
        if (addTv) {
          remove(tv);
          addTv = false;
        }
      }
      if (state == PlayerState.relax) {
        AddLog.addToList(LogDisplay(
            name: username,
            activity: "Taking a moment of rest",
            time: AddLog.formatTime(DateTime.now())));
        current = PlayerState.relax;
        player.position = relaxPosition;
        add(tv);
        addTv = true;
      }
    }
    return;
  }

  Player createNewPlayer(String userId, String state) {
    late Vector2 position;
    late PlayerState initialState;
    switch (state) {
      case 'bed':
        position = sleepingPosition;
        initialState = PlayerState.sleeping;
        break;
      case 'couch':
        position = relaxPosition;
        initialState = PlayerState.relax;
        break;
      case 'idle':
        position = idlePosition;
        initialState = PlayerState.idle;
        break;
      case 'table1':
        position = tablePosition[0];
        initialState = PlayerState.studying;
        break;
      case 'table2':
        position = tablePosition[1];
        initialState = PlayerState.studying;
        break;
      case 'table3':
        position = tablePosition[2];
        initialState = PlayerState.studying;
        break;
    }

    // Create a new player instance with the specified character and position
    Player player = Player(character: 'character1', position: position);
    uiPlayersMap[userId] = player;

    // Add the new player to the game
    add(player);

    // Set the player's initial animation state
    player.setAnimation(initialState);
    if (state == PlayerState.studying) {
      current = PlayerState.studying;
      if (addTv1) {
        remove(tv);
        addTv1 = false;
      }
    }
    if (state == PlayerState.idle) {
      current = PlayerState.idle;
      player.position = idlePosition;
      if (addTv1) {
        remove(tv);
        addTv1 = false;
      }
    }
    if (state == PlayerState.sleeping) {
      current = PlayerState.sleeping;
      player.position = sleepingPosition;
      if (addTv1) {
        remove(tv);
        addTv1 = false;
      }
    }
    if (state == PlayerState.relax) {
      current = PlayerState.relax;
      player.position = relaxPosition;
      add(tv);
      addTv1 = true;
    }

    // Initialize the player's state in the map
    playerStates[userId] = state;

    DbService.moveUserToArea('123abc', userId, state);

    AddLog.addToList(LogDisplay(
        name: userId,
        activity: "joined the room!",
        time: AddLog.formatTime(DateTime.now())));

    return player;
  }

  Future<void> removePlayer(String roomId, String userId) async {
    try {
      // Wait for the document ID
      String? documentId =
          await DbService.searchField('userId', userId, roomId);

      if (documentId == null) {
        return;
      }

      // Remove player from game if it exists
      Player? player = uiPlayersMap[userId];
      if (player != null) {
        remove(player);
        // player.removeFromParent();
        uiPlayersMap.remove(userId);
        playerStates.remove(userId);
      }

      // Update Firestore
      await DbService.deleteField(documentId, 'userId', roomId);
      await DbService.modifyField(documentId, 'occupied', false, roomId);
    } catch (e) {
      // Handle error appropriately
    }
  }

  void monitorOtherPlayers(String roomId, String currentUserId) {
    // Start listening to the area stream
    DbService.areaStream(roomId).listen((QuerySnapshot snapshot) {
      // Iterate through the documents in the areas collection
      for (var doc in snapshot.docs) {
        // Extract the userId from the document
        final data = doc.data() as Map<String, dynamic>;
        final areaUserId = data['userId'];

        // Check if the userId is not the current user's
        if (areaUserId != null && areaUserId != currentUserId) {
          if (!playerExists(areaUserId)) {
            // Check if player already exists
            final areaDocId = doc.id.toString();
            createNewPlayer(areaUserId, areaDocId); // Create new player
          } else {
            // If player exists, update animation if areaUserId has changed
            final areaDocId = doc.id.toString();
            updatePlayerAnimation(areaUserId, areaDocId);
          }
        }
        // else {
        //   // Remove the player from the UI if no userId or user left the area
        //   if (areaUserId != null) {
        //     removePlayer(areaUserId);
        //   }
        // }
      }
    });
  }

  void updatePlayerAnimation(String areaUserId, String state) {
    Player? player = uiPlayersMap[areaUserId];

    if (player == null) return;

    if (playerStates[areaUserId] == state) {
      return; // State hasn't changed, no need to update
    }

    late Vector2 position;
    late PlayerState updatedState;

    switch (state) {
      case 'bed':
        position = sleepingPosition;
        updatedState = PlayerState.sleeping;
        if (addTv1) {
          remove(tv);
          addTv1 = false;
        }
        AddLog.addToList(LogDisplay(
            name: areaUserId,
            activity: "Drifted off for a quick recharge",
            time: AddLog.formatTime(DateTime.now())));
        break;
      case 'couch':
        position = relaxPosition;
        updatedState = PlayerState.relax;
        add(tv);
        addTv1 = true;
        AddLog.addToList(LogDisplay(
            name: areaUserId,
            activity: "Taking a moment of rest",
            time: AddLog.formatTime(DateTime.now())));
        break;
      case 'idle':
        position = idlePosition;
        updatedState = PlayerState.idle;
        if (addTv1) {
          remove(tv);
          addTv1 = false;
        }
        AddLog.addToList(LogDisplay(
            name: areaUserId,
            activity: "Is idling",
            time: AddLog.formatTime(DateTime.now())));
        break;
      case 'table1':
        position = tablePosition[0];
        updatedState = PlayerState.studying;
        if (addTv1) {
          remove(tv);
          addTv1 = false;
        }
        AddLog.addToList(LogDisplay(
            name: areaUserId,
            activity: "Dived into study mode, locking in",
            time: AddLog.formatTime(DateTime.now())));
        break;
      // case 'table2':
      //   position = tablePosition[1];
      //   updatedState = PlayerState.studying;
      //   break;
      // case 'table3':
      //   position = tablePosition[2];
      //   updatedState = PlayerState.studying;
      //   break;
      default:
        return;
    }

    player.setAnimation(updatedState);
    player.position = position;

    // Update the player's state in the map to prevent redundant updates
    playerStates[areaUserId] = state;
  }

  bool playerExists(String areaUserId) {
    for (var player in uiPlayersMap.keys) {
      if (player == areaUserId) {
        return true; // Found the player with areaUserId
      }
    }
    return false; // Not found
  }
}

// TIMER NOT IN SYNC
