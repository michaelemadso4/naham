import 'dart:convert';
import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:naham/helper/WebService/webServiceConstant.dart';
import 'package:naham/helper/sherdprefrence/shardprefKeyConst.dart';
import 'package:naham/helper/sherdprefrence/sharedprefrenc.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

class FirbaseChatController extends GetxController{
  String name = CacheHelper.getData(key: 'nameuser');
  String email = CacheHelper.getData(key: 'emailuser');
  String img = CacheHelper.getData(key: 'imguser');
  String userUID = CacheHelper.getData(key: 'userUID');
  int id = CacheHelper.getData(key: 'iduser');

   TextEditingController msgtec = TextEditingController();

  bool isRecording = false;
  String audioPath='';
  // late AudioPlayer audioPlayer ;
  // final AudioRecorder recorder = AudioRecorder();
  double currentPosition = 0 ;
  double totalDuration = 0 ;

  late String currentUser ;

  @override
  void onInit() {
    // TODO: implement onInit

    currentUser =FirebaseAuth.instance.currentUser!.uid;
    // homeController = HomeController();
    // homeController.FirebaseNotificationService();
    boolList=  List.generate(100, (index) => false);
    // audioPlayer = AudioPlayer();
    super.onInit();
  }

  /*
  startRecording()async{
    final bool isPermissionGrandted = await recorder.hasPermission();
    if(!isPermissionGrandted){
      return;
    }
    final directory =  await getApplicationDocumentsDirectory();
    String filename = 'recording ${DateTime.now().millisecondsSinceEpoch}.m4a';
    audioPath = '${directory.path}/$filename';
    const config = RecordConfig(
        encoder: AudioEncoder.aacLc,
        sampleRate: 44100,bitRate: 128000
    );
    await recorder.start(config, path: audioPath);
    isRecording = true ;
    update();

  }
   */
  late List<bool> boolList;
/*
  stopRecording()async{
    final path = await recorder.stop();
    isRecording = false;
    update();
  }

   */
/*
  Future<void> playRecorderReciver(url,index)async{
    if(url != null){
      await audioPlayer.setUrl(url);
      totalDuration = audioPlayer.duration?.inSeconds.toDouble()??0;
      audioPlayer.play();
      audioPlayer.positionStream.listen((position) {
        currentPosition = position.inSeconds.toDouble();
        boolList[index] = true;
        update();
      });
    }
  }

 */
  /*
  StopReecoreder(url,index)async{
    if(url != null){
      await audioPlayer.setUrl(url);
      audioPlayer.stop();
      boolList[index] = false;update();
    }
  }
   */

  /*
  Future<void> playRecorder()async{
    print(audioPath);
    if(audioPath != null){
      await audioPlayer.setFilePath(audioPath!);
      totalDuration = audioPlayer.duration?.inSeconds.toDouble()??0;
      audioPlayer.play();
      audioPlayer.positionStream.listen((position) {
        currentPosition = position.inSeconds.toDouble();
        update();
      });
    }
  }
   */
  onChnagerecordr(value){
    currentPosition = value;
    update();
  }

  ClearRecorder(){
    audioPath = '';
    update();
  }


  SendCallToUSer(receiver_id)async{
    String access_token =  CacheHelper.getData(key: access_tokenkey);
    String sinderid =CacheHelper.getData(key: useridKey).toString();
    print("++++++++++++++++${receiver_id}__________________${sinderid}");
    // /*
    var headers = {
      'Authorization': 'Bearer ${access_token}'
    };
    var data = {
      'receiver_id': '${receiver_id}',
      'sender_id': '${sinderid}'
    };
    try{
      Dio dio = Dio();
      var response = await dio.request(
        '${apiurl}${apirequstCall}',
        options: Options(
          method: 'POST',
          headers: headers,
          validateStatus: (status) => true,

        ),
        data: data,
      );
      if(response.statusCode==200){
        print(response.data['message']);
      }
    }catch(e){}
    // */
  }

  List<File> myfilelist=[];
  File ?myfile;
  File ?file;
  bool isshowDialog = false;
  String ?fileName;

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
  File ? myVideo;
  final picker = ImagePicker();
  /*
  VideoPlayerController ?videoPlayerController ;
  PickVideoFromGalary()async{
    final video = await picker.pickVideo(source: ImageSource.gallery, );
    myVideo= File(video!.path);
    videoPlayerController = VideoPlayerController.file(myVideo!)..initialize().then((value){
      update();
    });
    videoPlayerController!.play();
    Get.back();
  }

   */
  /*
  PickVideoFromCamera()async{
    final video = await picker.pickVideo(source: ImageSource.camera, );
    myVideo= File(video!.path);
    videoPlayerController = VideoPlayerController.file(myVideo!)..initialize().then((value){
      update();
    });
    videoPlayerController!.play();
    Get.back();
  }
   */
  /*
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
    Get.back();
  }
   */
  ClearPhoto()async{
    myfile = null;
    update();
  }ClearVideo()async{
    myVideo = null;
    update();
  }


  openLocation(urlmap)async{
    final Uri url = Uri.parse('${urlmap}');
    if (await launchUrl(url)) {
      throw Exception('Could not launch ${url}');
    }

  }
  String latitude = '';
  String longitude = '';
  //
  /*
  SendLocation(context)async{
    try {
      await Geolocator.checkPermission();
      await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      latitude = position.latitude.toString();
      longitude = position.longitude.toString();
      print(latitude + longitude);
      // showToast(text: latitude + " / " + longitude, state: ToastState.SUCCESS);
    }catch(e){
      print(e);
      Geolocator.getLastKnownPosition(forceAndroidLocationManager: true);
    }
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
        final currentUser = FirebaseAuth.instance.currentUser;
        final conversationId = getConversationId();

        await FirebaseFirestore.instance.collection('conversations')
            .doc(conversationId)
            .collection('messages')
            .add({
          "id": null,
          "sender_id": currentUser!.uid,
          "receiver_id": id,
          "message": null,
          "path": null,
          "type": "location",
          "location_link": "https://www.google.com/maps/search/?api=1&query=${latitude},${longitude}",
          'createdAt': Timestamp.now(),


        });


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

   */
  // SEND PHOTO
  SendPhoto(context)async{
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
        final currentUser = FirebaseAuth.instance.currentUser;
        final conversationId = getConversationId();

        await FirebaseFirestore.instance.collection('conversations')
            .doc(conversationId)
            .collection('messages')
            .add({
          "id": null,
          "sender_id": currentUser!.uid,
          "receiver_id": id,
          "message": null,
          "path": data['data']['path'],
          "type": data['data']['type'],
          "location_link": null,
          'createdAt': Timestamp.now(),


        });


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
  //SEND VIDEO
  bool VideoSendded= false;
  SendVideo(context)async{
    try{
      VideoSendded = true;
      update();
      String access_token =  CacheHelper.getData(key: access_tokenkey);
      var headers = {
        'Authorization': 'Bearer ${access_token}'
      };

      var request = http.MultipartRequest('POST', Uri.parse('${apiurl}user/send-message'));

      request.fields.addAll({
        'receiver_id': '${id}',

      });

      if (myVideo != null) {
        request.files.add(await http.MultipartFile.fromPath('video', '${myVideo!.path}'));
      }

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if(response.statusCode == 200){

        myVideo = null;
        VideoSendded = false ;
        update();
        // print(await response.stream.bytesToString());
        var data = jsonDecode(await response.stream.bytesToString());
        print('hello');
        print(data['data']['path']);
        print(data['data']['type']);
        final currentUser = FirebaseAuth.instance.currentUser;
        final conversationId = getConversationId();

        await FirebaseFirestore.instance.collection('conversations')
            .doc(conversationId)
            .collection('messages')
            .add({
          "id": null,
          "sender_id": currentUser!.uid,
          "receiver_id": id,
          "message": null,
          "path": data['data']['path'],
          "type": data['data']['type'],
          "location_link": null,
          'createdAt': Timestamp.now(),


        });
        update();

      }
      else {
        myVideo = null;
        VideoSendded = false ;
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

  bool FileSendded= false;

  /*
  SendFile(context)async{
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
        final currentUser = FirebaseAuth.instance.currentUser;
        final conversationId = getConversationId();

        await FirebaseFirestore.instance.collection('conversations')
            .doc(conversationId)
            .collection('messages')
            .add({
          "id": null,
          "sender_id": currentUser!.uid,
          "receiver_id": id,
          "message": null,
          "path": data['data']['path'],
          "type": data['data']['type'],
          "location_link": null,
          'createdAt': Timestamp.now(),


        });


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

   */
//////////////
  bool RecordSended= false;
  SendRecord(context)async{
    try{
      RecordSended = true;
      String access_token =  CacheHelper.getData(key: access_tokenkey);
      var headers = {
        'Authorization': 'Bearer ${access_token}'
      };

      var request = http.MultipartRequest('POST', Uri.parse('${apiurl}user/send-message'));

      request.fields.addAll({
        'receiver_id': '${id}',

      });

      if (audioPath != ''){
        request.files.add(await http.MultipartFile.fromPath('voice', '${audioPath}'));
      }
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if(response.statusCode == 200){

        audioPath = '';
        RecordSended = false ;
        var data = jsonDecode(await response.stream.bytesToString());
        print(data['data']['path']);
        print(data['data']['type']);
        final currentUser = FirebaseAuth.instance.currentUser;
        final conversationId = getConversationId();

        await FirebaseFirestore.instance.collection('conversations')
            .doc(conversationId)
            .collection('messages')
            .add({
          "id": null,
          "sender_id": currentUser!.uid,
          "receiver_id": id,
          "message": null,
          "path": data['data']['path'],
          "type": data['data']['type'],
          "location_link": null,
          'createdAt': Timestamp.now(),


        });

        update();

      }
      else {
        audioPath = '';
        RecordSended = false ;
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









  TextEditingController messageController = TextEditingController();

  String getConversationId() {
    final currentUser = FirebaseAuth.instance.currentUser;
    final otherUserId = userUID;
    return currentUser!.uid.compareTo(otherUserId) < 0
        ? '${currentUser.uid}_${otherUserId}'
        : '${otherUserId}_${currentUser.uid}';
  }



  sendMessage()async{

    final enteredText = messageController.text;
    if (enteredText.trim().isEmpty) {
      return;
    }

    String access_token =  CacheHelper.getData(key: access_tokenkey);
    String sinderid =CacheHelper.getData(key: useridKey).toString();
    try{
      var headers = {
        'Authorization': 'Bearer ${access_token}'      };
      var data = {
        'receiver_id': '${id}',
        'message': enteredText
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
        // print(json.encode(response.data));
        var databody = json.encode(response.data);
        print(response.data['data']['message']);

        // /*
        final currentUser = FirebaseAuth.instance.currentUser;
        final conversationId = getConversationId();

        await FirebaseFirestore.instance.collection('conversations')
            .doc(conversationId)
            .collection('messages')
            .add({
          "id": null,
          "sender_id": currentUser!.uid,
          "receiver_id": id,
          "message": enteredText,
          "path": null,
          "type": "message",
          "location_link": null,
          'createdAt': Timestamp.now(),
        });
        messageController.clear();

         // */
      }
      else {
        print(response.statusMessage);
      }

    }catch(e){
      print(e);
    }


  }



}