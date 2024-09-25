import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:naham/helper/ToastMessag/toastmessag.dart';
import 'package:naham/helper/sherdprefrence/shardprefKeyConst.dart';
import 'package:naham/helper/sherdprefrence/sharedprefrenc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;



class ChatCallController extends GetxController {
  late webrtc.RTCPeerConnection _peerConnection;
  webrtc.MediaStream? _localStream;
  webrtc.MediaStream? _remoteStream;
  late WebSocketChannel _channel;
  bool isTalking = false;
  int userid = 0;
  List<webrtc.RTCIceCandidate> _candidateBuffer = [];
  bool _isOfferAnswerComplete = false;

  @override
  void onInit() async {
    super.onInit();
    await _connectToSignalingServer();
     _initializeWebRTC();

  }

  @override
  void onClose() {
    // TODO: implement onClose
    _cleanupResources();
    print(
        "close()++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    super.onClose();
  }

  @override
  void dispose() {
    super.dispose();
    _cleanupResources();
  }

  startTalking() {
    _startTalking();
  }

  stopTalking() {
    _stopTalking();
  }
  SendEndCallSocket(){
    userid = CacheHelper.getData(key: userprofielkey);
    showToast(text: "user id${userid }", state: ToastState.WARNING);
    var mapendCall =  {"type":"EndCall","to_user_id":userid};
    _channel.sink.add(
       jsonEncode(mapendCall)
    );

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
      "iceServers": [
        {'urls': 'stun:stun1.l.google.com:19302'},
        {'urls': 'stun:stun2.l.google.com:19302'},
        {
          "urls": "turn:global.relay.metered.ca:80",
          "username": "fe2aaa0c26ae5dcc6385d244",
          "credential": "Bk3oEbhGjdv7jkO",
        },
        {
          "urls": "turn:global.relay.metered.ca:80?transport=tcp",
          "username": "fe2aaa0c26ae5dcc6385d244",
          "credential": "Bk3oEbhGjdv7jkO",
        },
        {
          "urls": "turn:global.relay.metered.ca:443",
          "username": "fe2aaa0c26ae5dcc6385d244",
          "credential": "Bk3oEbhGjdv7jkO",
        },
        {
          "urls": "turns:global.relay.metered.ca:443?transport=tcp",
          "username": "fe2aaa0c26ae5dcc6385d244",
          "credential": "Bk3oEbhGjdv7jkO",
        },
      ],
    };
    return await webrtc.createPeerConnection(configuration);
  }

  // ============================= WebSocket Connection =============================

  Future<void> _connectToSignalingServer() async {
    var myuserid = CacheHelper.getData(key: useridKey);
    var usertoken = CacheHelper.getData(key: access_tokenkey);

    print("socketUrl ${'wss://naham.tadafuq.ae?user_id=$myuserid&token=$usertoken'}");
    _channel = WebSocketChannel.connect(
      Uri.parse('wss://naham.tadafuq.ae?user_id=$myuserid&token=$usertoken'),
    );
    _channel.stream.listen(_handleSocketMessage,
        onDone: _handleWebSocketDisconnection, onError: _handleWebSocketError);
  }

  void _sendToServer(Map<String, dynamic> message) {
    userid = CacheHelper.getData(key: userprofielkey);
    var thisUser = CacheHelper.getData(key: useridKey);
    print("sending to user $userid from $thisUser");
    message["to_user_id"] = "$userid";
    print("date to socket ${jsonEncode(message)}");
    _channel.sink.add(jsonEncode(message));
  }

  // ============================= WebRTC Handlers =============================

  void _handleIceCandidate(webrtc.RTCIceCandidate candidate) {
    // Buffer the candidate if offer/answer is not completed yet
    if (!_isOfferAnswerComplete) {
      _candidateBuffer.add(candidate);
    } else {
      // Send the candidate immediately if offer/answer exchange is done
      _sendToServer({'type': 'candidate', 'candidate': candidate.toMap()});
    }
  }
  void _sendBufferedCandidates() {
    if (_candidateBuffer.isNotEmpty) {
      // Send all buffered candidates at once
      final candidatesToSend = _candidateBuffer.map((c) => c.toMap()).toList();
      _sendToServer({'type': 'candidates', 'candidates': candidatesToSend});

      // Clear the buffer after sending
      _candidateBuffer.clear();
    }
  }

  void _handleRemoteStream(webrtc.MediaStream stream) {
    _remoteStream = stream;
    update();
    _playReceivedAudio(stream);
  }

  void _handleIceConnectionState(webrtc.RTCIceConnectionState state) {
    print("ICE Connection State: ${state.name}");
    _showConnectionToast(state);
    if (state ==
            webrtc.RTCIceConnectionState.RTCIceConnectionStateDisconnected ||
        state == webrtc.RTCIceConnectionState.RTCIceConnectionStateFailed) {
      Future.delayed(Duration(seconds: 5), _restartConnection);
    }
  }

  // ============================= WebSocket Handlers =============================

  void _handleSocketMessage(dynamic message) async {
    final data = jsonDecode(message as String);
    print("Data from socket: $message");

    if (data['type'] == "accept_calling") {
      await startTalking();
      var mapacecpted ={"type":"accepted","to_user_id":data['payload']['sender_id']};
      _channel.sink.add(jsonEncode(mapacecpted));
      return;
    }else if(data['type'] == "accepted"){
      showToast(text: "ACCEPTED ACCEPTED ACCEPTED", state: ToastState.WARNING);
      await startTalking();
    } else if (data['type'] == "decline_calling") {
      Fluttertoast.showToast(
        msg: "Decline Calling",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      stopTalking();
      Get.back();
      return;
    }
    else if (data['type'] == "EndCall") {
      stopTalking();
      Get.back();
      return;
    }
    showToast(text: "MICHALE${data['type']}", state: ToastState.ERROR);

    switch (data['type']) {
      case 'offer':
        showToast(text: "ooooooooooooooooooooo", state: ToastState.ERROR);

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

  void _handleCandidates(List<dynamic> candidates) {
    // Loop through and add all the received candidates
    for (var candidateData in candidates) {
      final candidate = webrtc.RTCIceCandidate(
        candidateData['candidate'],
        candidateData['sdpMid'],
        candidateData['sdpMLineIndex'],
      );
      _peerConnection.addCandidate(candidate);
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
    // Handle the offer (setting the remote description and creating an answer)
    final offer = webrtc.RTCSessionDescription(data['sdp'], data['type']);

    await _peerConnection.setRemoteDescription(offer);
    // Create an answer after handling the offer
   await Future.delayed(Duration(seconds: 5),);
    final answer = await _peerConnection.createAnswer();
    await _peerConnection.setLocalDescription(answer);

    // Send the answer to the remote peer
    _sendToServer({
      'type': 'answer',
      'sdp': answer.sdp,
    });

    // Now that the offer/answer exchange is complete, mark it as done
    _isOfferAnswerComplete = true;

    // Send any buffered ICE candidates now
    _sendBufferedIceCandidates();
  }

  void _sendBufferedIceCandidates() {
    if (_candidateBuffer.isNotEmpty) {
      for (var candidate in _candidateBuffer) {
        _sendToServer({'type': 'candidate', 'candidate': candidate.toMap()});
      }
      // Clear the buffer after sending all candidates
      _candidateBuffer.clear();
    }
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
    print("StartCalling");
    if (_localStream == null || _localStream!.getTracks().isEmpty) {
      print("Local stream is null");
      return;
    }
    final audioTracks = _localStream!.getAudioTracks();
    if (audioTracks.isEmpty) {
      print("No audio tracks available.");
      return;
    }
    audioTracks.first.enabled = true;
    if (_peerConnection.signalingState ==
        webrtc.RTCSignalingState.RTCSignalingStateStable) {
      isTalking = true;
      isLoading = false;
    }

    _localStream?.getTracks().forEach((track) {
      _peerConnection.addTrack(track, _localStream!);
    });

    webrtc.RTCSessionDescription offer = await _peerConnection.createOffer();
    await _peerConnection.setLocalDescription(offer);

    update();
    print("sendOffer");
    _sendToServer({'type': 'offer', 'sdp': offer.sdp});

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

    update(); // Update the UI to reflect the change in isTalking state
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
        isTalking = true; // Set isTalking only for the mic-initiating device
      }

      isLoading = false;
      update();
    } else if (state ==
        webrtc.RTCIceConnectionState.RTCIceConnectionStateCompleted) {
      _showToast("Connection completed!", Colors.blue);

      if (isLoading) {
        isTalking = true; // Set isTalking for mic-initiating device only
      }

      isLoading = false;
      update();
    } else if (state ==
        webrtc.RTCIceConnectionState.RTCIceConnectionStateClosed) {
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
