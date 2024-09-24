import 'package:flutter/services.dart';

class NativeChannel {
  //static const platform = MethodChannel('com.tadafuq.naham');

  // Call a method on the Android side
  Future<String> invokeNativeMethod({required String arg1, arg2}) async {
    try {
      var platform = MethodChannel('com.tadafuq.naham');
      final String result = await platform.invokeMethod('startForegroundService', {
        'arg1': '$arg1',
        'arg2': '$arg2',  // example of passing different types of data
      },);
      return result;
    } on PlatformException catch (e) {
      return "Failed to get native data: '${e.message}'.";
    }
  }
}