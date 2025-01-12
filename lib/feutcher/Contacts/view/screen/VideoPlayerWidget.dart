
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naham/feutcher/Contacts/controller/videoController.dart';
import 'package:naham/helper/colors/colorsconstant.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatelessWidget {
  const VideoPlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: GetBuilder(
          init: VideoController(),
          builder: (controller) {
            return IconButton(icon: Icon(Icons.keyboard_arrow_left_sharp,color: kSceonderyColor,),onPressed: (){
              controller.videocontroller.pause();
              Get.back();
            },);
          }
        ),
      ),body: GetBuilder(
      init:VideoController() ,
        builder: (controller) {
          return Center(
          child: controller.videocontroller.value.isInitialized?AspectRatio(
            aspectRatio: controller.videocontroller.value.aspectRatio,
            child: VideoPlayer(controller.videocontroller,),
          )
              : CircularProgressIndicator(),
              );
        }
      ),
      bottomNavigationBar: GetBuilder(
        init:VideoController() ,
        builder: (controller) {
          return Container(
            decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2)),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: (){controller.VideoStatus();}, icon: Icon(controller.videocontroller.value.isPlaying?Icons.pause:Icons.play_circle,color: Colors.white,)),
              ],
            ),
          );
        }
      ),
    );
  }
}
