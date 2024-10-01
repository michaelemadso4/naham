import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:naham/feutcher/Auth/Login/view/widgets/btnLogin.dart';
import 'package:naham/feutcher/Contacts/controller/chatMainScreen/chatCallController.dart';
import 'package:naham/feutcher/Contacts/controller/userinfoController.dart';
import 'package:naham/feutcher/Contacts/model/userprofielmodel.dart';
import 'package:naham/feutcher/Contacts/view/screen/CallScreen/CallScreen.dart';
import 'package:naham/feutcher/Contacts/view/widgets/Text/Body1_txt.dart';
import 'package:naham/feutcher/Contacts/view/widgets/Text/BodyDialog.dart';
import 'package:naham/feutcher/Contacts/view/widgets/Text/Titletxt.dart';
import 'package:naham/feutcher/Contacts/view/widgets/Text/titleDialog.dart';
import 'package:naham/helper/ToastMessag/toastmessag.dart';
import 'package:naham/helper/WebService/webServiceConstant.dart';
import 'package:naham/helper/colors/colorsconstant.dart';
import 'package:naham/helper/nativeChannel/naitiveChannel.dart';
import 'package:naham/helper/sherdprefrence/shardprefKeyConst.dart';
import 'package:naham/helper/sherdprefrence/sharedprefrenc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:permission_handler/permission_handler.dart';


class SendNotificationController extends GetxController{
  BuildContext context ;
  SendNotificationController(this.context);

  late WebSocketChannel _channel;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _connectToChatSocketServer();
    requestNotificationPermission();
  }
  Future<void> requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
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
    _channel.stream.listen((message) async {
      final data = jsonDecode(message);
      print(data);

      if(data["type"]=="Calling"){
        ShowCallingNotification("title","body",data);
      }

      //String result = await NativeChannel().invokeNativeMethod(arg1: "title",arg2: "body");
      //print(result);
      update();
    },
    onDone: _handleWebSocketDisconnection,
      onError: _handleWebSocketError
    );
  }
  void _handleWebSocketDisconnection() {
    Fluttertoast.showToast(
      msg: "WebSocket disconnected!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    Future.delayed(Duration(seconds: 1), _restartConnection);
  }

  void _handleWebSocketError(error) {
    print("WebSocket error: $error");
    Fluttertoast.showToast(
      msg: "WebSocket error: $error!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    Future.delayed(Duration(seconds: 1), _restartConnection);
  }
  Future<void> _restartConnection() async {

    _connectToChatSocketServer();

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

  ShowCallingNotification(title,body,payload) async {
   await GetUserInfo(payload['payload']['sender_id']);
    showDialog(context: context, builder: (context){
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
                    child:IconButton(icon: Icon(Icons.call_end,color: Colors.white,size: 30,),onPressed: (){
                      DeclineCall(payload['payload']['sender_id']);
                    },),),
                  ),
                  Expanded(
                    child: CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.green,
                    child:IconButton(icon: Icon(Icons.call,color: Colors.white,size: 30),onPressed: () async {
                      await AcceptCall(payload['payload']['sender_id']);
                      /////////////////////////////////////////////////////////////
                    await  Future.delayed(Duration(seconds:3));
                      DurationCall();

                    },),),
                  )
                ],
              )
            ],
          ),

      ));
    });
  }


  DurationCall(){

    showToast(text: "STaaaaaaaaaaaaaaaaaaaaaaart Takinkg", state: ToastState.SUCCESS);
  }
  SendNotification()async{
    var myuserid = CacheHelper.getData(key: useridKey);
    int reciver_id = CacheHelper.getData(key: userprofielkey);
      var map ={"type":"Calling","payload":{"sender_id":myuserid}
        ,"to_user_id":reciver_id};
    _channel.sink.add(jsonEncode(map));
  }
  void DeclineCall(reciver_id) async{
    var myuserid = CacheHelper.getData(key: useridKey);
    await CacheHelper.saveData(key: userprofielkey, value: reciver_id);
    var map ={"type":"decline_calling","payload":{"sender_id":myuserid}
      ,"to_user_id":reciver_id};
    _channel.sink.add(jsonEncode(map));

    Get.back();
  }


  Future<void> AcceptCall(reciver_id) async {
    var myuserid = CacheHelper.getData(key: useridKey);
    await CacheHelper.saveData(key: userprofielkey, value: reciver_id);
    var map ={"type":"accept_calling","payload":{"sender_id":myuserid}
      ,"to_user_id":reciver_id};
     _channel.sink.add(jsonEncode(map));


    Get.back();
    Get.to(() => CallScreen(),arguments: {});

  }
}


