
import 'package:flutter_webrtc/flutter_webrtc.dart';

class WebRTCService {
  late RTCPeerConnection _peerConnection;
  MediaStream? _localStream;

  Future<void> init() async {
    _localStream = await _getUserMedia();
    _peerConnection = await _createPeerConnection();
  }

  Future<MediaStream> _getUserMedia() async {
    final mediaConstraints = {
      'audio': true,
      'video': false,
    };
    return await navigator.mediaDevices.getUserMedia(mediaConstraints);
  }

  Future<RTCPeerConnection> _createPeerConnection() async {
    final configuration = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'}
      ]
    };
    return await createPeerConnection(configuration);
  }

  void startCall() {
    _localStream!.getAudioTracks().first.enabled = true;
    _peerConnection.addStream(_localStream!);
  }

  void endCall() {
    _localStream!.getAudioTracks().first.enabled = false;
  }
}