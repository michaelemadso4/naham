import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naham/helper/WebService/webServiceConstant.dart';
import 'package:naham/helper/sherdprefrence/shardprefKeyConst.dart';
import 'package:naham/helper/sherdprefrence/sharedprefrenc.dart';

import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';


class PusherChatController extends GetxController{


  List<String> messages = [];
  final TextEditingController msgTEC = TextEditingController();
  late WebSocketChannel channel;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    userid = CacheHelper.getData(key: userprofielkey);
    channel = IOWebSocketChannel.connect('ws://192.168.1.20:6001/app/localtyjtfhl554rthrtgff2?protocol=7&client=js&version=4.3.1&flash=false');
    channel.sink.add('{"event":"pusher:subscribe","data":{"channel":"chat.21"}}');
    channel.stream.listen((messages){
      var data = json.decode(messages);
      print("data${data}");
      var datadata= json.decode(data['data']);
      print(datadata);
      // /*
      if (data['event'] == 'pusher:connection_established') {
        // Subscribe to the private channel for the user
        String socketId = datadata['socket_id'];
        channel.sink.add(json.encode({
          "event": "pusher:subscribe",
          "data": {
            "channel": "chat.${userid}", // Optional: Include if authentication is needed
          }
        }));
      } else if (data['event'] == 'App\\Events\\MessageSent') {
        // Handle the received message
        messages.add(data['data']['message']);
        update();
      }

      // */
    });
    // initializePusher();
  }
  var userid ;


  void initializePusher() async {
     userid = CacheHelper.getData(key: userprofielkey);
     print(userid);

   }
   void sendMessage(String message,id) async {
     String access_token =  CacheHelper.getData(key: access_tokenkey);
     try {
     var headers = {
       'Authorization': 'Bearer ${access_token}'
     };
     var data = {
       'receiver_id': '$id',
       'message': '$message'
     };

     var dio = Dio();
     var response = await dio.request(
       '${apiurl}user/send-message',
       options: Options(
         method: 'POST',
         headers: headers,
       ),
       data: data,
     );

     if (response.statusCode == 200) {
       print(json.encode(response.data));
       channel.sink.add(json.encode({
         "event": "App/Events/MessageSent",
         "data": {
           "channel": "chat.21", // Optional: Include if authentication is needed
         "message":message
         }
       }));

       // channel.sink.add(message);
       update();
     }
     else {
       print(response.statusMessage);
     }}catch(e){
       print(e);
     }
   }
@override
  void dispose() {
    // TODO: implement dispose
  channel.sink.close();

  super.dispose();
  }
}