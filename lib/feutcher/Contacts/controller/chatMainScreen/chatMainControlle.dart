import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:naham/feutcher/Contacts/model/ChatMessageModel.dart';
import 'package:naham/helper/WebService/webServiceConstant.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
// import 'package:video_player/video_player.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;


import '../../../../helper/sherdprefrence/shardprefKeyConst.dart';
import '../../../../helper/sherdprefrence/sharedprefrenc.dart';

class ChatMainController extends GetxController{

  int chatPage = 1;
  int userid = 0;
  late WebSocketChannel _channel;
  bool isTyped= false;
  final TextEditingController msgTEC = TextEditingController();
  onChanged(changed){
    if(msgTEC.text.isEmpty){
      isTyped= false;
      update();
    }else{
      isTyped= true;
      update();
    }
  }
  void _connectToChatSocketServer() {
   var myuserid = CacheHelper.getData(key: useridKey);
    var usertoken = CacheHelper.getData(key: access_tokenkey);
    _channel = WebSocketChannel.connect(Uri.parse('wss://naham.tadafuq.ae?user_id=${myuserid}&token=$usertoken'));
    print("close reason ${_channel.closeReason}"  );
    _channel.stream.listen((message) {
      final data = jsonDecode(message);
      print("data coming from socket " + message);
      messages.insert(0,ChatMessage.fromJson(data));
      update();

    });
  }


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    GetChatMessage();
    _connectToChatSocketServer();
    boolList=  List.generate(100, (index) => false);

    audioPlayer = AudioPlayer();

  }
  List<ChatMessage> messages = [];
  bool isLoading = true;

  @override
  void dispose() {
    // TODO: implement dispose
    _channel.sink.close();
    super.dispose();
  }

  GetChatMessage()async{
    print("isLoading ${isLoading}");
    String access_token =  CacheHelper.getData(key: access_tokenkey);

    userid = CacheHelper.getData(key: userprofielkey);

    var headers = {
      'Authorization': 'Bearer ${access_token}'
    };
    var dio = Dio();
    try {
      var response = await dio.request(
        '${apiurl}user/get-messages/${userid}?page=${chatPage}',
        options: Options(
          method: 'GET',
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {
        print(json.encode(response.data));
        ChatMessageModel chatMessageModel = ChatMessageModel();
        chatMessageModel = ChatMessageModel.fromJson(response.data);

        List data = response.data['data'];
        messages = data.map((json)=>ChatMessage.fromJson(json)).toList();
        isLoading = false;
        print("isLoading ${isLoading}");

        update();
      }
      else {
        print(response.statusMessage);
      }
    }catch(e){
      print(e);
    }
  }

  double latitude = 0.0;
  double longitude = 0.0;
  bool isSend =false;

  LatLng xposition = LatLng(0, 0);
  extractCoordinates() async{

try{
  await Geolocator.checkPermission();
    await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    latitude = position.latitude;
    longitude = position.longitude;
    print(latitude + longitude);
    xposition = LatLng(latitude, longitude);
    update();
    // showToast(text: latitude + " / " + longitude, state: ToastState.SUCCESS);
  }catch(e){
  print(e);
  Geolocator.getLastKnownPosition(forceAndroidLocationManager: true);
  }

  }

  SendLocatio(context,id)async{
    try {
      await Geolocator.checkPermission();
      await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      latitude = position.latitude;
      longitude = position.longitude;
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

        String responseString = await response.stream.bytesToString();
        Map<String, dynamic> responseMap = jsonDecode(responseString);
        Map msgSent= responseMap["data"];
        msgSent["to_user_id"]=responseMap["data"]["receiver_id"].toString();
        _channel.sink.add(jsonEncode(msgSent));
        print(jsonEncode(msgSent));
        var jsonvar = jsonDecode(jsonEncode(msgSent)) ;
        messages.insert(0,ChatMessage.fromJson(jsonvar));
        latitude =0.0;
        longitude=0.0;
        Navigator.of(context).pop();
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

  void sendMessage(String message, id) async {

    String access_token = CacheHelper.getData(key: access_tokenkey);
    print("access_token ++++++ $access_token ++++++++");
    try {
      var headers = {'Authorization': 'Bearer ${access_token}'};
      var data = {'receiver_id': '$id', 'message': '$message'} ;

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
        Map msgSent= response.data["data"];
        msgSent["to_user_id"]=response.data["data"]["receiver_id"].toString();
         _channel.sink.add(jsonEncode(msgSent));
         print(jsonEncode(msgSent));
         var jsonvar = jsonDecode(jsonEncode(msgSent)) ;
         messages.insert(0,ChatMessage.fromJson(jsonvar));
        update();
      } else {
        print(response.statusMessage);
      }
    } catch (e) {
      print(e);
    }
  }


  openFile(urlmap)async{
    try{
    final Uri url = Uri.parse('${urlmap}');
    if (await launchUrl(url)) {
      throw Exception('Could not launch ${url}');
    }}catch(e){
      print(e);
    }

  }
  bool isRecording = false;
  String audioPath='';
  late AudioPlayer audioPlayer ;
  final AudioRecorder recorder = AudioRecorder();

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
  late List<bool> boolList;

  stopRecording()async{
    final path = await recorder.stop();
    isRecording = false;
    update();
  }
  double currentPosition = 0 ;
  double totalDuration = 0 ;
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
  onChnagerecordr(value){
    currentPosition = value;
    update();
  }

  ClearRecorder(){
    audioPath = '';
    update();
  }

  bool RecordSended= false;
  SendRecord(context,id)async{
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

        Map msgSent= data["data"];
        msgSent["to_user_id"]=data["data"]["receiver_id"].toString();
        _channel.sink.add(jsonEncode(msgSent));
        print(jsonEncode(msgSent));
        var jsonvar = jsonDecode(jsonEncode(msgSent)) ;
        messages.insert(0,ChatMessage.fromJson(jsonvar));

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

  StopReecoreder(url,index)async{
    if(url != null){
      await audioPlayer.setUrl(url);
      audioPlayer.stop();
      boolList[index] = false;update();
    }
  }
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

        Map msgSent= data["data"];
        msgSent["to_user_id"]=data["data"]["receiver_id"].toString();
        _channel.sink.add(jsonEncode(msgSent));
        print(jsonEncode(msgSent));
        var jsonvar = jsonDecode(jsonEncode(msgSent)) ;
        messages.insert(0,ChatMessage.fromJson(jsonvar));
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


  // /*
  ////////////////////////////
  File ? myVideo;
  final picker = ImagePicker();
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
  PickVideoFromCamera()async{
    final video = await picker.pickVideo(source: ImageSource.camera, );
    myVideo= File(video!.path);
    videoPlayerController = VideoPlayerController.file(myVideo!)..initialize().then((value){
      update();
    });
    videoPlayerController!.play();
    Get.back();
  }
 ClearVideo()async{
    myVideo = null;
    update();
  }
  bool VideoSendded= false;
  SendVideo(context,id)async{
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
        Map msgSent= data["data"];
        msgSent["to_user_id"]=data["data"]["receiver_id"].toString();
        _channel.sink.add(jsonEncode(msgSent));
        print(jsonEncode(msgSent));
        var jsonvar = jsonDecode(jsonEncode(msgSent)) ;
        messages.insert(0,ChatMessage.fromJson(jsonvar));
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
  // */
////////////////////
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
        Map msgSent= data["data"];
        msgSent["to_user_id"]=data["data"]["receiver_id"].toString();
        _channel.sink.add(jsonEncode(msgSent));
        print(jsonEncode(msgSent));
        var jsonvar = jsonDecode(jsonEncode(msgSent)) ;
        messages.insert(0,ChatMessage.fromJson(jsonvar));
        update();

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