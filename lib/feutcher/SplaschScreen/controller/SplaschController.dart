import 'dart:async';

import 'package:get/get.dart';
import 'package:naham/feutcher/Auth/Login/view/screen/LoginScreen.dart';
import 'package:naham/feutcher/mainScreen/view/Screen/mainScreen.dart';
import 'package:naham/helper/sherdprefrence/shardprefKeyConst.dart';
import 'package:naham/helper/sherdprefrence/sharedprefrenc.dart';

class Splaschcontroller extends GetxController{
@override
  void onInit() {
    // TODO: implement onInit

  bool? islogin;
  islogin = CacheHelper.getData(key: isLoginkey);
  if(islogin == null||  islogin == false ){
    islogin = false;
  }else{
    islogin =true;
  }
  Timer(Duration(milliseconds: 2500),(){
    !islogin!?Get.off(()=>LoginScreen(),transition:Transition.fade , duration: Duration(seconds: 1)):Get.off(()=>MainScreen(),transition:Transition.fade , duration: Duration(seconds: 1));
  });

  super.onInit();
  }
}