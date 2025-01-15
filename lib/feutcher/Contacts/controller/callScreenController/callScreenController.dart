import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;
import 'package:naham/helper/sherdprefrence/shardprefKeyConst.dart';
import 'package:naham/helper/sherdprefrence/sharedprefrenc.dart';

import '../../../../helper/SocketController.dart';
import '../../../../helper/ToastMessag/toastmessag.dart';

class CallScreenController extends GetxController {
  webrtc.RTCPeerConnection? peerConnection;
  webrtc.MediaStream? localStream;
  webrtc.MediaStream? remoteStream;
  int userid = 0;
  late SocketController socketController;

  @override
  void onInit() async {
    super.onInit();
    await _initializeWebRTC();
    print("onInit");

    // Initialize the SocketController
    socketController = SocketController();


// Registering listeners
    socketController.addMessageListener(_handleSocketMessage);
    socketController.addDisconnectListener(_restartConnection);
    socketController.addErrorListener(_restartConnection);
  }

  Future<void> _initializeWebRTC() async {
    try {
      if (peerConnection != null) return;
      print("_initializeWebRTC");
      localStream = await _getUserMedia();
      peerConnection = await _createPeerConnection();

      peerConnection?.onIceCandidate = _handleIceCandidate;
      peerConnection?.onAddStream = _handleRemoteStream;
      peerConnection?.onIceConnectionState = _handleIceConnectionState;
      print("_initializeWebRTC2222222222222222222222");
    } catch (e) {
      print("error initilize $e");
    }
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

  createOffer() async {
    if (peerConnection == null || peerConnection?.connectionState ==
        RTCPeerConnectionState.RTCPeerConnectionStateClosed) {
      await _initializeWebRTC();
    }

    try {
      webrtc.RTCSessionDescription? offer = await peerConnection?.createOffer();
      await peerConnection?.setLocalDescription(offer!);
      update();
      if (offer?.sdp != null) {
        _sendToServer({'type': 'offer', 'sdp': offer?.sdp});
      }
    } catch (e) {
      print("Error creating offer: $e");
    }
  }

  funStartTaking() async {
    print("funStartTalkinggggg");
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
    print("audioTracks.first.enabled");

    localStream?.getTracks().forEach((track) {
      peerConnection?.addTrack(track, localStream!);
    });
  }

  funStopTaking() {
    peerConnection?.close();
    localStream?.dispose();
    //remoteStream?.dispose();
    peerConnection = null;

    _handleStop();
    _handleTerminate();

    update();
  }

  Future<void> _restartConnection() async {
    await peerConnection?.close();
    await _initializeWebRTC();
  }

  void _handleSocketMessage(dynamic message) {
    final data = jsonDecode(
        message as String); // Cast 'message' to String before decoding
    print("CallScreenController Data from socket: $message");
    CacheHelper.saveData(key: userprofielkey, value: data["sender_id"]);

    print(data['type']);
    print("UUUUUUUUUUUUUUUU${data["screen"]}");

    if (data["screen"] == "call_screen_controller") {
      switch (data['type']) {
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

  void _handleOffer(Map<String, dynamic> data) async {
    final description = webrtc.RTCSessionDescription(data['sdp'], 'offer');
    await peerConnection?.setRemoteDescription(description);

    final answer = await peerConnection?.createAnswer();
    await peerConnection?.setLocalDescription(answer!);

    _sendToServer({'type': 'answer', 'sdp': answer?.sdp});
    /*if (answer?.sdp != null) {
      _sendToServer({'type': 'answer', 'sdp': answer?.sdp});
    }*/
  }

  void _handleAnswer(Map<String, dynamic> data) async {
    if (data['sdp'] != null) {
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
    localStream
        ?.getAudioTracks()
        .first
        .enabled = false;
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

  void _sendToServer(Map<String, dynamic> message) {
    userid = CacheHelper.getData(key: userprofielkey);
    var myuserid = CacheHelper.getData(key: useridKey);
    message["to_user_id"] = userid;
    message["sender_id"] = myuserid;
    message["screen"] = "call_screen_controller";
    print("sending to $userid");
    print("sending from $myuserid");
    String jsonMessage = jsonEncode(message);
    print("CallScreenController Sending message: $jsonMessage");
    socketController.sendToServer(message);
  }

  void _handleRemoteStream(webrtc.MediaStream stream) {
    remoteStream = stream;
    print("Playing received audio stream.");
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
    if (state == webrtc.RTCIceConnectionState.RTCIceConnectionStateCompleted ||
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
    } else if (state ==
        webrtc.RTCIceConnectionState.RTCIceConnectionStateCompleted) {
      showToast(text: "Connection completed!", state: ToastState.COMPLEATE);
    }
  }

  void EndCall() {
    _sendToServer({'type': 'endcalling'});
  }








}
