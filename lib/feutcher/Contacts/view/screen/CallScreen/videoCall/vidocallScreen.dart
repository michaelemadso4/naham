import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:naham/feutcher/Contacts/controller/chatMainScreen/video_Call_Controller.dart';

class VideoCallScreen extends StatelessWidget {
  // Inject the WebRTCController
  final VideoWebRTCController _controller = Get.put(VideoWebRTCController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebRTC Video Call with GetX'),
      ),
      body: Stack(
        children: [
          Obx(() {
            // Show the remote video when the call is active
            return _controller.isCallActive.value
                ? Positioned.fill(
                    child: RTCVideoView(_controller.remoteRenderer,mirror: true,),
                  )
                : Center(child: Text('Waiting for call...'));
          }),
          Positioned(
            right: 12,
            top: 12,
            child: Container(
                width: 150,
                height: 200,
                child: RTCVideoView(_controller.localRenderer, mirror: true),
                /*color: Colors.black,*/
            ),
          ),
        ],
      ),
      floatingActionButton: Obx(() {
        return FloatingActionButton(
          onPressed: () {
            if (!_controller.isCallActive.value) {
              _controller.createOffer();
            } else {
              _controller.closeConnection();
            }
          },
          child: Icon(
            _controller.isCallActive.value ? Icons.call_end : Icons.video_call,
          ),
        );
      }),
    );
  }
}
