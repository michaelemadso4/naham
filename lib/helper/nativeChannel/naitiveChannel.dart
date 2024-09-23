import 'package:flutter/services.dart';

class NativeChannel {
  //static const platform = MethodChannel('com.tadafuq.naham');

  // Call a method on the Android side
  Future<String> invokeNativeMethod() async {
    try {
      var platform = MethodChannel('com.tadafuq.naham');
      final String result = await platform.invokeMethod('startForegroundService');
      return result;
    } on PlatformException catch (e) {
      return "Failed to get native data: '${e.message}'.";
    }
  }
}