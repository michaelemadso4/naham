import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoController extends GetxController{
  var data = Get.arguments;

  @override
  void onInit() {
    // TODO: implement onInit
    print(data);
    OpenVideo('$data');
    super.onInit();
  }
  late VideoPlayerController videocontroller;

  OpenVideo(videourl){
    videocontroller = VideoPlayerController.networkUrl(Uri.parse(videourl))..initialize().then((value){
      update();
    });
    videocontroller.play();
  }

  VideoStatus(){
    if(videocontroller.value.isPlaying){
      videocontroller.pause();
    }else{
      videocontroller.play();

    }
    update();
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    videocontroller.dispose();
  }
}