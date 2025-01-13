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
import 'package:naham/helper/sherdprefrence/shardprefKeyConst.dart';
import 'package:naham/helper/sherdprefrence/sharedprefrenc.dart';

import '../../../../helper/WebService/webServiceConstant.dart';
import '../../model/userprofielmodel.dart';
import '../../view/screen/CallScreen/videoCall/vidocallScreen.dart';



class ChatCallController extends GetxController {


  BuildContext context ;
  ChatCallController(this.context);
  late webrtc.RTCPeerConnection? peerConnection;
  webrtc.MediaStream? localStream;
  webrtc.MediaStream? remoteStream;


  int userid = 0;
  late SocketController socketController;

  @override
  void onInit() async {
    super.onInit();
    await _initializeWebRTC();
    var myUserId = CacheHelper.getData(key: useridKey);
    var userToken = CacheHelper.getData(key: access_tokenkey);
    // Initialize the SocketController
    socketController = SocketController();
    //socketController.initialize(userId: myUserId.toString(), token: userToken);

// Registering listeners
    socketController.addMessageListener(_handleSocketMessage);
    socketController.addDisconnectListener(_restartConnection);
    socketController.addErrorListener(_restartConnection);

  }

  Future<void> _initializeWebRTC() async {
    localStream = await _getUserMedia();
    peerConnection = await _createPeerConnection();

    peerConnection?.onIceCandidate = _handleIceCandidate;
    peerConnection?.onAddStream =
        _handleRemoteStream;
    peerConnection?.onIceConnectionState = _handleIceConnectionState;

  }

  void _handleIceCandidate(webrtc.RTCIceCandidate candidate) {
    _sendToServer({'type': 'candidate', 'candidate': candidate.toMap()});
  }

  Future<webrtc.MediaStream> _getUserMedia() async {
    final mediaConstraints = {
      'audio': {
        'autoGainControl': true,
        'channelCount': 2,
        'echoCancellation': true,
        'latency': 200,
        'noiseSuppression': true,
        'sampleRate': 48000,
        'sampleSize': 16,
        'volume': 1.0,
      },
      'video': false,
    };
    try {
      return await webrtc.navigator.mediaDevices.getUserMedia(mediaConstraints);
    } catch (e) {
      print("Error obtaining user media: $e");
      throw e;
    }
  }

  Future<webrtc.RTCPeerConnection> _createPeerConnection() async {
    final configuration = {
      "iceServers": [
        {'urls': 'stun:stun1.l.google.com:19302'},
        {'urls': 'stun:stun2.l.google.com:19302'},
        {
          "urls": "stun:stun.relay.metered.ca:80",
        },
        {
          "urls": "turn:global.relay.metered.ca:80",
          "username": "fe2aaa0c26ae5dcc6385d244",
          "credential": "/Bk3oEbhGjdv7jkO",
        },
        {
          "urls": "turn:global.relay.metered.ca:80?transport=tcp",
          "username": "fe2aaa0c26ae5dcc6385d244",
          "credential": "/Bk3oEbhGjdv7jkO",
        },
        {
          "urls": "turn:global.relay.metered.ca:443",
          "username": "fe2aaa0c26ae5dcc6385d244",
          "credential": "/Bk3oEbhGjdv7jkO",
        },
        {
          "urls": "turns:global.relay.metered.ca:443?transport=tcp",
          "username": "fe2aaa0c26ae5dcc6385d244",
          "credential": "/Bk3oEbhGjdv7jkO",
        },
        {
          "urls": "stun:stun.relay.metered.ca:80",
        },
        {
          "urls": "turn:global.relay.metered.ca:80",
          "username": "cdf47e9ff29f88678538edce",
          "credential": "OogVGvp+Wy/kD0Nu",
        },
        {
          "urls": "turn:global.relay.metered.ca:80?transport=tcp",
          "username": "cdf47e9ff29f88678538edce",
          "credential": "OogVGvp+Wy/kD0Nu",
        },
        {
          "urls": "turn:global.relay.metered.ca:443",
          "username": "cdf47e9ff29f88678538edce",
          "credential": "OogVGvp+Wy/kD0Nu",
        },
        {
          "urls": "turns:global.relay.metered.ca:443?transport=tcp",
          "username": "cdf47e9ff29f88678538edce",
          "credential": "OogVGvp+Wy/kD0Nu",
        },
      ],
    };
    return await webrtc.createPeerConnection(configuration);
  }


  createOffer() async {
    if(peerConnection == null || peerConnection?.connectionState == RTCPeerConnectionState.RTCPeerConnectionStateClosed) {
      await _initializeWebRTC();
    }
    webrtc.RTCSessionDescription? offer = await peerConnection?.createOffer();
    await peerConnection?.setLocalDescription(offer!);
    update();
    if(offer?.sdp  != null) {
      _sendToServer({'type': 'offer', 'sdp': offer?.sdp});
    }

  }


  funStartTaking() async {

    if (localStream == null || localStream!.getTracks().isEmpty) {
      print("Local stream is null");
      return;
    }

    final audioTracks = localStream!.getAudioTracks();
    if (audioTracks.isEmpty) {
      print("No audio tracks available.");
      return;
    }

    audioTracks.first.enabled = true;

    localStream?.getTracks().forEach((track) {
      peerConnection?.addTrack(track, localStream!);
    });




  }

  funStopTaking() {
    peerConnection?.close();
    localStream?.dispose();
    //remoteStream?.dispose();
    peerConnection = null;

    // if (localStream != null) {
    //   var audioTracks =
    //   localStream!.getAudioTracks();
    //   if (audioTracks.isNotEmpty) {
    //     audioTracks.first.enabled = false; // Disable mic
    //
    //   }
    // }
    _handleStop();
    _handleTerminate();

    update();
  }

  StartCall(data){
    if (localStream == null || localStream!.getTracks().isEmpty) {
      print("Local stream is null");
      return;
    }

    final audioTracks = localStream!.getAudioTracks();
    if (audioTracks.isEmpty) {
      print("No audio tracks available.");
      return;
    }

    audioTracks.first.enabled = true;

    localStream?.getTracks().forEach((track) {
      peerConnection?.addTrack(track, localStream!);
    });
  }




  void _handleWebSocketError(error) {
    print("WebSocket error: $error");
    _sendToServer({'type': 'terminate'});
    Future.delayed(Duration(seconds: 1), _restartConnection);
  }

  Future<void> _restartConnection() async {
    await peerConnection?.close();
    await _initializeWebRTC();
  }

  void _handleSocketMessage(dynamic message) {
    final data = jsonDecode(message as String); // Cast 'message' to String before decoding
    print("Data from socket: $message");
    CacheHelper.saveData(key: userprofielkey, value: data["sender_id"]);

    print(data['type']);
    print("UUUUUUUUUUUUUUUU${data["screen"]}");

    if(data["screen"] == "chat"){
      switch (data['type']) {
        case 'calling':
          _handleCall(data);
          break;
        case 'video_calling':
          _handleVideoCalling(data);
          break;
        case 'endcalling':
          funStopTaking();
          Get.back();
          break;
        case 'DeclineCall':
          funStopTaking();
          Get.back();
          break;

        case 'offer':
          _handleOffer(data);
          break;
        case 'answer':
          _handleAnswer(data);
          break;
        case 'candidate':
          _handleCandidate(data);
          break;
        case 'stop':
          _handleStop();
          break;
        case 'terminate':
          _handleTerminate();
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
                          Get.to(() => CallScreen(),arguments: {
                            "userProfileKey":userProfileModel.data!.id
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



  void _handleOffer(Map<String, dynamic> data) async {

    final description = webrtc.RTCSessionDescription(data['sdp'], 'offer');
    await peerConnection?.setRemoteDescription(description);

    final answer = await peerConnection?.createAnswer();
    await peerConnection?.setLocalDescription(answer!);

    _sendToServer({'type': 'answer', 'sdp': answer?.sdp});
  }


  void _handleAnswer(Map<String, dynamic> data) async {
    if(data['sdp'] != null) {
      final description = webrtc.RTCSessionDescription(data['sdp'], 'answer');
      await peerConnection?.setRemoteDescription(description);
    }
  }

  void _handleCandidate(Map<String, dynamic> data) async {
    final candidate = webrtc.RTCIceCandidate(
      data['candidate']['candidate'],
      data['candidate']['sdpMid'],
      data['candidate']['sdpMLineIndex'],
    );

    if (peerConnection != null) {
      await peerConnection?.addCandidate(candidate);
    } else {
      print("Peer connection not ready for candidate.");
    }
  }

  void _handleStop() {
    localStream?.getAudioTracks().first.enabled = false;
  }


  void _handleTerminate() async {
    print("Terminate message received, closing connection...");
    await peerConnection?.close();
    localStream?.dispose();
    remoteStream?.dispose();
    peerConnection = null; // Reset the peer connection
    localStream = null;
    remoteStream = null;

    Fluttertoast.showToast(
      msg: "Connection terminated by remote peer.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    update();
  }


  void _sendToServer(Map<String, dynamic> message) {
    userid = CacheHelper.getData(key: userprofielkey);
    var myuserid = CacheHelper.getData(key: useridKey);
    message["to_user_id"] = userid;
    message["sender_id"]=myuserid;
    message["screen"] = "chat";
    print("sending to $userid");
    print("sending from $myuserid");
    socketController.sendToServer(message);
  }

  void _handleRemoteStream(webrtc.MediaStream stream) {
    remoteStream = stream;
    update();
    _playReceivedAudio(stream);
  }

  void _playReceivedAudio(webrtc.MediaStream stream) {
    for (var track in stream.getAudioTracks()) {
      track.enabled = true;
    }
    print("Playing received audio stream.");
  }

  void _handleIceConnectionState(webrtc.RTCIceConnectionState state) {
    print("ICE Connection State: ${state.name}");
    _showConnectionToast(state);
    if(state ==
        webrtc.RTCIceConnectionState.RTCIceConnectionStateCompleted ||
        state == webrtc.RTCIceConnectionState.RTCIceConnectionStateConnected) {
      funStartTaking();
    }
    if (state ==
        webrtc.RTCIceConnectionState.RTCIceConnectionStateDisconnected ||
        state == webrtc.RTCIceConnectionState.RTCIceConnectionStateFailed) {
      Future.delayed(Duration(seconds: 5), _restartConnection);
    }
  }

  void _showConnectionToast(webrtc.RTCIceConnectionState state) {
    if (state == webrtc.RTCIceConnectionState.RTCIceConnectionStateConnected) {
      showToast(text: "Connection established!", state: ToastState.SUCCESS);
      //isLoading = false;
      //isPressing = true;
      update();
    } else if (state ==
        webrtc.RTCIceConnectionState.RTCIceConnectionStateCompleted) {
      showToast(text: "Connection completed!", state: ToastState.COMPLEATE);
      //isLoading = false;
      //isPressing = true;
      update();
    } else if (state ==
        webrtc.RTCIceConnectionState.RTCIceConnectionStateClosed) {
      var audioTrack = localStream?.getAudioTracks()?.first;
      // isPressing = audioTrack != null ? audioTrack.enabled : false;
      //isLoading = false;
      update();
    }
  }

}
