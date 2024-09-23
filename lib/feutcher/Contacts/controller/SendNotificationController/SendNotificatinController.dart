import 'dart:convert';

import 'package:get/get.dart';
import 'package:naham/helper/nativeChannel/naitiveChannel.dart';
import 'package:naham/helper/sherdprefrence/shardprefKeyConst.dart';
import 'package:naham/helper/sherdprefrence/sharedprefrenc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SendNotificationController extends GetxController{
  late WebSocketChannel _channel;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _connectToChatSocketServer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _channel.sink.close();
    super.dispose();
  }
  @override
  void onClose() {
    // TODO: implement onClose
    _channel.sink.close();
    super.onClose();
  }
  void _connectToChatSocketServer() {
    var myuserid = CacheHelper.getData(key: useridKey);
    var usertoken = CacheHelper.getData(key: access_tokenkey);
    _channel = WebSocketChannel.connect(Uri.parse('wss://naham.tadafuq.ae?user_id=${myuserid}&token=$usertoken'));
    print("close reason ${_channel.closeReason}"  );
    _channel.stream.listen((message) {
      final data = jsonDecode(message);

      update();
    });
  }

  SendNotification()async{
    String result = await NativeChannel().invokeNativeMethod();
    print(result);
    // int reciver_id = CacheHelper.getData(key: userprofielkey);
    // _channel.sink.add({"message":"Hello World","to_user_id":reciver_id});
  }

}