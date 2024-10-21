import 'dart:convert';

import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;
import 'package:get/get.dart';
import 'package:naham/helper/ToastMessag/toastmessag.dart';
import 'package:naham/helper/sherdprefrence/shardprefKeyConst.dart';
import 'package:naham/helper/sherdprefrence/sharedprefrenc.dart';

import '../../../../helper/SocketController.dart';

class VideoWebRTCController extends GetxController {
  webrtc.RTCPeerConnection? _peerConnection;
  webrtc.MediaStream? _localStream;
  webrtc.MediaStream? _remoteStream;
  webrtc.RTCVideoRenderer localRenderer = webrtc.RTCVideoRenderer();
  webrtc.RTCVideoRenderer remoteRenderer = webrtc.RTCVideoRenderer();

  // Observables for stream management
  var isCallActive = false.obs;

  late SocketController socketController;

  @override
  void onInit() {
    super.onInit();
    socketController = SocketController();

    socketController.addMessageListener(_handleSocketMessage);
    socketController.addDisconnectListener(_restartConnection);
    socketController.addErrorListener(_restartConnection);
    initRenderers();
  }

  Future<void> _restartConnection() async {
    await _peerConnection?.close();
    await _createPeerConnection();
    await initRenderers();
  }

  initRenderers() async {
    await localRenderer.initialize();
    await remoteRenderer.initialize();
  }

  // Handle signaling messages (offer, answer, ICE candidates)
  Future<void> _handleSocketMessage(dynamic message) async {
    final data = jsonDecode(
        message as String); // Cast 'message' to String before decoding
    print("Data from socket: $message");
    CacheHelper.saveData(
        key: userprofielkey, value: int.parse(data["sender_id"]));

    print("typeee ${data['type']}");

    switch (data['type']) {
      case 'offer':
        await _createPeerConnection();
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
    }
  }

  // Create the peer connection and local stream
  Future<void> _createPeerConnection() async {
    Map<String, dynamic> configuration = {
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

    _peerConnection = await webrtc.createPeerConnection(configuration);

    _peerConnection?.onIceConnectionState = _handleIceConnectionState;

    _peerConnection?.onIceCandidate = (webrtc.RTCIceCandidate candidate) {
      var message = {
        'type': 'candidate',
        'candidate': candidate.candidate,
        'sdpMid': candidate.sdpMid,
        'sdpMLineIndex': candidate.sdpMLineIndex,
      };
      // _channel?.sink.add(json.encode(message));
      _sendToServer(message);
    };

    _peerConnection?.onTrack = (webrtc.RTCTrackEvent event) {
      if (event.streams.isNotEmpty) {
        print("remoteeeeeeeeeee");
        _remoteStream = event.streams[0];
        remoteRenderer.srcObject = _remoteStream;
        update(); // Update the UI if using GetX
      }
    };

    _localStream = await webrtc.navigator.mediaDevices.getUserMedia({
      'video': true,
      'audio': {
        'echoCancellation': true,
        'noiseSuppression': true,
        'volume': 0.0, // Setting volume to lowest
      }
    });
    localRenderer.srcObject = _localStream;

    _localStream?.getTracks().forEach((track) {
      _peerConnection?.addTrack(track, _localStream!);
    });
  }

  // Create an offer to start the call
  void createOffer() async {
    await _createPeerConnection(); // Ensure peer connection is created
    webrtc.RTCSessionDescription description =
        await _peerConnection!.createOffer();
    _peerConnection!.setLocalDescription(description);

    var message = {
      'type': description.type,
      'sdp': description.sdp,
    };
    // _channel?.sink.add(json.encode(message));
    _sendToServer(message);
    isCallActive(true); // Set call status to active
  }

  // Create an answer in response to an offer
  void _createAnswer() async {
    webrtc.RTCSessionDescription description =
        await _peerConnection!.createAnswer();
    _peerConnection!.setLocalDescription(description);

    var message = {
      'type': description.type,
      'sdp': description.sdp,
    };
    // _channel?.sink.add(json.encode(message));
    _sendToServer(message);
  }

  // Close the connection
  void closeConnection() {
    _localStream?.dispose();
    _remoteStream?.dispose();
    _peerConnection?.close();
    isCallActive(false); // Set call status to inactive
  }

  @override
  void onClose() {
    localRenderer.dispose();
    remoteRenderer.dispose();
    closeConnection();
    super.onClose();
  }

  // Show toast based on the ICE connection state
  void _showConnectionToast(webrtc.RTCIceConnectionState state) {
    if (state == webrtc.RTCIceConnectionState.RTCIceConnectionStateConnected) {
      showToast(text: "Connection established!", state: ToastState.SUCCESS);
    } else if (state ==
        webrtc.RTCIceConnectionState.RTCIceConnectionStateCompleted) {
      showToast(text: "Connection completed!", state: ToastState.COMPLEATE);
    } else if (state ==
        webrtc.RTCIceConnectionState.RTCIceConnectionStateClosed) {
      showToast(text: "Connection closed!", state: ToastState.ERROR);
    }
    update();
  }

  // Handle ICE connection state changes
  void _handleIceConnectionState(webrtc.RTCIceConnectionState state) {
    print("ICE Connection State: ${state.name}");
    _showConnectionToast(state);
  }

  int userid = 0;

  void _sendToServer(Map<String, dynamic> message) {
    print("hello ${CacheHelper.getData(key: userprofielkey) is int}");
    userid = CacheHelper.getData(key: userprofielkey);
    var myuserid = CacheHelper.getData(key: useridKey);
    message["to_user_id"] = "$userid";
    message["sender_id"] = "$myuserid";
    print("sending to $userid");
    print("sending from $myuserid");
    socketController.sendToServer(message);

    ///_channel!.sink.add(jsonEncode(message));
  }
}
