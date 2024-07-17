import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LongpressController extends GetxController with GetTickerProviderStateMixin{
  late Animation animation;
  late AnimationController animationController;
  var listRadus = [150.0 ,200.0,250.0,300.0,350.0];

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    animationController = AnimationController(vsync: this, duration: Duration(seconds: 4));
    animation = Tween(begin: 2.0,end: 10.0).animate(animationController);

    animationController.addListener((){
      update();
    });
    animationController.forward();
  }
}