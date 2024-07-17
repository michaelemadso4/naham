import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naham/helper/WebService/webServiceConstant.dart';
import 'package:naham/helper/sherdprefrence/shardprefKeyConst.dart';
import 'package:naham/helper/sherdprefrence/sharedprefrenc.dart';

class Contactcontroller extends GetxController{
  BuildContext context ;
  Contactcontroller({required this.context});
  final StreamController<List<dynamic>> streamController = StreamController();

  @override
  void onInit() async {
    GetGroupUsers();
    super.onInit();
  }

  Future GetGroupUsers()async{
    String access_token =  CacheHelper.getData(key: access_tokenkey);

    var headers = {
      'Authorization': 'Bearer ${access_token}'
    };
    try {
      var dio = Dio();
      var response = await dio.request(
        '${apiurl}user/group_Users',
        options: Options(
          method: 'GET',
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {
        print(json.encode(response.data));
        return response.data;
      }
      else {
        print(response.statusMessage);
      }
    }catch(e){
      print(e);
    }
  }
@override
  void dispose() {
    // TODO: implement dispose
  streamController.close();
  super.dispose();
  }
}