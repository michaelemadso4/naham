import 'package:get/get.dart';
import 'package:naham/feutcher/Auth/Login/view/screen/LoginScreen.dart';
import 'package:naham/feutcher/SplaschScreen/view/Screens/SplaschScreen.dart';
import 'package:naham/feutcher/mainScreen/view/Screen/mainScreen.dart';
part 'app_routes.dart';
class AppPages{
  static final routes=[
    GetPage(name: _Paths.LOGIN, page: ()=>LoginScreen()),
    GetPage(name: _Paths.MAINSCREEN, page: ()=>MainScreen()),
    GetPage(name: _Paths.INTRODUCTION, page: ()=>SplaschScreen()),


  ];
}