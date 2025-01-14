import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naham/feutcher/Auth/Login/model/usermodel.dart';
import 'package:naham/feutcher/mainScreen/view/Screen/mainScreen.dart';
import 'package:naham/helper/WebService/webServiceConstant.dart';
import 'package:naham/helper/sherdprefrence/shardprefKeyConst.dart';
import 'package:naham/helper/sherdprefrence/sharedprefrenc.dart';
import 'package:naham/network/firebase/FirebaseAuth.dart';

class LoginController extends GetxController {
  BuildContext context;

  LoginController({required this.context});

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool IsLogin = false;
  TextEditingController EmailTEC = TextEditingController();
  TextEditingController PasswordTEC = TextEditingController();

  SignINFireBase() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: EmailTEC.text,
        password: PasswordTEC.text,
      );
      User? user = userCredential.user;
      print('User signed in: ${user!.uid}');
      if (user.uid != null) {
        // Get.to(() => MainScreen());
        IsLogin = false;
        update();
      }
    } catch (e) {
      print('Failed to sign in: $e');
      IsLogin = false;
      update();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red.shade900,
        duration: Duration(seconds: 5),
        content: Text('Failed to sign in: $e. Please check your credentials.'),
      ));
    }
  }
  String? fcmToken;

  Future<void> getFCMToken() async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      String? token = await messaging.getToken();
      fcmToken = token;
      update();
      print("FCM Token: $fcmToken");
    } catch (e) {
      print("Error getting FCM token: $e");
    }
  }

  SignInWebService() async {
    IsLogin = true;
    update();
    await getFCMToken();
    Dio dio = Dio();
    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    var data = {
      'email': '${EmailTEC.text}',
      'password': '${PasswordTEC.text}',
      'FcmToken': '${fcmToken}'
    };
    try {
      var response = await dio.post('${apiurl}${apilogin}',
          options: Options(
            headers: headers,
            validateStatus: (status) => true,
          ),
          data: data);
      print(response.data);
      print(response.statusCode);
      if (response.statusCode == 200) {
        Usermodel usermodel = Usermodel();
        usermodel = Usermodel.fromJson(response.data);
        print(usermodel);
        CacheHelper.saveData(key: isLoginkey, value: true);
        CacheHelper.saveData(key: useridKey, value: usermodel.data!.id);
        CacheHelper.saveData(key: usernameKey, value: usermodel.data!.name);
        CacheHelper.saveData(key: useremailKey, value: usermodel.data!.email);
        CacheHelper.saveData(
            key: access_tokenkey, value: usermodel.data!.accessToken);

        CacheHelper.saveData(
            key: userphotoKey, value: usermodel.data!.profileImageFullUrl);
        CacheHelper.saveData(key: usergurdKey, value: usermodel.data!.guard);
        // Get.toNamed("/mainscreen");
        Get.offNamed('/mainscreen');
        // SignINFireBase();
        update();
      } else if (response.statusCode == 401) {
        IsLogin = false;
        update();

        if (response.data['message'] == "Invalid Credentials.") {
          IsLogin = false;
          update();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red.shade900,
            duration: Duration(seconds: 5),
            content: Text('${response.data['message']}'),
          ));
        }else{
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red.shade900,
            duration: Duration(seconds: 5),
            content: Text('${response.data['message']}'),
          ));
        }
      } else {
        print(response.statusCode);
        print(response.data);
        IsLogin = false;

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red.shade900,
          duration: Duration(seconds: 5),
          content: Text('Failed to sign in'),
        ));
        update();
      }
    } catch (e) {
      IsLogin = false;
      update();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red.shade900,
        duration: Duration(seconds:10),
        content: Text('Failed to sign in: $e.'),
      ));
    }
  }

}
