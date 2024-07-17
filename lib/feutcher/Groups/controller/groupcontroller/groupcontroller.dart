import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:naham/helper/WebService/webServiceConstant.dart';
import 'package:naham/helper/sherdprefrence/shardprefKeyConst.dart';
import 'package:naham/helper/sherdprefrence/sharedprefrenc.dart';

class GroupController extends GetxController{


 Future GetGroupList()async{
    String access_token =  CacheHelper.getData(key: access_tokenkey);

    var headers = {
      'Authorization': 'Bearer ${access_token}'
    };
    try{
      var dio = Dio();
      var response = await dio.request(
        '${apiurl}user/group',
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

    }catch(e){}
  }
}