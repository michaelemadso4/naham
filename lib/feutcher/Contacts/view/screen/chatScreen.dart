import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:naham/feutcher/Contacts/controller/chatMainScreen/chatMainControlle.dart';
import 'package:naham/feutcher/Contacts/controller/userinfoController.dart';
import 'package:naham/feutcher/Contacts/view/screen/CallScreen/CallScreen.dart';
import 'package:naham/feutcher/Contacts/view/screen/operator/chatoperator.dart';
import 'package:naham/feutcher/Contacts/view/widgets/containerChat/ContainerChatImage.dart';
import 'package:naham/feutcher/Contacts/view/widgets/containerChat/ContainerLocationChat.dart';
import 'package:naham/feutcher/Contacts/view/widgets/containerChat/ContainerVideoChat.dart';
import 'package:naham/feutcher/Contacts/view/widgets/containerChat/ContainerVoiceChat.dart';
import 'package:naham/feutcher/Contacts/view/widgets/containerChat/containerChatMessage.dart';
import 'package:naham/feutcher/Contacts/view/widgets/containerChat/containerSheetView.dart';
import 'package:naham/feutcher/Contacts/view/widgets/edtchat/edtchat.dart';
import 'package:naham/helper/colors/colorsconstant.dart';
import 'package:naham/helper/scalesize.dart';
import 'package:video_player/video_player.dart';
import 'package:web_socket_channel/io.dart';

import '../../model/userprofielmodel.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

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
                child: GetBuilder(
                    init: UserInfoController(),
                    builder: (controller) {
                      return Container(
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(25)),
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(top: 30, left: 10, right: 10),
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  Get.back();
                                },
                                icon: Icon(
                                  Icons.keyboard_arrow_left_sharp,
                                  color: Colors.black,
                                )),
                            FutureBuilder(
                                future: controller.GetUserInfo(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Container(
                                      color: Colors.cyanAccent.withOpacity(0.1),
                                      width: width * 0.1,
                                      height: height * 0.01,
                                    );
                                  } else if (snapshot.hasData) {
                                    UserprofileModel userProfielModel =
                                        UserprofileModel();
                                    userProfielModel =
                                        UserprofileModel.fromJson(
                                            snapshot.data);

                                    return Row(
                                      children: [
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
                                                          .data!.isOnline !=
                                                      null
                                                  ? Colors.green
                                                  : Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          '${userProfielModel.data!.name}',
                                          textScaleFactor:
                                              ScaleSize.textScaleFactor(
                                                  context),
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Center(child: Text('No data'));
                                  }
                                }),
                            Spacer(),
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Get.to(()=> CallScreen(),
                                      );
                                      Get.delete<ChatMainController>();
                                    },
                                    icon: Icon(
                                      Icons.call_outlined,
                                      color: Colors.black,
                                    )),
                                IconButton(
                                    onPressed: () {

                                    },
                                    icon: SvgPicture.asset(
                                      width: width * 0.07,
                                      'assets/svg/camera.svg', // Ensure you have this SVG file in your assets directory
                                    )),
                              ],
                            )
                          ],
                        ),
                      );
                    }),
              ),
              Flexible(
                  flex: 0,
                  child: GetBuilder(
                      init: ChatMainController(),
                      builder: (controllerMessage) {
                      return Container(
                        margin: EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              child: CircleAvatar(
                                radius: 35,
                                backgroundColor: kTheryColor,
                                child: InkWell(
                                  onTap: ()async {

                                    await controllerMessage.extractCoordinates();
                                    showModalBottomSheet(context: context, builder: (context){

                                      return Container(
                                        padding: EdgeInsets
                                            .all(20),
                                        decoration: BoxDecoration(
                                            color: kPrimaryColor,
                                            borderRadius: BorderRadius
                                                .only(
                                                topRight: Radius
                                                    .circular(
                                                    25),
                                                topLeft: Radius
                                                    .circular(
                                                    25))
                                        ),
                                        height: height *
                                            0.4,
                                        child: Column(
                                          children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20)
                                            ),
                                          height: height*0.2,
                                          child:ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                            child: GoogleMap(
                                              initialCameraPosition:CameraPosition(
                                                target: controllerMessage.xposition,
                                                zoom: 14.0,
                                              ),
                                              markers: {
                                                Marker(
                                                  markerId: MarkerId('position'),
                                                  position:controllerMessage.xposition,
                                                )
                                              },
                                            ),
                                          ) ,
                                        ),
                                            SizedBox(height: 20,),
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  foregroundColor: Colors.black,
                                                  backgroundColor:  Colors.white,
                                                  minimumSize: Size(double.infinity, 45),
                                                  padding: EdgeInsets.symmetric(horizontal: 16,vertical: 16),
                                                  shape: const RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(50)),
                                                  ),
                                                ),
                                                onPressed: (){
                                              controllerMessage.SendLocatio(context,controllerMessage.userid
                                                .toString() );
                                              }, child: Text("Sent Current Location",
                                              textScaleFactor:
                                              ScaleSize.textScaleFactor(
                                                  context),
                                            ))
                                          ],
                                        ),
                                      );
                                    });
                                  },
                                  child: SvgPicture.asset(
                                    width: width * 0.1,
                                    'assets/svg/ep_location.svg', // Ensure you have this SVG file in your assets directory
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              child: CircleAvatar(
                                radius: 35,
                                backgroundColor: kTheryColor,
                                child: InkWell(
                                    onTap: () {
                                      controllerMessage.isRecording
                                          ? controllerMessage.stopRecording()
                                          : controllerMessage.startRecording();
                                    },
                                    child: Icon(
                                      controllerMessage.isRecording ?Icons.pause:Icons.keyboard_voice_rounded,
                                      size: 40,
                                    )),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              child: CircleAvatar(
                                radius: 35,
                                backgroundColor: kTheryColor,
                                child: InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return Container(
                                            padding: EdgeInsets
                                                .all(20),
                                            decoration: BoxDecoration(
                                                color: kPrimaryColor,
                                                borderRadius: BorderRadius
                                                    .only(
                                                    topRight: Radius
                                                        .circular(
                                                        25),
                                                    topLeft: Radius
                                                        .circular(
                                                        25))
                                            ),
                                            height: height *
                                                0.2,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceAround,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    controllerMessage
                                                        .PickImagefromCamera();
                                                  },
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                  0.5),
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  20)),
                                                          padding:
                                                          EdgeInsets
                                                              .all(
                                                              20),
                                                          child: Icon(
                                                            Icons
                                                                .camera_alt,
                                                          )),
                                                      Text(
                                                        'Camera',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white
                                                                .withOpacity(
                                                                0.5),
                                                            fontWeight: FontWeight
                                                                .w900),
                                                        textScaleFactor:
                                                        ScaleSize
                                                            .textScaleFactor(
                                                            context),),
                                                    ],
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    controllerMessage
                                                        .PickImagefromGalary();
                                                  },
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                  0.5),
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  20)),
                                                          padding:
                                                          EdgeInsets
                                                              .all(
                                                              20),
                                                          child: Icon(
                                                            Icons
                                                                .photo,
                                                          )),
                                                      Text(
                                                        'Gallery',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white
                                                                .withOpacity(
                                                                0.5),
                                                            fontWeight: FontWeight
                                                                .w900),
                                                        textScaleFactor:
                                                        ScaleSize
                                                            .textScaleFactor(
                                                            context),),
                                                    ],
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    controllerMessage
                                                        .PickVideoFromGalary();
                                                  },
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                  0.5),
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  20)),
                                                          padding:
                                                          EdgeInsets.all(
                                                              20),
                                                          child: Icon(
                                                            Icons
                                                                .video_collection,
                                                          )),
                                                      Text('Video\nGallery',style: TextStyle(color:  Colors
                                                          .white
                                                          .withOpacity(
                                                          0.5),fontWeight: FontWeight.w900), textScaleFactor:
                                                      ScaleSize
                                                          .textScaleFactor(
                                                          context),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    controllerMessage
                                                        .PickVideoFromCamera();
                                                  },
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                  0.5),
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  20)),
                                                          padding:
                                                          EdgeInsets.all(
                                                              20),
                                                          child: Icon(
                                                            Icons
                                                                .video_camera_back,
                                                          )),
                                                      Text('Camera\nVideo',style: TextStyle(color:  Colors
                                                          .white
                                                          .withOpacity(
                                                          0.5),fontWeight: FontWeight.w900), textScaleFactor:
                                                      ScaleSize
                                                          .textScaleFactor(
                                                          context),
                                                        textAlign: TextAlign.center,
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
                                    width: width * 0.1,

                                    'assets/svg/camera.svg', // Ensure you have this SVG file in your assets directory
                                  ),
                                ),
                              ),
                            ),

                            CircleAvatar(
                              radius: 35,
                              backgroundColor: kTheryColor,
                              child: InkWell(
                                onTap: () {
                                  controllerMessage
                                      .PickfileFromGalary();
                                },
                                child: SvgPicture.asset(
                                  width: width * 0.1,

                                  'assets/svg/ci_file-add.svg', // Ensure you have this SVG file in your assets directory
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  )),
              Flexible(flex:0,
                child:  Container(
                width: width,
                child: GetBuilder(
                    init: ChatMainController(),
                    builder: (controller){
                      return controller.myVideo == null
                          ? Container():
                      Container(
                        child: Row(
                          children: [
                            Expanded(
                              child: controller.videoPlayerController!
                                  .value.isInitialized
                                  ? Container(
                                margin: EdgeInsets.all(10),
                                height: 100,
                                child: AspectRatio(
                                  aspectRatio: controller
                                      .videoPlayerController!
                                      .value
                                      .aspectRatio,
                                  child: VideoPlayer(controller
                                      .videoPlayerController!),
                                ),
                              )
                                  : CircularProgressIndicator(),
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.red,
                              child: IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  controller.ClearVideo();
                                },
                              ),
                            ),
                            controller.VideoSendded
                                ? CircularProgressIndicator()
                                : Expanded(
                                child: IconButton(
                                    onPressed: () {
                                      controller.SendVideo(
                                          context,controller.userid);
                                    },
                                    icon: Icon(
                                      Icons.send,
                                      color: Colors.white,
                                    ))),
                          ],
                        ),
                      );
                    }
                ),
              ),),
              Flexible(
                flex: 0,
                child: Container(
                  width: width,

                  child: GetBuilder(
                      init: ChatMainController(),
                      builder: (controller) {
                        return controller.myfile == null
                            ? Container():Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Image.file(
                                    controller.myfile!,
                                    width: 100,
                                    height: 100,
                                  ),
                                  Positioned(
                                    top: -20,
                                    right: -20,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.red,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.clear,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          controller.ClearPhoto();
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              InkWell(
                                borderRadius:
                                BorderRadius.circular(100),
                                onTap: () {
                                  controller.SendPhoto(context,controller.userid);
                                },
                                child: Icon(
                                  Icons.send,
                                  color: Colors.white,
                                  // size: 40,
                                ),
                              )
                            ],
                          ),
                        );
                      }
                  ),
                ),
              ),
              Flexible(
                flex: 0,
                child: Container(
                  width: width,
                  child:  GetBuilder(
                      init: ChatMainController(),
                      builder: (controllerrecord) {
                        return controllerrecord.audioPath != ''
                            ? Row(
                          children: [
                            Expanded(
                                child: IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    controllerrecord.ClearRecorder();
                                  },
                                )),
                            Expanded(
                                child: Slider(
                                  value: controllerrecord.currentPosition,
                                  max: controllerrecord.totalDuration,
                                  onChanged: (value) {
                                    controllerrecord.onChnagerecordr(value);
                                    controllerrecord.audioPlayer.seek(
                                        Duration(seconds: value.toInt()));
                                  },
                                )),
                            Expanded(
                                child: IconButton(
                                  icon: Icon((Icons.play_circle)),
                                  onPressed: () {
                                    controllerrecord.playRecorder();
                                  },
                                )),
                            controllerrecord.RecordSended
                                ? Expanded(
                                child: CircularProgressIndicator())
                                : Expanded(
                                child: IconButton(
                                    onPressed: () {
                                      controllerrecord.SendRecord(context,controllerrecord.userid);
                                    },
                                    icon: Icon(
                                      Icons.send,
                                      color: Colors.white,
                                    ))),
                          ],
                        )
                            : Container();
                      }),

                ),
              ),
              Flexible(
                flex: 0,
                child: Container(
                  width: width,
                  child: GetBuilder(
                      init: ChatMainController(),
                      builder: (controller){
                        return controller.filePath == ""
                            ? Container():Container(
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.clear,
                                        color: Colors.red,
                                      ))),
                              Expanded(
                                  child: Text(
                                      'Selected file: ${controller.filePath}')),
                              controller.FileSendded? Expanded(child: CircularProgressIndicator()):Expanded(
                                  child: IconButton(
                                      onPressed: () {
                                        controller.SendFile(context,controller.userid);
                                      },
                                      icon: Icon(
                                        Icons.send,
                                        color: Colors.white,
                                      ))),
                            ],
                          ),
                        );
                      }
                  ),

                ),
              ),
              Flexible(
                flex: 2,
                child: GetBuilder(
                    init: ChatMainController(),
                    builder: (controller) {
                      return Column(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(25),
                                        topLeft: Radius.circular(25))),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        // Content that takes the rest of the screen
                                        padding: EdgeInsets.all(10),
                                        child: controller.isLoading
                                            ? Center(
                                                child: Text("Main Content"))
                                            : ListView.builder(
                                                shrinkWrap: true,
                                                itemCount:
                                                    controller.messages.length,
                                                reverse: true,
                                                itemBuilder: (context, index) {
                                                  return Column(
                                                    crossAxisAlignment:
                                                        controller
                                                                    .messages[
                                                                        index]
                                                                    .senderId ==
                                                                controller
                                                                    .userid
                                                            ? CrossAxisAlignment
                                                                .start
                                                            : CrossAxisAlignment
                                                                .end,
                                                    children: [
                                                      CircleAvatar(
                                                        backgroundColor: controller
                                                                    .messages[
                                                                        index]
                                                                    .senderId ==
                                                                controller
                                                                    .userid
                                                            ? kPrimaryColor
                                                            : kTheryColor,
                                                        child:
                                                            Icon(Icons.person),
                                                      ),

                                                      // Text("${controller.messages[index].type}"),
                                                      ChatOperator(
                                                          type: controller.messages[index].type == null?"message":controller.messages[index].type!,
                                                          message:
                                                              ContainerChatMessage(
                                                              isSender: controller
                                                                      .messages[
                                                                          index]
                                                                      .senderId ==
                                                                  controller
                                                                      .userid,
                                                              isReciver: controller
                                                                      .messages[
                                                                          index]
                                                                      .senderId !=
                                                                  controller
                                                                      .userid,
                                                              msgtxt: controller
                                                                      .messages[
                                                                          index]
                                                                      .message ??
                                                                  ''),
                                                          image:
                                                              ContainerChatImage(
                                                            imgSrc: controller
                                                                .messages[index]
                                                                .path??"",
                                                            onTap: () {
                                                              controller.openFile(
                                                                  controller
                                                                      .messages[
                                                                          index]
                                                                      .path!);
                                                            },
                                                          ),
                                                          sheet:
                                                              ContainerSheetView(
                                                            onTap: () {
                                                              controller.openFile(
                                                                  controller
                                                                      .messages[
                                                                          index]
                                                                      .path!);
                                                            },
                                                            pathname: controller
                                                                .messages[index]
                                                                .path??"",
                                                          ),
                                                          location:
                                                              ContainerLocationChat(
                                                            mapUrl: controller
                                                                    .messages[
                                                                        index]
                                                                    .locationLink ??
                                                                "",
                                                            onTap: () {
                                                              controller.openFile(
                                                                  controller
                                                                      .messages[
                                                                          index]
                                                                      .locationLink);
                                                            },
                                                          ),
                                                          video:
                                                              ContainerVideoChat(
                                                              path: controller
                                                                      .messages[index]
                                                                      .path??
                                                                  ""),
                                                        voice: ContainerVoiceChat(widget: Expanded(
                                                          child: IconButton(
                                                              onPressed:
                                                                  () {
                                                                controller.boolList[index]
                                                                    ? controller.StopReecoreder(controller
                                                                    .messages[index]
                                                                    .path??"",
                                                                    index)
                                                                    : controller.playRecorderReciver(controller
                                                                    .messages[index]
                                                                    .path??"", index);
                                                              },
                                                              icon: controller.boolList[
                                                              index]
                                                                  ? Icon(Icons
                                                                  .pause)
                                                                  : Icon(
                                                                  Icons.play_arrow_sharp)),
                                                        ),
                                                            ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                          left: controller
                                                                      .messages[
                                                                          index]
                                                                      .senderId ==
                                                                  controller
                                                                      .userid
                                                              ? 30
                                                              : 0,
                                                          right: controller
                                                                      .messages[
                                                                          index]
                                                                      .senderId ==
                                                                  controller
                                                                      .userid
                                                              ? 0
                                                              : 30,
                                                        ),
                                                        child: Text(
                                                          controller
                                                                  .messages[
                                                                      index]
                                                                  .time ??
                                                              '',
                                                          textScaleFactor:
                                                              ScaleSize
                                                                  .textScaleFactor(
                                                                      context),
                                                        ),
                                                      )
                                                    ],
                                                  );
                                                }),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: EditableTextWidget(
                                            tec: controller.msgTEC,
                                            hintText: "Enter a message",
                                            onChanged: (change) {
                                              controller.onChanged(change);
                                            },
                                          )),
                                          IconButton(
                                            icon: Icon(Icons.send),
                                            onPressed: controller.isTyped
                                                ? () {
                                                    controller.sendMessage(
                                                        controller.msgTEC.text,
                                                        controller.userid
                                                            .toString());
                                                    controller.msgTEC.clear();
                                                  }
                                                : null,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      );
                    }),
              )
            ],
          ),
        ),
      ],
    );
  }
}
