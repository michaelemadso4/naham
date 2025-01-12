import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:naham/helper/sherdprefrence/shardprefKeyConst.dart';
import 'package:naham/helper/sherdprefrence/sharedprefrenc.dart';

import '../../../../helper/SocketController.dart';

class VideoWebRTCController extends GetxController {
  webrtc.RTCPeerConnection? _peerConnection;
  webrtc.MediaStream? _localStream;
  webrtc.MediaStream? _remoteStream;
  webrtc.RTCVideoRenderer localRenderer = webrtc.RTCVideoRenderer();
  webrtc.RTCVideoRenderer remoteRenderer = webrtc.RTCVideoRenderer();

  // Observables for loading state
  RxBool isLocalRendererReady = false.obs;
  RxBool isRemoteRendererReady = false.obs;

  RxBool isLocalRendererVisible = true.obs;

  SocketController socketController = SocketController();

  @override
  void onInit() async {
    super.onInit();
    print("init video");

    socketController.addMessageListener(_handleSocketMessage);
  }

  Future<void> initRenderers() async {
    try {
      await localRenderer.initialize();
      await remoteRenderer.initialize();
      print("Renderers initialized successfully");
    } catch (e) {
      print("Error initializing renderers: $e");
      _showToast("Error initializing video renderer. Retrying...", Colors.red);
      await reinitializeWebRTC(useSoftwareCodec: true);
    }
  }

  void toggleRenderer() {
    isLocalRendererVisible.value = !isLocalRendererVisible.value;
    update(); // Update the UI after toggling
  }

  // Handle signaling messages (offer, answer, ICE candidates)
  Future<void> _handleSocketMessage(dynamic message) async {
    final data = jsonDecode(
        message as String); // Cast 'message' to String before decoding
    print("Data from socket: $message");
    if (data["sender_id"] is int)
      CacheHelper.saveData(key: userprofielkey, value: data["sender_id"]);

    print(data['type']);
    print("backkkk");

    switch (data['type']) {
      case 'end_video_calling':
        closeConnection();
        Get.back();
        break;
      case 'offer':
        await _peerConnection
            ?.setRemoteDescription(webrtc.RTCSessionDescription(
          data['sdp'],
          data['type'],
        ));
        _createAnswer();
        break;
      case 'answer':
        await _peerConnection
            ?.setRemoteDescription(webrtc.RTCSessionDescription(
          data['sdp'],
          data['type'],
        ));

        break;
      case 'candidate':
        var candidate = webrtc.RTCIceCandidate(
          data['candidate'],
          data['sdpMid'],
          data['sdpMLineIndex'],
        );
        await _peerConnection?.addCandidate(candidate);
        break;
      case 'terminate':
        _handleTerminate();
        break;
    }
  }

  void _handleTerminate() async {
    print("Terminate message received, closing connection...");
    await _peerConnection?.close();
    _localStream?.dispose();
    _remoteStream?.dispose();
    await localRenderer.dispose();
    await remoteRenderer.dispose();

    Fluttertoast.showToast(
      msg: "Connection terminated by remote peer.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    // isTalking = false;
    update();
  }

  // Create the peer connection and local stream
  Future<void> _createPeerConnection() async {
    try {
      Map<String, dynamic> configuration = {
        "iceServers": [
          {
            "urls": "stun:stun.relay.metered.ca:80",
          },
          {
            "urls": "turn:global.relay.metered.ca:80",
            "username": "ea32a9296f465cd97c448dd1",
            "credential": "uCjHC3pOflkzlkoF",
          },
          {
            "urls": "turn:global.relay.metered.ca:80?transport=tcp",
            "username": "ea32a9296f465cd97c448dd1",
            "credential": "uCjHC3pOflkzlkoF",
          },
          {
            "urls": "turn:global.relay.metered.ca:443",
            "username": "ea32a9296f465cd97c448dd1",
            "credential": "uCjHC3pOflkzlkoF",
          },
          {
            "urls": "turns:global.relay.metered.ca:443?transport=tcp",
            "username": "ea32a9296f465cd97c448dd1",
            "credential": "uCjHC3pOflkzlkoF",
          },
        ],
        "optional": [
          {"disableHardwareCodec": true},
        ]
      };


      _peerConnection = await webrtc.createPeerConnection(configuration);

      _peerConnection?.onIceCandidate = (webrtc.RTCIceCandidate candidate) {
        var message = {
          'type': 'candidate',
          'candidate': candidate.candidate,
          'sdpMid': candidate.sdpMid,
          'sdpMLineIndex': candidate.sdpMLineIndex,
        };
        _sendToServer(message);
      };

      _peerConnection?.onTrack = (webrtc.RTCTrackEvent event) {
        print("Track received: ${event.track.kind}");
        if (event.streams.isNotEmpty) {
          _remoteStream = event.streams[0];
          if (_remoteStream != null) {
            remoteRenderer.srcObject = _remoteStream;
          }


          print("Remote stream set");
        }
      };

      /*_peerConnection?.onConnectionState = (webrtc.RTCPeerConnectionState state) {
      print("Connection state: $state");
      if (state == webrtc.RTCPeerConnectionState.RTCPeerConnectionStateClosed||
          state == webrtc.RTCPeerConnectionState.RTCPeerConnectionStateFailed) {
        print("Connection lost. Attempting to reconnect...");
        closeConnection();
        reinitializeWebRTC(); // Reinitialize and reconnect
      }
    };*/

      final mediaConstraints = {
        'audio': true,
        'video': true,
      };

      _localStream =
          await webrtc.navigator.mediaDevices.getUserMedia(mediaConstraints);
      if (_localStream == null) print("local stream nulllll");
      if (_localStream != null) {
        localRenderer.srcObject = _localStream;
      }

      _localStream?.getTracks().forEach((track) {
        _peerConnection?.addTrack(track, _localStream!);
      });
    } catch (e) {
      print("Error creating peer connection: $e");
      if (e.toString().contains("OMX.qcom.video.encoder")) {
        _showToast(
            "Error initializing video encoder. Falling back...", Colors.red);
        await reinitializeWebRTC(useSoftwareCodec: true);
      }
    }
  }

  Future<webrtc.RTCSessionDescription> setPreferredCodec(
      webrtc.RTCSessionDescription description, String preferredCodec) async {
    var sdp = description.sdp!;

    // Split SDP into lines for easier manipulation
    var lines = sdp.split('\r\n');

    // Locate the m=video line
    int? videoIndex;
    for (int i = 0; i < lines.length; i++) {
      if (lines[i].startsWith('m=video')) {
        videoIndex = i;
        break;
      }
    }

    if (videoIndex == null) {
      throw Exception('No video section found in SDP.');
    }

    // Get the payload types (PT) for the preferred codec
    List<String> codecPayloads = [];
    for (var line in lines) {
      if (line.startsWith('a=rtpmap') && line.contains(preferredCodec)) {
        var payloadType = line.split(':')[1].split(' ')[0];
        codecPayloads.add(payloadType);
      }
    }

    if (codecPayloads.isEmpty) {
      throw Exception('Preferred codec ($preferredCodec) not found in SDP.');
    }

    // Rearrange m=video line to prioritize preferred codec payload types
    var mLineParts = lines[videoIndex].split(' ');
    var header = mLineParts.sublist(0, 3); // m=video, port, protocol
    var payloadTypes = mLineParts.sublist(3);

    var prioritizedPayloads = codecPayloads +
        payloadTypes.where((pt) => !codecPayloads.contains(pt)).toList();

    lines[videoIndex] = '${header.join(' ')} ${prioritizedPayloads.join(' ')}';

    // Join the SDP back together
    var modifiedSdp = lines.join('\r\n');

    return webrtc.RTCSessionDescription(modifiedSdp, description.type);
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

  void sendCall() {
    _sendToServer({'type': 'calling'});
  }

  // Create an offer to start the call
  void createOffer() async {
    await initRenderers();
    await _createPeerConnection();

    var description = await _peerConnection?.createOffer();
    if(description != null) {
      var modifiedDescription = await setPreferredCodec(description, "VP9");
      await _peerConnection?.setLocalDescription(modifiedDescription);
      print("createOffer type:${description.type}");
      print("sender id ${CacheHelper.getData(key: userprofielkey)}");
      print(
          "sender id is int  ${CacheHelper.getData(key: userprofielkey) is int}");
      var message = {'type': description.type, 'sdp': description.sdp, 'a': 121};
      _sendToServer(message);
    }
  }

  delayUpdated10() {
    Future.delayed(Duration(seconds: 20), () {
      print("Updating controller after 10 seconds...");
      // Trigger an update to refresh UI or notify listeners
      update();
    });
  }

  delayUpdated() async {
    _peerConnection?.onTrack = (webrtc.RTCTrackEvent event) {
      print("Track received: ${event.track.kind}");
      if (event.streams.isNotEmpty) {
        _remoteStream = event.streams[1];
        remoteRenderer.srcObject = _remoteStream;

        print("Remote stream set");
        //update();
      }
    };

    await initRenderers();
    await _createPeerConnection();
  }

  // Create an answer in response to an offer
  void _createAnswer() async {
    print("creating answer");
    webrtc.RTCSessionDescription description =
        await _peerConnection!.createAnswer();
    _peerConnection!.setLocalDescription(description);

    var message = {'type': description.type, 'sdp': description.sdp, 'a': 122};
    // _channel?.sink.add(json.encode(message));
    _sendToServer(message);
  }

  // Close the connection
  void closeConnection() {
    print("Closing WebRTC connection...");
    _localStream?.dispose();
    _localStream = null;

    _remoteStream?.dispose();
    _remoteStream = null;

    _peerConnection?.close();
    _peerConnection = null;
  }

  Future<void> reinitializeWebRTC({bool useSoftwareCodec = false}) async {
    try {
      print("Reinitializing WebRTC...");
      await initRenderers();

      Map<String, dynamic> configuration = {
        "iceServers": [
          {
            "urls": "stun:stun.relay.metered.ca:80",
          },
          {
            "urls": "turn:global.relay.metered.ca:80",
            "username": "ea32a9296f465cd97c448dd1",
            "credential": "uCjHC3pOflkzlkoF",
          },
          {
            "urls": "turn:global.relay.metered.ca:80?transport=tcp",
            "username": "ea32a9296f465cd97c448dd1",
            "credential": "uCjHC3pOflkzlkoF",
          },
          {
            "urls": "turn:global.relay.metered.ca:443",
            "username": "ea32a9296f465cd97c448dd1",
            "credential": "uCjHC3pOflkzlkoF",
          },
          {
            "urls": "turns:global.relay.metered.ca:443?transport=tcp",
            "username": "ea32a9296f465cd97c448dd1",
            "credential": "uCjHC3pOflkzlkoF",
          },
        ],
      };

      if (useSoftwareCodec) {
        configuration["optional"] = [
          {"DtlsSrtpKeyAgreement": true},
          {"disableHardwareCodec": true},
        ];
      }

      _peerConnection = await webrtc.createPeerConnection(configuration);
    } catch (e) {
      print("Failed to reinitialize WebRTC: $e");
    }
  }

  @override
  void onClose() {
    print("onCloseee");
    closeConnection();
    super.onClose();
  }

  void terminateCall() {
    _sendToServer({'type': 'end_video_calling'});
    _sendToServer({'type': 'terminate'});
  }

  void _sendToServer(Map<String, dynamic> message) {
    print("${CacheHelper.getData(key: userprofielkey) is int}");
    var userid = CacheHelper.getData(key: userprofielkey);
    var myuserid = CacheHelper.getData(key: useridKey);
    message["sender_id"] = myuserid;
    message["to_user_id"] = userid;
    print("sending to $userid");
    print("sending from $myuserid");
    socketController.sendToServer(message);
  }
}
