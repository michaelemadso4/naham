import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;
import 'package:get/get.dart';
import 'package:naham/helper/sherdprefrence/sharedprefrenc.dart';
import 'package:naham/helper/sherdprefrence/shardprefKeyConst.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PushToTalk extends GetxController {
  BuildContext context;
  PushToTalk({required this.context});

  late webrtc.RTCPeerConnection _peerConnection;
  webrtc.MediaStream? _localStream;
  webrtc.MediaStream? _remoteStream;
  late WebSocketChannel _channel;
  bool isTalking = false;
  int userid = 0;

  @override
  void onInit() async {
    super.onInit();
    await _initializeWebRTC();
    _connectToSignalingServer();
  }

 @override
  void onClose() {
    // TODO: implement onClose
   _cleanupResources();
   print("close()++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    super.onClose();
  }

  @override
  void dispose() {
    super.dispose();
    _cleanupResources();
    print("dispose()++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");

  }

  startTalking(){
    _startTalking();
  }
  stopTalking(){
    _stopTalking();
  }

  // ============================= WebRTC Initialization =============================

  Future<void> _initializeWebRTC() async {
    _localStream = await _getUserMedia();
    _peerConnection = await _createPeerConnection();

    _peerConnection.onIceCandidate = _handleIceCandidate;
    _peerConnection.onAddStream = _handleRemoteStream;
    _peerConnection.onIceConnectionState = _handleIceConnectionState;

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
      'iceServers': [
        {'urls': 'stun:stun1.l.google.com:19302'},
        {'urls': 'stun:stun2.l.google.com:19302'},
        {
          'urls': 'turns:34.38.50.190:3478',
          'username': 'naham',
          'credential': 'TyALteSZ8u5XcC92HdnWqf'
        },
      ],
    };
    return await webrtc.createPeerConnection(configuration);
  }

  // ============================= WebSocket Connection =============================

  void _connectToSignalingServer() {
    var myuserid = CacheHelper.getData(key: useridKey);
    var usertoken = CacheHelper.getData(key: access_tokenkey);

    _channel = WebSocketChannel.connect(
      Uri.parse('wss://naham.tadafuq.ae?user_id=$myuserid&token=$usertoken'),
    );
    _channel.stream.listen(_handleSocketMessage, onDone: _handleWebSocketDisconnection, onError: _handleWebSocketError);
  }

  void _sendToServer(Map<String, dynamic> message) {
    userid = CacheHelper.getData(key: userprofielkey);
    message["to_user_id"] = "$userid";
    _channel.sink.add(jsonEncode(message));
  }

  // ============================= WebRTC Handlers =============================



  void _handleIceCandidate(webrtc.RTCIceCandidate candidate) {
    _sendToServer({'type': 'candidate', 'candidate': candidate.toMap()});
  }

  void _handleRemoteStream(webrtc.MediaStream stream) {
    _remoteStream = stream;
    update();
    _playReceivedAudio(stream);
  }

  void _handleIceConnectionState(webrtc.RTCIceConnectionState state) {
    print("ICE Connection State: ${state.name}");
    _showConnectionToast(state);
    if (state == webrtc.RTCIceConnectionState.RTCIceConnectionStateDisconnected ||
        state == webrtc.RTCIceConnectionState.RTCIceConnectionStateFailed) {
      Future.delayed(Duration(seconds: 5), _restartConnection);
    }
  }

  // ============================= WebSocket Handlers =============================

  void _handleSocketMessage(dynamic message) {
    final data = jsonDecode(message as String); // Cast 'message' to String before decoding
    print("Data from socket: $message");

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
      case 'terminate':
        _handleTerminate();
        break;
    }
  }

  void _handleWebSocketDisconnection() {
    Fluttertoast.showToast(
      msg: "WebSocket disconnected!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    stopTalking();
    _sendToServer({'type': 'terminate'});
    Future.delayed(Duration(seconds: 5), _restartConnection);
  }

  void _handleWebSocketError(error) {
    print("WebSocket error: $error");
    _sendToServer({'type': 'terminate'});
    Future.delayed(Duration(seconds: 5), _restartConnection);
  }

  // ============================= SDP & ICE Candidate Handlers =============================

  void _handleOffer(Map<String, dynamic> data) async {
    final description = webrtc.RTCSessionDescription(data['sdp'], 'offer');
    await _peerConnection.setRemoteDescription(description);
    final answer = await _peerConnection.createAnswer();
    await _peerConnection.setLocalDescription(answer);
    _sendToServer({'type': 'answer', 'sdp': answer.sdp});
  }

  void _handleAnswer(Map<String, dynamic> data) async {
    final description = webrtc.RTCSessionDescription(data['sdp'], 'answer');
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
    if (isTalking) {
      // Only disable the mic if this device was the one talking
      _localStream?.getAudioTracks().first.enabled = false;
      isTalking = false;
      update();
    }
  }

  // ============================= Media Control =============================

  void _playReceivedAudio(webrtc.MediaStream stream) {
    for (var track in stream.getAudioTracks()) {
      track.enabled = true;
    }
    print("Playing received audio stream.");
  }

  bool isLoading = false;
  void _startTalking() async {
    isLoading = true;
    update();
    if (_localStream == null || _localStream!.getTracks().isEmpty) {
      print("Local stream is null");
      return;
    }
    final audioTracks = _localStream!.getAudioTracks();
    if (audioTracks.isEmpty) {
      print("No audio tracks available.");
      return;
    }
    if(_peerConnection.signalingState == webrtc.RTCSignalingState.RTCSignalingStateStable) {
      audioTracks.first.enabled = true;
      isTalking = true;
      isLoading = false;
    }

    _localStream?.getTracks().forEach((track) {
      _peerConnection.addTrack(track, _localStream!);
    });

    var constraints = <String, dynamic>{'iceRestart': true};
    webrtc.RTCSessionDescription offer = await _peerConnection.createOffer(constraints);
    await _peerConnection.setLocalDescription(offer);

    _sendToServer({'type': 'offer', 'sdp': offer.sdp, 'iceRestart': true});

    // Set isTalking = true only on the device that sends the offer
    // isTalking = true;
    // update();
  }

  void _stopTalking() {
    // This method is triggered when the local device presses the mic stop button
    isLoading = false;
    isTalking = false;

    // Disable the audio track only on the local device
    _localStream?.getAudioTracks().first.enabled = false;

    // Send a "stop" signal to the other device via WebSocket
    _sendToServer({'type': 'stop'});

    update();  // Update the UI to reflect the change in isTalking state
  }

  // ============================= Error and Restart Handlers =============================

  void _handleTerminate() async {
    print("Terminate message received, closing connection...");
    await _peerConnection.close();
    _localStream?.dispose();
    _remoteStream?.dispose();

    Fluttertoast.showToast(
      msg: "Connection terminated by remote peer.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    stopTalking();

    // isTalking = false;
    update();
  }

  Future<void> _restartConnection() async {
    await _peerConnection.close();
    await _initializeWebRTC();
    _connectToSignalingServer();
    if (isTalking) {
      _startTalking();
    }
  }

  // ============================= Cleanup =============================

  void _cleanupResources() {
    _localStream?.dispose();
    _remoteStream?.dispose();
    _peerConnection.close();
    _channel.sink.close();
  }

  // ============================= UI Notifications =============================

  void _showConnectionToast(webrtc.RTCIceConnectionState state) {
    if (state == webrtc.RTCIceConnectionState.RTCIceConnectionStateConnected) {
      _showToast("Connection established!", Colors.green);

      // Set isTalking to true only if the local user initiated the call by pressing the mic button
      if (isLoading) {
        isTalking = true;  // Set isTalking only for the mic-initiating device
      }

      isLoading = false;
      update();

    } else if (state == webrtc.RTCIceConnectionState.RTCIceConnectionStateCompleted) {
      _showToast("Connection completed!", Colors.blue);

      if (isLoading) {
        isTalking = true;  // Set isTalking for mic-initiating device only
      }

      isLoading = false;
      update();

    } else if (state == webrtc.RTCIceConnectionState.RTCIceConnectionStateClosed) {
      var audioTrack = _localStream?.getAudioTracks()?.first;
      isTalking = audioTrack != null ? audioTrack.enabled : false;
      isLoading = false;
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
}
