import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:naham/feutcher/Contacts/controller/userinfoController.dart';
import 'package:naham/feutcher/Contacts/model/userprofielmodel.dart';
import 'package:naham/feutcher/Contacts/view/screen/CallScreen/CallScreen.dart';
import 'package:naham/feutcher/Contacts/view/screen/chatScreen.dart';
import 'package:naham/feutcher/Contacts/view/widgets/btn/micrecordbtn.dart';
import 'package:naham/feutcher/Contacts/webrtcvontroller/PushtoTalkController.dart';
import 'package:naham/helper/colors/colorsconstant.dart';
import 'package:naham/helper/scalesize.dart';
import 'package:naham/helper/sherdprefrence/sharedprefrenc.dart';

import '../../../../helper/WebRTCController.dart';

class Chatcontactscreen extends StatelessWidget {
  Chatcontactscreen({super.key});

  final WebRTCController webRTCController = Get.find<WebRTCController>();


  @override
  Widget build(BuildContext context) {
    var size, height, width;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                kPrimaryColor,
                kSceonderyColor,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
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
          body: Column(
            children: [
              Flexible(
                flex: 0,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(25)),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(top: 30, left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Get.back(
                                    result: () => Get.delete<PushToTalk>());
                              },
                              icon: Icon(
                                Icons.keyboard_arrow_left_sharp,
                                color: Colors.white,
                              )),
                          Image.asset(
                            'assets/images/logo.webp',
                            width: width * 0.1,
                          ),
                        ],
                      ),
                      Text(
                        'Contacts',
                        textScaleFactor: ScaleSize.textScaleFactor(context),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(45),
                          color: Colors.white.withOpacity(
                            0.3,
                          ),
                        ),
                        child: Icon(Icons.person),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: Container(
                  margin: EdgeInsets.only(top: 25),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(45),
                          topRight: Radius.circular(45)),
                      color: Colors.white),
                  child: Column(
                    children: [
                      GetBuilder(
                          init: UserInfoController(),
                          builder: (controller) {
                            return FutureBuilder(
                                future: controller.GetUserInfo(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.only(
                                          top: 25,
                                          bottom:
                                              context.mediaQueryPadding.bottom),
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(45),
                                              topRight: Radius.circular(45)),
                                          color: Colors.white),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: width * 0.4,
                                                height: height * 0.01,
                                                color: kTheryColor,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  CircleAvatar(
                                                    backgroundColor:
                                                        kSceonderyColor,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  CircleAvatar(
                                                    backgroundColor:
                                                        kSceonderyColor,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  CircleAvatar(
                                                    backgroundColor:
                                                        kTheryColor,
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Center(
                                      child: Text("Error: ${snapshot.error}"),
                                    );
                                  } else if (snapshot.hasData) {
                                    UserprofileModel userProfielModel =
                                        UserprofileModel();
                                    userProfielModel =
                                        UserprofileModel.fromJson(
                                            snapshot.data);
                                    return Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  '${userProfielModel.data!.name}',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18),
                                                  textScaleFactor:
                                                      ScaleSize.textScaleFactor(
                                                          context),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.white),
                                                  width: 15,
                                                  height: 15,
                                                  padding: EdgeInsets.all(2),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: userProfielModel
                                                                  .data!
                                                                  .isOnline !=
                                                              null
                                                          ? Colors.green
                                                          : Colors.red,
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                CircleAvatar(
                                                    backgroundColor:
                                                        kSceonderyColor,
                                                    child: IconButton(
                                                        onPressed: () {
                                                          Get.to(
                                                            () => CallScreen(),
                                                          );
                                                          Get.delete<
                                                              PushToTalk>();
                                                        },
                                                        icon: Icon(
                                                          Icons.call,
                                                          color: Colors.white,
                                                        ))),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                CircleAvatar(
                                                    backgroundColor:
                                                        kSceonderyColor,
                                                    child: IconButton(
                                                        onPressed: () {},
                                                        icon: Icon(
                                                          Icons.video_call,
                                                          color: Colors.white,
                                                        ))),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                CircleAvatar(
                                                    backgroundColor:
                                                        kTheryColor,
                                                    child: IconButton(
                                                        onPressed: () {
                                                          CacheHelper.saveData(
                                                              key: 'emailuser',
                                                              value:
                                                                  "${userProfielModel.data!.email}");
                                                          CacheHelper.saveData(
                                                              key: 'nameuser',
                                                              value:
                                                                  "${userProfielModel.data!.name}");
                                                          CacheHelper.saveData(
                                                              key: 'imguser',
                                                              value:
                                                                  "${userProfielModel.data!.profileImageFullUrl}");
                                                          CacheHelper.saveData(
                                                              key: 'iduser',
                                                              value:
                                                                  userProfielModel
                                                                      .data!
                                                                      .id);
                                                          CacheHelper.saveData(
                                                              key: 'userUID',
                                                              value:
                                                                  "${userProfielModel.data!.uid}");
                                                          Get.to(
                                                              () =>
                                                                  ChatScreen(),
                                                              transition: Transition
                                                                  .rightToLeftWithFade,
                                                              duration: Duration(
                                                                  milliseconds:
                                                                      300));
                                                          Get.delete<
                                                              PushToTalk>();
                                                        },
                                                        icon: Icon(Icons
                                                            .chat_outlined))),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Center(child: Text('No data'));
                                  }
                                });
                          }),
                      GetBuilder<WebRTCController>(
                        init: WebRTCController(),
                        builder: (controller) {
                          return MicRecordBtn(
                            isLoading: controller.isLoading,
                            // Update with proper state from controller if needed
                            isPersing: controller.isPressing,
                            // Update with proper state from controller if needed
                            onLongPressEnd: (){},
                            onLongPress: controller.isPressing?(){
                              controller.funStopTaking();

                            }:() {
                              // Start talking/mic
                              controller.funStartTaking();
                              // if (controller.localStream != null) {
                              //   var audioTracks =
                              //       controller.localStream!.getAudioTracks();
                              //   if (audioTracks.isNotEmpty) {
                              //
                              //     controller.funStartTaking();
                              //     audioTracks.first.enabled =
                              //         true; // Enable mic
                              //     controller.peerConnection.addTrack(
                              //         audioTracks.first,
                              //         controller.localStream!);
                              //   }
                              // }
                            },
                          );
                        },
                      ),
                      GetBuilder(
                          init: UserInfoController(),
                          builder: (controller) {
                            return FutureBuilder(
                                future: controller.GetUserInfo(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.only(
                                          top: 25,
                                          bottom:
                                              context.mediaQueryPadding.bottom),
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(45),
                                              topRight: Radius.circular(45)),
                                          color: Colors.white),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: width * 0.4,
                                                height: height * 0.01,
                                                color: kTheryColor,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  CircleAvatar(
                                                    backgroundColor:
                                                        kSceonderyColor,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  CircleAvatar(
                                                    backgroundColor:
                                                        kSceonderyColor,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  CircleAvatar(
                                                    backgroundColor:
                                                        kTheryColor,
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Center(
                                      child: Text("Error: ${snapshot.error}"),
                                    );
                                  } else if (snapshot.hasData) {
                                    UserprofileModel userProfielModel =
                                        UserprofileModel();
                                    userProfielModel =
                                        UserprofileModel.fromJson(
                                            snapshot.data);
                                    return Column(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.all(20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Column(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 40,
                                                    backgroundColor:
                                                        kTheryColor,
                                                    child: InkWell(
                                                      onTap: () {
                                                        showModalBottomSheet(
                                                            context: context,
                                                            builder: (context) {
                                                              return Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            20),
                                                                decoration: BoxDecoration(
                                                                    color:
                                                                        kPrimaryColor,
                                                                    borderRadius: BorderRadius.only(
                                                                        topRight:
                                                                            Radius.circular(
                                                                                25),
                                                                        topLeft:
                                                                            Radius.circular(25))),
                                                                height: height *
                                                                    0.2,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceAround,
                                                                  children: [
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        controller
                                                                            .PickImagefromCamera();
                                                                      },
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Container(
                                                                              decoration: BoxDecoration(color: Colors.white.withOpacity(0.5), borderRadius: BorderRadius.circular(20)),
                                                                              padding: EdgeInsets.all(20),
                                                                              child: Icon(
                                                                                Icons.camera_alt,
                                                                              )),
                                                                          Text(
                                                                            'Camera',
                                                                            style:
                                                                                TextStyle(color: Colors.white.withOpacity(0.5), fontWeight: FontWeight.w900),
                                                                            textScaleFactor:
                                                                                ScaleSize.textScaleFactor(context),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        controller
                                                                            .PickImagefromGalary();
                                                                      },
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Container(
                                                                              decoration: BoxDecoration(color: Colors.white.withOpacity(0.5), borderRadius: BorderRadius.circular(20)),
                                                                              padding: EdgeInsets.all(20),
                                                                              child: Icon(
                                                                                Icons.photo,
                                                                              )),
                                                                          Text(
                                                                            'Gallery',
                                                                            style:
                                                                                TextStyle(color: Colors.white.withOpacity(0.5), fontWeight: FontWeight.w900),
                                                                            textScaleFactor:
                                                                                ScaleSize.textScaleFactor(context),
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
                                                    textScaleFactor: ScaleSize
                                                        .textScaleFactor(
                                                            context),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 40,
                                                    backgroundColor:
                                                        kTheryColor,
                                                    child: InkWell(
                                                      onTap: () {
                                                        controller.SendLocation(
                                                            context,
                                                            userProfielModel
                                                                .data!.id);
                                                      },
                                                      child: controller.isSend
                                                          ? CircularProgressIndicator()
                                                          : SvgPicture.asset(
                                                              'assets/svg/ep_location.svg', // Ensure you have this SVG file in your assets directory
                                                            ),
                                                    ),
                                                  ),
                                                  Text(
                                                    'Location',
                                                    textScaleFactor: ScaleSize
                                                        .textScaleFactor(
                                                            context),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 40,
                                                    backgroundColor:
                                                        kTheryColor,
                                                    child: InkWell(
                                                      onTap: () {
                                                        controller
                                                            .PickfileFromGalary();
                                                      },
                                                      child: SvgPicture.asset(
                                                        'assets/svg/ci_file-add.svg', // Ensure you have this SVG file in your assets directory
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    'File',
                                                    textScaleFactor: ScaleSize
                                                        .textScaleFactor(
                                                            context),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        controller.latitude.isEmpty
                                            ? Container()
                                            : Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      child: InkWell(
                                                          onTap: () {
                                                            controller.openLocation(
                                                                'https://www.google.com/maps/search/?api=1&query=${controller.latitude},${controller.longitude}');
                                                          },
                                                          child: Text(
                                                            'https://www.google.com/maps/search/?api=1&query=${controller.latitude},${controller.longitude}',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .blue),
                                                          )),
                                                    ),
                                                    Expanded(
                                                      child: InkWell(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        onTap: () {
                                                          controller.SendLocatio(
                                                              context,
                                                              userProfielModel
                                                                  .data!.id);
                                                        },
                                                        child: Icon(
                                                          Icons.send,
                                                          color: kPrimaryColor,
                                                          // size: 40,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                      ],
                                    );
                                  } else {
                                    return Text("No Data");
                                  }
                                });
                          }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/*
 */
