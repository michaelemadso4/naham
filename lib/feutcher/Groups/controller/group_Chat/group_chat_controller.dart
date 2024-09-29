import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dioh;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:naham/feutcher/Groups/model/GrAllMessageModel.dart';
import 'package:naham/feutcher/Groups/model/GrMsgSendModel.dart';
import 'package:naham/helper/WebService/webServiceConstant.dart';
import 'package:naham/helper/sherdprefrence/shardprefKeyConst.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../../helper/sherdprefrence/sharedprefrenc.dart';

class GroupChatController extends GetxController{

  late WebSocketChannel webSocketChannel;
  void connectToChatSocketServer() {
    var myuserid = CacheHelper.getData(key: useridKey);
    var usertoken = CacheHelper.getData(key: access_tokenkey);
    webSocketChannel = WebSocketChannel.connect(Uri.parse('wss://naham.tadafuq.ae?user_id=${myuserid}&token=$usertoken'));
    print("close reason ${webSocketChannel.closeReason}"  );
    webSocketChannel.stream.listen((message) {
      final data = jsonDecode(message);
      if(data["type"]=="gr_msg"){
        print("data comingss from socket " + message);
        allMessage.insert(0,data);
      }else{
        print("object");
      }
      // messages.insert(0,ChatMessage.fromJson(data));
      update();

    });
  }
  List allMessage = [];

  FetchAllMessage()async{
    var group_id = Get.arguments['group_id'];
    String access_token =  CacheHelper.getData(key: access_tokenkey);

    var headers = {
      'Authorization': 'Bearer ${access_token}'
    };
    var dio = dioh.Dio();
    var response = await dio.request(
      '${apiurl}user/get-group-messages?group_id=${group_id}',
      options: dioh.Options(
        method: 'GET',
        headers: headers,
      ),
    );

    if (response.statusCode == 200) {
      print(json.encode(response.data));

      allMessage = response.data['data']['data'];
      update();
    }
    else {
      print(response.statusMessage);
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    connectToChatSocketServer();
    FetchAllMessage();
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    DismissFun();
    super.onClose();
  }

  DismissFun(){
    webSocketChannel.sink.close();
  }

  Future GetGroupInfo() async {

    var group_id = Get.arguments['group_id'];
    String access_token =  CacheHelper.getData(key: access_tokenkey);

    var headers = {
      'Authorization': 'Bearer ${access_token}'
    };
    try{
      var dio = dioh.Dio();
      var response = await dio.request(
        '${apiurl}user/specific_group/${group_id}',
        options: dioh.Options(
          method: 'GET',
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {
        print(json.encode(response.data));
        return response.data;
      }
      else {
        print(response.statusMessage);
      }
    }catch(e){
      print(e);
    }
  }

  TextEditingController messageTec = TextEditingController();
  SendMessage()async{
    String access_token =  CacheHelper.getData(key: access_tokenkey);
    var group_id = Get.arguments['group_id'];
    var headers = {
      'Authorization': 'Bearer ${access_token}'
    };

    var data = dioh.FormData.fromMap({
      'group_id': group_id,
      'message': messageTec.text
    });

    var dio = dioh.Dio();
    var response = await dio.request(
      '${apiurl}user/send-group-message',
      options: dioh.Options(
        method: 'POST',
        headers: headers,
      ),
      data: data,
    );

    if (response.statusCode == 200) {
      print(json.encode(response.data));
      GrMsgSendModel grMsgSendModel = GrMsgSendModel();
      grMsgSendModel = GrMsgSendModel.fromJson(response.data);

      Map msgSent = response.data['data'];
      msgSent["to_group_id"]=grMsgSendModel.data!.groupId;
      webSocketChannel.sink.add(jsonEncode(msgSent));

      ClearMessage();
    }
    else {
      print(response.statusMessage);
      ClearMessage();
    }
  }
  ClearMessage(){
    messageTec.clear();
    update();
  }

  List<File> myfilelist=[];
  File ? myfile ;
  File ?file;
  bool isshowDialog = false;
  String ?fileName;
  PickImagefromCamera()async{
    XFile? xfile = await ImagePicker().pickImage(
        source: ImageSource.camera, imageQuality: 10);
    myfile = File(xfile!.path);
    fileName = myfile!.path.split('/').last;
    isshowDialog = true;
    myfilelist.add(myfile!);
    Get.back();
    update();
  }
  PickImagefromGalary()async{
    XFile ? xfile = await  ImagePicker().pickImage(
        source: ImageSource.gallery, imageQuality: 25);
    myfile = File(xfile!.path);
    print(myfile);
    final bytes = myfile!.readAsBytesSync();
    fileName = myfile!.path.split('/').last;
    print(fileName);
    isshowDialog = true;
    myfilelist.add(myfile!);
    Get.back();
    update();
    // await UploadImage();
    // print(dfielss);
  }
  ClearPhoto()async{
    myfile = null;
    update();
  }
  SendImag() async {

    if(myfile !=null){

      String access_token =  CacheHelper.getData(key: access_tokenkey);

      var headers = {
        'Authorization': 'Bearer ${access_token}'
      };
      var data = dioh.FormData.fromMap({
        'group_id': '',
        'files': [
          await dioh.MultipartFile.fromFile(fileName!, filename: 'image')
        ],
      });

      var dio = dioh.Dio();
      var response = await dio.request(
        '${apiurl}user/send-group-message',
        options: dioh.Options(
          method: 'POST',
          headers: headers,
        ),
        data: data,
      );

      if (response.statusCode == 200) {
        print(json.encode(response.data));
      }
      else {
        print(response.statusMessage);
      }
    }
  }

}