import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:naham/helper/SocketController.dart';
import 'package:naham/helper/sherdprefrence/shardprefKeyConst.dart';
import 'package:naham/helper/sherdprefrence/sharedprefrenc.dart';

class WebRTCGroupController extends GetxController {
  Map<int, webrtc.RTCPeerConnection> peerConnections = {};
  webrtc.MediaStream? localStream;
  Map<int, webrtc.MediaStream> remoteStreams = {};


  int userid = 0;

  late SocketController socketController;

  @override
  void onInit() {
    super.onInit();
    var myUserId = CacheHelper.getData(key: useridKey);
    var userToken = CacheHelper.getData(key: access_tokenkey);
    // Initialize the SocketController
    socketController = SocketController();
    //.initialize(userId: myUserId.toString(), token: userToken);

// Registering listeners
    socketController.addMessageListener(_handleSocketMessage);
    socketController.addDisconnectListener(_restartConnection);
    socketController.addErrorListener(_restartConnection);
    _initializeWebRTC();
    initializePeerConnectionsForGroup();
    isLoading = false;
    isPressing = false;
  }

  Future<void> initializePeerConnectionsForGroup() async {
    List<int> groupUserIds = [21, 22, 23, 24]; // Example user IDs in the group

    for (int userId in groupUserIds) {
      // Create a peer connection and add it to the peerConnections map
      webrtc.RTCPeerConnection peerConnection =
          await _createPeerConnection(userId);
      peerConnections[userId] = peerConnection;
      peerConnections[userId]?.onIceConnectionState =
          _handleIceConnectionState; // Add to the peerConnections map
    }

    update(); // Update the UI to reflect the changes
  }



  bool isLoading = false;
  bool isPressing = false;


  void startTalking() async {
    await _initializeWebRTC();
    await initializePeerConnectionsForGroup();
    isLoading = true;
    isPressing = false;

    update();

    // Enable local audio tracks for speaking
    localStream?.getAudioTracks().forEach((track) {
      track.enabled = true;
    });

    var myuserid = CacheHelper.getData(key: useridKey);
    // Create and send offers to all peers
    for (var entry in peerConnections.entries) {
      int userId = entry.key;
      webrtc.RTCPeerConnection peerConnection = entry.value;

      // Create an offer
      webrtc.RTCSessionDescription offer = await peerConnection.createOffer();
      await peerConnection.setLocalDescription(offer);

      // Send the offer to the signaling server with group information
      if(userId != myuserid) {
        print("sending offer to ${userId}");
        _sendToServer({
          'type': 'offer',
          'sdp': offer.sdp,
          'to_user_id': userId, // Send offer to specific peer
        });
      }
    }
  }

  void stopTalking() {
    isLoading = false;
    isPressing = false;

    peerConnections.forEach((_, connection) {
      connection.close();
    });
    localStream?.dispose();
    remoteStreams.forEach((_, stream) {
      stream.dispose();
    });

    update();  // Trigger UI update
  }

  Future<void> _initializeWebRTC() async {
    localStream = await _getUserMedia();
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

  Future<webrtc.RTCPeerConnection> _createPeerConnection(int userId) async {
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
    webrtc.RTCPeerConnection peerConnection =
        await webrtc.createPeerConnection(configuration);

    peerConnection.onIceCandidate = (webrtc.RTCIceCandidate candidate) {
      _sendToServer({
        'type': 'candidate',
        'candidate': candidate.toMap(),
        'to_group_id': 2,
      });
    };

    peerConnection.onAddStream = (webrtc.MediaStream stream) {
      remoteStreams[userId] = stream;
      _playReceivedAudio(stream);
      update();
    };

    if (localStream != null) {
      localStream?.getTracks().forEach((track) {
        peerConnection.addTrack(track, localStream!);
      });
    }
    peerConnections[userId] = peerConnection;
    return peerConnection;
  }



  Future<void> _restartConnection() async {
    await _initializeWebRTC();
    await initializePeerConnectionsForGroup();
  }

  void _handleSocketMessage(dynamic message) {
    final data = jsonDecode(
        message as String); // Cast 'message' to String before decoding
    print("Data from socket: $message");

    print(data['type']);

    if(data["screen"] == "group"){
      print("is group trueeeeeeeeeeee");
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
    }

  }

  Future<void> _handleCandidate(Map<String, dynamic> data) async {
    int senderId = data['sender_id'];
    final candidate = webrtc.RTCIceCandidate(
      data['candidate']['candidate'],
      data['candidate']['sdpMid'],
      data['candidate']['sdpMLineIndex'],
    );

    if (peerConnections.containsKey(senderId)) {
      // Add the ICE candidate to the peer connection
      await peerConnections[senderId]?.addCandidate(candidate);
      print('ICE Candidate added for peer: $senderId');
    } else {
      print('PeerConnection not found for user: $senderId');
    }
  }

  Future<void> _handleOffer(Map<String, dynamic> data) async {

    int senderId = data['sender_id'];
    print("handle offffffffffffffer sender id ${senderId}");

    // Ensure the peer connection exists or create one
    webrtc.RTCPeerConnection peerConnection =
        peerConnections[senderId]! /*?? await _createPeerConnection(senderId)*/;

        print("peer connection is ${peerConnection == null}");

    // Set the remote description (offer)
    final description = webrtc.RTCSessionDescription(data['sdp'], 'offer');
    await peerConnection.setRemoteDescription(description);

    // Create an answer
    final answer = await peerConnection.createAnswer();
    await peerConnection.setLocalDescription(answer);

    print("sending answer to ${senderId}");
    // Send the answer back to the peer who sent the offer
    _sendToServer({
      'type': 'answer',
      'sdp': answer.sdp,
      'to_user_id': senderId,// Respond to the peer who sent the offer
    });


    // if (peerConnection.signalingState ==
    //         webrtc.RTCSignalingState.RTCSignalingStateStable ||
    //     peerConnection.signalingState ==
    //         webrtc.RTCSignalingState.RTCSignalingStateHaveRemoteOffer) {
    //   // Set the remote description (offer)
    //   final description = webrtc.RTCSessionDescription(data['sdp'], 'offer');
    //   await peerConnection.setRemoteDescription(description);
    //
    //   // Create an answer
    //   final answer = await peerConnection.createAnswer();
    //   await peerConnection.setLocalDescription(answer);
    //
    //   print("answeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeer");
    //   // Send the answer back to the peer who sent the offer
    //   _sendToServer({
    //     'type': 'answer',
    //     'sdp': answer.sdp,
    //     'to_user_id': senderId,// Respond to the peer who sent the offer
    //   });
    // }
  }

  Future<void> _handleAnswer(Map<String, dynamic> data) async {
    int senderId = data['sender_id'];
    if (peerConnections.containsKey(senderId)) {
      webrtc.RTCPeerConnection peerConnection = peerConnections[senderId]!;

      // Check if the signaling state is appropriate for setting the answer
      if (peerConnection.signalingState ==
          webrtc.RTCSignalingState.RTCSignalingStateHaveLocalOffer) {
        final description = webrtc.RTCSessionDescription(data['sdp'], 'answer');
        await peerConnection.setRemoteDescription(description);
        print("answeeeeeeeeeeeeer");

        isPressing = true;
        isLoading = false;
        update();
      } else {
        print("PeerConnection is not in the correct state to set an answer.");
      }
    }
  }


  void _handleStop() {
    if (isPressing) {
      // Only disable the mic if this device was the one talking
      localStream?.getAudioTracks().first.enabled = false;
      isPressing = false;
      update();
    }
  }

  void _sendToServer(Map<String, dynamic> message) {
    var myuserid = CacheHelper.getData(key: useridKey);
    message["sender_id"] = myuserid;
    message["screen"] = "group";
    print("sending from $myuserid");
    print("sendiiiiiiiiiiiiiing");
    print("messsssssssssssssssage ${message}");
    socketController.sendToServer(message);

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
    if (state ==
            webrtc.RTCIceConnectionState.RTCIceConnectionStateDisconnected ||
        state == webrtc.RTCIceConnectionState.RTCIceConnectionStateFailed) {
      _showToast("Connection failed or disconnected ", Colors.red);
      //Future.delayed(Duration(seconds: 5), _restartConnection);
    }
  }

  void _showConnectionToast(webrtc.RTCIceConnectionState state) {
    if (state == webrtc.RTCIceConnectionState.RTCIceConnectionStateConnected) {
      _showToast("Connection established!", Colors.green);


      update();
    } else if (state ==
        webrtc.RTCIceConnectionState.RTCIceConnectionStateCompleted) {
      _showToast("Connection completed!", Colors.blue);


      update();
    } else if (state ==
        webrtc.RTCIceConnectionState.RTCIceConnectionStateClosed) {
      _showToast("Connection closed!", Colors.red);
      update();
    }
  }

  void _showToast(String message, Color bgColor) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: bgColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  void onClose() {
    peerConnections.forEach((_, connection) {
      connection.close();
    });
    localStream?.dispose();
    remoteStreams.forEach((_, stream) {
      stream.dispose();
    });
    super.onClose();
  }
}
