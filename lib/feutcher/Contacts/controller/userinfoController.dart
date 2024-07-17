import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:naham/helper/WebService/webServiceConstant.dart';
import 'package:naham/helper/sherdprefrence/shardprefKeyConst.dart';
import 'package:naham/helper/sherdprefrence/sharedprefrenc.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';


class UserInfoController extends GetxController{
  int userid = 0;
  @override
  void onInit() {
    // TODO: implement onInit
    userid = CacheHelper.getData(key: userprofielkey);
    print(userid);
    super.onInit();
  }

  Future GetUserInfo()async{
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
      return response.data;
    }
    else {
      print(response.statusMessage);
    }
    }catch(e){
      print(e);
    }
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
  SendPhoto(context,id)async{
    print('test');
    try{
      String access_token =  CacheHelper.getData(key: access_tokenkey);
      var headers = {
        'Authorization': 'Bearer ${access_token}'
      };

      var request = http.MultipartRequest('POST', Uri.parse('${apiurl}user/send-message'));

      request.fields.addAll({
        'receiver_id': '${id}',

      });

      if (myfile != null) {
        request.files.add(await http.MultipartFile.fromPath('image', '${myfile!.path}'));
      }

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if(response.statusCode == 200){

        myfile = null;
        // print(await response.stream.bytesToString());
        var data = jsonDecode(await response.stream.bytesToString());
        print(data['data']['path']);
        print(data['data']['type']);
        update();

      }
      else {

        myfile = null;
        showDialog(context: context, builder: (context){
          return AlertDialog(
            title: Text('${response.reasonPhrase}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Close'),
              ),
            ],
          );
        });
        update();
        print(response.reasonPhrase);
      }
    }catch(e){
      print(e);
    };
  }

  ClearVideo()async{
    // myVideo = null;
    update();
  }


  // Send Location

  openLocation(urlmap)async{
    final Uri url = Uri.parse('${urlmap}');
    if (await launchUrl(url)) {
      throw Exception('Could not launch ${url}');
    }

  }
  String latitude = '';
  String longitude = '';
  bool isSend =false;
  SendLocation(context,id)async{
    isSend =true;
    update();
    try {

      await Geolocator.checkPermission();
      await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      latitude = position.latitude.toString();
      longitude = position.longitude.toString();
      print(latitude + longitude);
      isSend =false;
      update();
      // showToast(text: latitude + " / " + longitude, state: ToastState.SUCCESS);
    }catch(e){
      print(e);
      Geolocator.getLastKnownPosition(forceAndroidLocationManager: true);
      isSend =false;
      update();
    }
    /*

    */
  }
  SendLocatio(context,id)async{
    try{
      String access_token =  CacheHelper.getData(key: access_tokenkey);
      var headers = {
        'Authorization': 'Bearer ${access_token}'
      };

      var request = http.MultipartRequest('POST', Uri.parse('${apiurl}user/send-message'));

      request.fields.addAll({
        'receiver_id': '${id}',
        // 'message': '${tecchat.text.trim()}',
        'location_link': 'https://www.google.com/maps/search/?api=1&query=${latitude},${longitude}',
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if(response.statusCode == 200){

        print(await response.stream.bytesToString());
        latitude ='';
        longitude='';
        update();

      }
      else {
        showDialog(context: context, builder: (context){
          return AlertDialog(
            title: Text('${response.reasonPhrase}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Close'),
              ),
            ],
          );
        });
        update();
        print(response.reasonPhrase);
      }
    }catch(e){
      print(e);
    }
  }
  //Send File
  String filePath = '';
  FilePickerResult? result;
  PickfileFromGalary()async{
    result= await FilePicker.platform.pickFiles(type: FileType.custom,
        allowedExtensions: ['doc','pdf']
    );
    if(result !=null){
      filePath = result!.files.single.path!;
      update();
    }
  }
  bool FileSendded= false;

  SendFile(context,id)async{
    try{
      FileSendded = true;
      update();
      String access_token =  CacheHelper.getData(key: access_tokenkey);
      var headers = {
        'Authorization': 'Bearer ${access_token}'
      };

      var request = http.MultipartRequest('POST', Uri.parse('${apiurl}user/send-message'));

      request.fields.addAll({
        'receiver_id': '${id}',

      });

      if(result!= null){
        request.files.add(await http.MultipartFile.fromPath('sheet', '${filePath}'));
      }

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if(response.statusCode == 200){

        filePath = '';
        // print(await response.stream.bytesToString());
        FileSendded = false;
        var data = jsonDecode(await response.stream.bytesToString());
        print(data['data']['path']);
        print(data['data']['type']);


        update();

      }
      else {
        filePath = '';
        showDialog(context: context, builder: (context){
          return AlertDialog(
            title: Text('${response.reasonPhrase}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Close'),
              ),
            ],
          );
        });
        update();
        print(response.reasonPhrase);
      }
    }catch(e){
      print(e);
    };
  }
}