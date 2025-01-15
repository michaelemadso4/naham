import 'dart:convert';
import 'dart:ffi';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:naham/feutcher/Contacts/view/screen/CallScreen/CallScreen.dart';
import 'package:naham/feutcher/Contacts/view/widgets/Text/BodyDialog.dart';
import 'package:naham/helper/SocketController.dart';
import 'package:naham/helper/ToastMessag/toastmessag.dart';
import 'package:naham/helper/WebRTCController.dart';
import 'package:naham/helper/sherdprefrence/shardprefKeyConst.dart';
import 'package:naham/helper/sherdprefrence/sharedprefrenc.dart';

import '../../../../helper/WebService/webServiceConstant.dart';
import '../../model/userprofielmodel.dart';
import '../../view/screen/CallScreen/videoCall/vidocallScreen.dart';



class ChatCallController extends GetxController {


  BuildContext context ;
  ChatCallController(this.context);



  int userid = 0;
  late SocketController socketController;

  @override
  void onInit() async {
    super.onInit();

    socketController = SocketController();

// Registering listeners
    socketController.addMessageListener(_handleSocketMessage);

  }

  void _handleSocketMessage(dynamic message) {
    final data = jsonDecode(message as String); // Cast 'message' to String before decoding
    print("ChatCallController Data from socket: $message");
    CacheHelper.saveData(key: userprofielkey, value: data["sender_id"]);

    print(data['type']);
    print("UUUUUUUUUUUUUUUU${data["screen"]}");


    if(data["screen"] == "chat_call_screen"){
      switch (data['type']) {
        case 'calling':
          _handleCall(data);
          break;
        case 'video_calling':
          _handleVideoCalling(data);
          break;
        case 'endcalling':
          Get.back();
          break;
        case 'DeclineCall':
          Get.back();
          break;
      }
    }

  }
  UserprofileModel userProfileModel = UserprofileModel();
  GetUserInfo(userid)async{

    String access_token =  CacheHelper.getData(key: access_tokenkey);
    var headers = {
      'Authorization': 'Bearer ${access_token}'
    };
    try{
      var dio = Dio();
      var response = await dio.request(
        '${apiurl}user/user-profile/${userid}',
        options: Options(
          method: 'GET',
          headers: headers,
        ),
      );
      if (response.statusCode == 200) {
        print(json.encode(response.data));

        userProfileModel = UserprofileModel.fromJson(response.data);
        return response.data;
      }
      else {
        print(response.statusMessage);
      }
    }catch(e){
      print(e);
    }
  }
  final AudioPlayer audioPlayer = AudioPlayer();
  void _playRingtone() async {
    await audioPlayer.play(UrlSource("https://dl.prokerala.com/downloads/ringtones/files/mp3/classic-5916.mp3")); // Ensure the path is correct
  }

  @override
  void dispose()async {
    audioPlayer.dispose(); // Release resources
    await audioPlayer.stop();
    super.dispose();
  }

  ShowVideoCallingNotification(title,body,payload) async {
    _playRingtone();
    await GetUserInfo(payload['sender_id']);
    showDialog(context: context,barrierDismissible: false, builder: (context){
      return Center(
          child: Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(40)),
            height: 240,
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Titledialog(data: Calling,),
                BodyDialog(data: "Calling from ${userProfileModel.data!.name}"),
                SizedBox(height: 20,),
                Row(
                  children: [
                    Expanded(
                      child: CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.red,
                        child:IconButton(icon: Icon(Icons.call_end,color: Colors.white,size: 30,),onPressed: ()async{

                          await audioPlayer.stop();
                          Get.back();
                          DeclineCall();
                        },),),
                    ),
                    Expanded(
                      child: CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.green,
                        child:IconButton(icon: Icon(Icons.call,color: Colors.white,size: 30),onPressed: () async {
                          Get.back();
                          Get.to(() => VideoCallScreen(),arguments: {
                            "userProfileKey":userProfileModel.data!.id,"createOffer":true,
                          });

                          await audioPlayer.stop();

                        },),),
                    )
                  ],
                )
              ],
            ),

          ));
    });
  }

  ShowCallingNotification(title,body,payload) async {
    _playRingtone();
    await GetUserInfo(payload['sender_id']);
    showDialog(context: context,barrierDismissible: false,builder: (context){
      return Center(
          child: Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(40)),
            height: 240,
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Titledialog(data: Calling,),
                BodyDialog(data: "Calling from ${userProfileModel.data!.name}"),
                SizedBox(height: 20,),
                Row(
                  children: [
                    Expanded(
                      child: CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.red,
                        child:IconButton(icon: Icon(Icons.call_end,color: Colors.white,size: 30,),onPressed: ()async{

                          await audioPlayer.stop();
                          Get.back();
                          DeclineCall();
                        },),),
                    ),
                    Expanded(
                      child: CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.green,
                        child:IconButton(icon: Icon(Icons.call,color: Colors.white,size: 30),onPressed: () async {


                          await CacheHelper.saveData(key: userprofielkey, value:userProfileModel.data!.id );
                          Get.back();
                          Get.to(() => CallScreen(), arguments: {
                            "is_start_talking":
                            true,
                          });

                          await audioPlayer.stop();

                        },),),
                    )
                  ],
                )
              ],
            ),

          ));
    });
  }


  void SendCall(){
    _sendToServer({'type': 'calling'});
  }

  void sendVideoCalling(){
    _sendToServer({'type': 'video_calling'});
  }
  void DeclineCall(){
    _sendToServer({'type': 'DeclineCall'});
  }
  void EndCall(){
    _sendToServer({'type': 'endcalling'});

  }

  void _handleCall(Map<String, dynamic> data) async {

    ShowCallingNotification("title","body",data);

  }

  void _handleVideoCalling(Map<String, dynamic> data) async {
    ShowVideoCallingNotification("title","body", data);
  }

  void _sendToServer(Map<String, dynamic> message) {
    userid = CacheHelper.getData(key: userprofielkey);
    var myuserid = CacheHelper.getData(key: useridKey);
    message["to_user_id"] = userid;
    message["sender_id"]=myuserid;
    message["screen"] = "chat_call_screen";
    print("sending to $userid");
    print("sending from $myuserid");
    String jsonMessage = jsonEncode(message);
    print("ChatCallController Sending message: $jsonMessage");
    socketController.sendToServer(message);
  }


}
