import 'dart:convert';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;
import 'package:get/get.dart';
import 'package:naham/helper/ToastMessag/toastmessag.dart';
import 'package:naham/helper/sherdprefrence/shardprefKeyConst.dart';
import 'package:naham/helper/sherdprefrence/sharedprefrenc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class VideoWebRTCController extends GetxController {
  WebSocketChannel? _channel;
  webrtc.RTCPeerConnection? _peerConnection;
  webrtc.MediaStream? _localStream;
  webrtc.MediaStream? _remoteStream;
  webrtc.RTCVideoRenderer localRenderer = webrtc.RTCVideoRenderer();
  webrtc.RTCVideoRenderer remoteRenderer = webrtc.RTCVideoRenderer();

  // Observables for stream management
  var isCallActive = false.obs;

  @override
  void onInit() {
    super.onInit();
    initRenderers();
  }

  initRenderers() async {
    await localRenderer.initialize();
    await remoteRenderer.initialize();
    await connectToSignalingServer();
  }

  connectToSignalingServer() {
    var myuserid = CacheHelper.getData(key: useridKey);
    var usertoken = CacheHelper.getData(key: access_tokenkey);

    _channel = WebSocketChannel.connect(
      Uri.parse('wss://naham.tadafuq.ae?user_id=$myuserid&token=$usertoken'),
    );
    _channel!.stream.listen(
        _handleSocketMessage,
        onDone: _handleWebSocketDisconnection, onError: _handleWebSocketError);
  }

  // Handle signaling messages (offer, answer, ICE candidates)
  Future<void> _handleSocketMessage(dynamic message) async {
    final data = jsonDecode(
        message as String); // Cast 'message' to String before decoding
    print("Data from socket: $message");
    CacheHelper.saveData(key: userprofielkey, value: data["sender_id"]);

    print(data['type']);

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
        _remoteStream = event.streams[0];
        remoteRenderer.srcObject = _remoteStream;
      }
    };

    _localStream = await webrtc.navigator.mediaDevices.getUserMedia({
      'video': {
        'facingMode': 'user', // To use the back camera
      },
      'audio':  {
    'autoGainControl': true,
    'channelCount': 2,
    'echoCancellation': true,
    'latency': 200,
    'noiseSuppression': true,
    'sampleRate': 48000,
    'sampleSize': 16,
    'volume': 1.0,
    },
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

  void _handleWebSocketDisconnection() {
    showToast(text: "WebSocket disconnected!", state: ToastState.ERROR);

    _sendToServer({'type': 'terminate'});
    _peerConnection?.close();
    localRenderer.initialize();
    remoteRenderer.initialize();
    Future.delayed(
        Duration(seconds: 1), connectToSignalingServer); // Restart connection
  }

  int userid = 0;

  void _handleWebSocketError(error) {
    print("WebSocket error: $error");
    _sendToServer({'type': 'terminate'});
    // Future.delayed(Duration(seconds: 1), _restartConnection);
  }

  void _sendToServer(Map<String, dynamic> message) {
    userid = CacheHelper.getData(key: userprofielkey);
    var myuserid = CacheHelper.getData(key: useridKey);
    message["to_user_id"] = userid.toString();
    message["sender_id"] = "$myuserid";
    print("sending to $userid");
    print("sending from $myuserid");
    _channel!.sink.add(jsonEncode(message));
  }
}
