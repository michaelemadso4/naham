import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:naham/feutcher/Contacts/controller/TimeController/TimeController.dart';
import 'package:naham/feutcher/Contacts/controller/callScreenController/callScreenController.dart';
import 'package:naham/feutcher/Contacts/controller/userinfoController.dart';
import 'package:naham/feutcher/Contacts/model/userprofielmodel.dart';
import 'package:naham/feutcher/Contacts/view/widgets/IconBtn/IconBtn.dart';
import 'package:naham/feutcher/Contacts/view/widgets/Text/Body1_txt.dart';
import 'package:naham/feutcher/Contacts/view/widgets/Text/Body2_txt.dart';
import 'package:naham/feutcher/Contacts/view/widgets/Text/Titletxt.dart';
import 'package:naham/helper/colors/colorsconstant.dart';

class CallScreen extends StatelessWidget {
  const CallScreen({super.key});


  @override
  Widget build(BuildContext context){
    final Map<String, dynamic> arguments = Get.arguments ?? {};
    final bool? isStartTalking = arguments['is_start_talking'];

    // CallScreenController callScreenController = Get.put(CallScreenController());
    // if(isStartTalking == true) {
    //   Timer(Duration(seconds: 2),() async {
    //   await callScreenController.createOffer();
    //   callScreenController.update();
    //   });
    //
    //   print("isStartTalking${isStartTalking}");
    // }

    var size, height, width;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Stack(
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                kTheryColor,
                kPrimaryColor,

                kSceonderyColor,
                kTheryColor,

              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: double.infinity,
          child: Transform.scale(
            scale: 1,
            child: Opacity(
              opacity: 0.1,
              child: Image.asset(
                'assets/images/logo.webp',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: ListView(
              children: [
                Container(height: height* 0.9,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                          flex: 2,
                          child: Titletxt(
                            data: 'Calling...',
                          )),
                      Spacer(),
                      Flexible(
                        flex: 2,
                        child: GetBuilder(
                            init: UserInfoController(),
                            builder: (controller) {
                              return FutureBuilder(future: controller.GetUserInfo(), builder: (context,snapshot){
                                if(snapshot.connectionState == ConnectionState.waiting) {
                                  return Padding(
                                    padding: const EdgeInsets.all(30.0),
                                    child: LinearProgressIndicator(borderRadius: BorderRadius.circular(20),),
                                  );
                                }
                                else if(snapshot.hasData){
                                  UserprofileModel userProfileModel = UserprofileModel();
                                  userProfileModel = UserprofileModel.fromJson(snapshot.data);
                                  return Column(
                                    children: [
                                      Flexible(
                                          flex: 1,child: Titletxt(data: '${userProfileModel.data!.name}')),
                                      Flexible(
                                        flex: 1,
                                        child: Body1txt(data: "${userProfileModel.data!.email}"),
                                      ),
                                    ],
                                  );
                                }else{
                                  return Column(
                                    children: [
                                      Flexible(
                                        child: Stack(
                                          alignment: Alignment.bottomCenter,
                                          children: [
                                            Icon(Icons.cloud,color: Colors.red,size: 60,),
                                            Icon(Icons.offline_bolt,color: Colors.white,size: 20,),

                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 16,),
                                      Flexible(child: Body2txt(data: "Oops!")),
                                      Flexible(child: Body1txt(data: "No Internet  connection found\ncheck yout connectio or Try Again"))
                                    ],
                                  );
                                }
                              });
                            }
                        ),
                      ),
                      Flexible(flex: 1, child: GetBuilder(
                          init: TimeController(),
                          builder: (controller) {
                            return Body2txt(data: "${controller.formatTime(controller.counter)}");
                          }
                      )),

                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center ,
                        children: [
                          Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: CircleAvatar(
                              radius: 40  ,
                              backgroundColor: Colors.red,
                              child:GetBuilder(
                                init:CallScreenController(),
                                builder: (callScreenController) {
                                  if(isStartTalking == true) {
                                    callScreenController.createOffer();
                                    print("isStartTalking${isStartTalking}");
                                  }
                                  return IconButton(
                                    onPressed: () {
                                      callScreenController.funStopTaking();
                                      callScreenController.EndCall();
                                      Get.back();
                                    },
                                    icon: Icon(
                                      size: 45 ,
                                      Icons.call_end,
                                      color: Colors.white,
                                    ),
                                  );
                                }
                              ),
                            ),
                          ),

                        ],
                      ),




                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
