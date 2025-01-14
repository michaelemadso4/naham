import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:naham/feutcher/Contacts/controller/chatMainScreen/video_Call_Controller.dart';

class VideoCallScreen extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments = Get.arguments ?? {};
    final bool? createOffer = arguments['createOffer'];


    return GetBuilder(
      init: VideoWebRTCController(),
      builder: (controller) {
        if (createOffer == true && !controller.isEnd) {
          controller.createOffer();
        } else {
          controller.delayUpdated();
        }

        controller.delayUpdated10();

        return Scaffold(

          body: GestureDetector(
            onDoubleTap: () {
              // Toggle between local and remote renderer on double tap
              controller.toggleRenderer();
            },
            child: Stack(
              children: [
                // Remote Renderer with Loading (small)
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.black),
                    child: !controller.isLocalRendererVisible.value ? RTCVideoView(controller.localRenderer) : RTCVideoView(controller.remoteRenderer),
                  ),
                ),
                Positioned(
                  right: 12,
                  top: 12,
                  child: Container(
                    width:  150, // Small size when remote
                    height: 200, // Small size when remote
                    decoration: const BoxDecoration(color: Colors.black),
                    child:controller.isLocalRendererVisible.value ? RTCVideoView(controller.localRenderer) : RTCVideoView(controller.remoteRenderer) ,
                  ),
                ),
                // Local Renderer with Loading (large)

              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              controller.funStopTaking();
              controller.EndCall();
              controller.isEnd = true;
              Get.back();
            },
            child: Icon(Icons.call_end),
          ),
        );
      },
    );
  }
}