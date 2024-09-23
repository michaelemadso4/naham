import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimeController extends GetxController{
  int counter = 0;
  Timer? _timer;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    startTimer();
  }
  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      counter++;
    update();
    });
  }
  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }
  @override
  void onClose() {
    // TODO: implement onClose
    _timer?.cancel();
    super.onClose();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _timer?.cancel();
    super.dispose();
  }
}