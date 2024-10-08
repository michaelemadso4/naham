import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:naham/feutcher/Contacts/view/widgets/btn/micrecordbtn.dart';
import 'package:naham/feutcher/Contacts/view/widgets/containerChat/containerChatMessage.dart';
import 'package:naham/feutcher/Groups/controller/group_Chat/group_chat_controller.dart';
import 'package:naham/feutcher/Groups/model/groupinfomodel.dart';
import 'package:naham/feutcher/Groups/view/widgets/Edt/EDT.dart';
import 'package:naham/feutcher/Groups/view/widgets/backgroungGroup/BackGround_Group.dart';
import 'package:naham/helper/ToastMessag/toastmessag.dart';
import 'package:naham/helper/WebRTCController.dart';
import 'package:naham/helper/WebRTCGroupController.dart';
import 'package:naham/helper/sherdprefrence/shardprefKeyConst.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../helper/colors/colorsconstant.dart';
import '../../../../../helper/scalesize.dart';
import '../../../../../helper/sherdprefrence/sharedprefrenc.dart';
import '../../widgets/appbargroup/App_Bar_Group.dart';
import '../GroupChat/GroupChat.dart';

class GrPushtottalkScreen extends StatelessWidget {
  const GrPushtottalkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size, height, width;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Stack(
      children: [
        BackgroundGroup(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
              child: Container(
            width: double.infinity,
            child: Column(
              children: [
                GetBuilder(
                    init: GroupChatController(),
                    builder: (controller) {
                      return  AppBarGroup(
                          apptitle: "${controller.group_name}",
                          isonline:controller.group_isonlin,
                          member: controller.group_members);
                    }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10, right: 10, bottom: 10),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: kTheryColor,
                            child: InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Container(
                                        padding: EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                            color: kPrimaryColor,
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(25),
                                                topLeft: Radius.circular(25))),
                                        height: height * 0.2,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            InkWell(
                                              onTap: () {},
                                              child: Column(
                                                children: [
                                                  Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.white
                                                              .withOpacity(0.5),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20)),
                                                      padding:
                                                          EdgeInsets.all(20),
                                                      child: Icon(
                                                        Icons.camera_alt,
                                                      )),
                                                  Text(
                                                    'Camera',
                                                    style: TextStyle(
                                                        color: Colors.white
                                                            .withOpacity(0.5),
                                                        fontWeight:
                                                            FontWeight.w900),
                                                    textScaleFactor: ScaleSize
                                                        .textScaleFactor(
                                                            context),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {},
                                              child: Column(
                                                children: [
                                                  Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.white
                                                              .withOpacity(0.5),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20)),
                                                      padding:
                                                          EdgeInsets.all(20),
                                                      child: Icon(
                                                        Icons.photo,
                                                      )),
                                                  Text(
                                                    'Gallery',
                                                    style: TextStyle(
                                                        color: Colors.white
                                                            .withOpacity(0.5),
                                                        fontWeight:
                                                            FontWeight.w900),
                                                    textScaleFactor: ScaleSize
                                                        .textScaleFactor(
                                                            context),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                              },
                              child: SvgPicture.asset(
                                'assets/svg/camera.svg', // Ensure you have this SVG file in your assets directory
                              ),
                            ),
                          ),
                          Text(
                            'Camera',
                            textScaleFactor: ScaleSize.textScaleFactor(context),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, right: 10, bottom: 10),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: kTheryColor,
                            child: InkWell(
                              onTap: () {},
                              child: SvgPicture.asset(
                                'assets/svg/ep_location.svg', // Ensure you have this SVG file in your assets directory
                              ),
                            ),
                          ),
                          Text(
                            'Location',
                            textScaleFactor: ScaleSize.textScaleFactor(context),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 10, right: 10, bottom: 10),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: kTheryColor,
                            child: InkWell(
                              onTap: () {},
                              child: SvgPicture.asset(
                                'assets/svg/ci_file-add.svg', // Ensure you have this SVG file in your assets directory
                              ),
                            ),
                          ),
                          Text(
                            'File',
                            textScaleFactor: ScaleSize.textScaleFactor(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Flexible(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.white),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GetBuilder<WebRTCGroupController>(
                          init: WebRTCGroupController(),
                          builder: (controller) {

                            return MicRecordBtn(
                              isLoading: controller.isLoading,
                              isPersing: controller.isPressing,
                              onLongPressEnd: () {},
                              onLongPress: (){},
                              onTap: () {
                                // If the button is loading, stop taking and terminate the connection.
                                if (controller.isLoading) {
                                  controller.stopTalking();
                                  return;
                                }

                                // If the button is not loading and pressing, start taking/mic
                                if (!controller.isPressing) {
                                  controller.startTalking();
                                } else {
                                  // If already in pressing state, stop it
                                  controller.stopTalking();
                                }
                              },
                            );
                          },
                        ),

                        Flexible(

                            flex: 0,
                            child: IconButton(onPressed: (){
                              Get.to(()=>Groupchat(),arguments: {"group_id":2});
                              showToast(text: "Change group id", state: ToastState.WARNING);
                            }, icon: CircleAvatar(
                              radius: 30
                              ,backgroundColor: kPrimaryColor,child: Icon(Icons.chat,color: Colors.white,),)))
                      ],
                    ),
                  ),
                )
              ],
            ),
          )),
        ),
      ],
    );
  }
}
