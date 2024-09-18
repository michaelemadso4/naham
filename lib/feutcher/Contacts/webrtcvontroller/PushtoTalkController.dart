import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:naham/helper/sherdprefrence/shardprefKeyConst.dart';
import 'package:naham/helper/sherdprefrence/sharedprefrenc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
class PushToTalk extends GetxController{
  BuildContext context ;
  PushToTalk({required this.context});

  late webrtc.RTCPeerConnection _peerConnection;
  webrtc.MediaStream ? _localStream;
  bool isTalking = false;
  late WebSocketChannel _channel;
  webrtc.MediaStream? _remoteStream;
  int userid = 0;

  @override
  void onInit()async {
    // TODO: implement onInit
    super.onInit();
    await _initializeWebRTC();
    _connectToSignalingServer();

  }
  @override
  void dispose() {
    // TODO: implement dispose
    _localStream?.dispose();
    _remoteStream?.dispose();
    _peerConnection.close();
    _channel.sink.close();
    super.dispose();
  }


  Future<void> _initializeWebRTC() async {
    _localStream = await _getUserMedia();
    _peerConnection = await _createPeerConnection();

    _peerConnection.onIceCandidate = (webrtc.RTCIceCandidate candidate) {
      _sendToServer({
        'type': 'candidate',
        'candidate': candidate.toMap(),
      });
    };

    // Update this to handle the remote stream
    _peerConnection.onAddStream = (webrtc.MediaStream stream) {

        _remoteStream = stream; // Store the received remote stream
        update();
      _playReceivedAudio(stream); // Play the received audio
    };
    // Monitor the ICE connection state
    _peerConnection.onIceConnectionState = (webrtc.RTCIceConnectionState state) {
      if (state == webrtc.RTCIceConnectionState.RTCIceConnectionStateDisconnected) {
        _showPeerConnectionStoppedWarning(Erorr: "RTCIceConnectionStateDisconnected");
      }else if(state == webrtc.RTCIceConnectionState.RTCIceConnectionStateFailed){
        _showPeerConnectionStoppedWarning(Erorr: "RTCIceConnectionStateFailed");
      }else if( state == webrtc.RTCIceConnectionState.RTCIceConnectionStateClosed){
        _showPeerConnectionStoppedWarning(Erorr: "RTCIceConnectionStateClosed");

      }
    };


  }

  void _showPeerConnectionStoppedWarning({Erorr}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.yellow),
              SizedBox(width: 8),
              Text("Peer Connection Stopped", style: TextStyle(color: Colors.yellow,
              fontSize: 12
              )),
            ],
          ),
          content: Text("The WebRTC connection has been ${Erorr}."),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _playReceivedAudio(webrtc.MediaStream stream) {
    // Here you can play the received audio stream
    // Since flutter_webrtc does not provide a direct way to play audio,
    // you can use the `Audio` class to handle audio playback.
    // Example:
    for (var track in stream.getAudioTracks()) {
      track.enabled = true; // Ensure the audio track is enabled
    }
    print("Received audio stream is being played.");
  }

  void _sendToServer(Map<String, dynamic> message) {
    userid = CacheHelper.getData(key: userprofielkey);

    message["to_user_id"] = "${userid}";
    print("sending ${jsonEncode(message)}");
    _channel.sink.add(jsonEncode(message));
  }


  Future<webrtc.RTCPeerConnection> _createPeerConnection() async {
    final configuration = {
      'iceServers': [
        {'urls': 'stun:stun1.l.google.com:19302'},
        {'urls': 'stun:stun2.l.google.com:19302'},
        {
          'urls': 'turns:turn.fav.on24.com:443',
          'username': 'on24user',
          'credential': 'nev2Eni@'
        }
      ]
    };
    return await webrtc.createPeerConnection(configuration);
  }
 /* Future<webrtc.RTCPeerConnection> _createPeerConnection() async {
    final configuration = {
      'iceServers': [
        {'urls': 'stun:stun1.l.google.com:19302'},
        {'urls': 'stun:stun2.l.google.com:19302'},
        {
          'urls': 'turns:34.38.50.190:3478',
          'username': 'naham',
          'credential': 'TyALteSZ8u5XcC92HdnWqf'
        }
      ]
    };
    return await webrtc.createPeerConnection(configuration);
  }*/

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
        'volume': 1.0
      },
      'video': false,
    };

    try {
      return await webrtc.navigator.mediaDevices.getUserMedia(mediaConstraints);
    } catch (e) {
      print("Error obtaining user media: $e");
      throw e; // Re-throw to handle the error upstream
    }
  }
  void _handleOffer(Map<String, dynamic> data) async {
    final description = webrtc.RTCSessionDescription(data['sdp'], 'offer');
    await _peerConnection.setRemoteDescription(description);

    final answer = await _peerConnection.createAnswer();
    await _peerConnection.setLocalDescription(answer);

    _sendToServer({
      'type': 'answer',
      'sdp': answer.sdp,
    });
  }

  void _handleAnswer(Map<String, dynamic> data) async {
    final description =webrtc.RTCSessionDescription(data['sdp'], 'answer');
    await _peerConnection.setRemoteDescription(description);
  }

  void _handleCandidate(Map<String, dynamic> data) async {
    final candidate = webrtc.RTCIceCandidate(
      data['candidate']['candidate'],
      data['candidate']['sdpMid'],
      data['candidate']['sdpMLineIndex'],
    );
    await _peerConnection.addCandidate(candidate);
  }

  void _handleStop() {

      isTalking = false;
      update();


    _localStream!.getAudioTracks().first.enabled = false;
  }

  void _connectToSignalingServer() {
    var myuserid = CacheHelper.getData(key: useridKey);
    var usertoken = CacheHelper.getData(key: access_tokenkey);
    _channel = WebSocketChannel.connect(Uri.parse('wss://naham.tadafuq.ae?user_id=${myuserid}&token=$usertoken'));
    print("close reason ${_channel.closeReason}"  );
    _channel.stream.listen((message) {
      final data = jsonDecode(message);
      print("data coming from socket " + message);
      // /*
      switch (data['type']) {
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
      }


       // */
    },
    onDone: (){
     showDialog(context: context, builder: (BuildContext context){
       return AlertDialog(
         title:Row(
           children: [
             Icon(Icons.warning,color: Colors.yellow,),
             Text("Alert WebSocket",style: TextStyle(color: Colors.yellow),),
           ],
         ) ,
         content: Text("WebSocket connection stopped!"),
         actions: [
           TextButton(onPressed: (){Get.back();}, child: Text("Cancel"))
         ],
       );
     });
    },
      onError: (error){
        showDialog(context: context, builder: (BuildContext context){
          return AlertDialog(
            title:Row(
              children: [
                Icon(Icons.error,color: Colors.red,),
                Text("Error WebSocket",style: TextStyle(color: Colors.red),),
              ],
            ) ,
            content: Text("WebSocket connection Erorr!, ${error}"),
            actions: [
              TextButton(onPressed: (){Get.back();}, child: Text("Cancel"))
            ],
          );
        });
      }
    );
  }
  void _startTalking() async {
    if (_localStream == null||_localStream!.getTracks().isEmpty) {
      print("Local stream is null");
      return;
    }

    // Get audio tracks
    final audioTracks = _localStream!.getAudioTracks();
    if (audioTracks.isEmpty) {
      print("No audio tracks available in the local stream");
      return;
    }

    // Enable the first audio track
    audioTracks.first.enabled = true;

    // Add the stream to the peer connection
    try {
      print("_localStream.isNullOrBlank${_localStream.isNullOrBlank}");
      if (_localStream != null && _localStream!.getTracks().isNotEmpty) {
        _localStream?.getTracks().forEach((track) {
          _peerConnection.addTrack(track, _localStream!);
        });
      } else {
        print("Local stream or tracks are not initialized properly.");
      }
    } catch (e) {
      print("Failed to add stream to peer connection: $e");
      return;
    }

    webrtc.RTCSessionDescription offer = await _peerConnection.createOffer();
    await _peerConnection.setLocalDescription(offer);

    _sendToServer({
      'type': 'offer',
      'sdp': offer.sdp,
    });


      isTalking = true; // Move setState here
    update();
  }

  void _stopTalking() async {

      isTalking = false; // This already updates the UI
    _localStream!.getAudioTracks().first.enabled = false;

    _sendToServer({
      'type': 'stop',
    });
      update();
  }


  StartTalkini(){
    _startTalking();
  }
  StopTalkini(){
    _stopTalking();
  }
}