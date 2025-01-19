import 'dart:async';
import 'dart:math';

import 'package:get/get.dart';
import 'package:productivity_app_v1/services/db_service.dart';
import 'package:productivity_app_v1/ui/screens/focus_room_screen/focus_room_screen.dart';

class TimerController extends GetxController {
  Timer? _timer;
  int remainingSeconds = 1;
  final time = '60:00'.obs;
  final isTimerRunning =
      false.obs; // Reactive boolean to control the timer state

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.onClose();
  }

  _startTimer(int seconds) {
    if (isTimerRunning.value) return; // Do not start if already running

    const duration = Duration(seconds: 1);
    remainingSeconds = seconds;
    isTimerRunning.value = true; // Mark that the timer is running
    _timer = Timer.periodic(duration, (Timer timer) {
      if (remainingSeconds == 0) {
        timer.cancel();
      } else {
        int minutes = remainingSeconds ~/ 60;
        int seconds = remainingSeconds % 60;
        time.value =
            "${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}";
        remainingSeconds--;
      }
    });
  }

  void listenToFirestoreTimer(String roomId) {
    DbService.listenToSharedTimer(roomId).listen((data) {
      if (data['timerStarted'] == true && !isTimerRunning.value) {
        FocusRoomScreen.globalKey.currentState?.setTimerStarted(true);
        _startTimer(data['timerDuration'] * 60);
      } else if (data['timerStarted'] == false && isTimerRunning.value) {
        FocusRoomScreen.globalKey.currentState
            ?.setTimerStarted(false); //FIX THISSSSS
        cancelTimer();
      }
    });
  }

  // Method to update the time based on the slider value
  void updateTime(int sliderValue) {
    int minutes = sliderValue.floor(); // Slider value represents total minutes
    int seconds = ((sliderValue - minutes) * 60)
        .round(); // Convert fractional part to seconds
    time.value =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    DbService.setSharedTimer('123abc', sliderValue);
  }

  void startTimer(int minutes) {
    if (!isTimerRunning.value) {
      DbService.startSharedTimer('123abc', minutes);
      _startTimer(
          minutes * 60); // Default duration if not provided by the button
    }
  }

  void cancelTimer() {
    if (_timer != null) {
      remainingSeconds = 0;
      time.value = '00:00';
      DbService.resetSharedTimer('123abc');
      _timer!.cancel();
      isTimerRunning.value = false; // Reset the running state
    }
  }
}
