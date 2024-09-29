import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:naham/feutcher/Contacts/view/widgets/containerChat/containerChatMessage.dart';
import 'package:naham/feutcher/Groups/controller/group_Chat/group_chat_controller.dart';
import 'package:naham/feutcher/Groups/model/groupinfomodel.dart';
import 'package:naham/feutcher/Groups/view/widgets/Edt/EDT.dart';
import 'package:naham/feutcher/Groups/view/widgets/appbargroup/App_Bar_Group.dart';
import 'package:naham/feutcher/Groups/view/widgets/backgroungGroup/BackGround_Group.dart';
import 'package:naham/helper/ToastMessag/toastmessag.dart';
import 'package:naham/helper/scalesize.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../helper/colors/colorsconstant.dart';

class Groupchat extends StatelessWidget {
  const Groupchat({super.key});

  @override
  Widget build(BuildContext context) {
    var size, height, width;
    size = MediaQuery
        .of(context)
        .size;
    height = size.height;
    width = size.width;
    return Stack(
      children: [
        BackgroundGroup(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(child: Container(width: double.infinity,
          child: Column(
            children: [
              GetBuilder(
                init: GroupChatController(),
                builder: (controller) {
                  return FutureBuilder(future: controller.GetGroupInfo(), builder: (context,snapShot){
                    if(snapShot.connectionState == ConnectionState.waiting){
                      return Container(child:Center(
                        child: AnimatedSmoothIndicator(
                          activeIndex: 1,
                          count: 4,
                          effect: WormEffect(),
                        ),
                      ) ,);
                    }else if(snapShot.hasData){
                      GroupInfoModel groupInfoModel= GroupInfoModel();
                      groupInfoModel = GroupInfoModel.fromJson(snapShot.data);
                      return AppBarGroup(apptitle: "${groupInfoModel.data!.name}", isonline:groupInfoModel.data!.onlineUsersCount! , member: groupInfoModel.data!.usersCount!);
                    }else{
                      return Text("no Data");
                    }
                  });
                }
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10,right: 10,bottom: 10),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: kTheryColor,
                          child: InkWell(onTap: () {
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
                        Text('Camera', textScaleFactor:
                        ScaleSize.textScaleFactor(
                            context),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10,right: 10,bottom: 10),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: kTheryColor,
                          child: InkWell(onTap: () {

                          },
                            child:  SvgPicture.asset(
                              'assets/svg/ep_location.svg', // Ensure you have this SVG file in your assets directory
                            ),
                          ),
                        ),
                        Text(
                          'Location', textScaleFactor:
                        ScaleSize.textScaleFactor(
                            context),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10,right: 10,bottom: 10),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,

                          backgroundColor: kTheryColor,
                          child: InkWell(onTap: () {

                          },
                            child: Icon(Icons.mic_none,size: 40,),
                          ),
                        ),
                        Text('File', textScaleFactor:
                        ScaleSize.textScaleFactor(
                            context),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10,right: 10,bottom: 10),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,

                          backgroundColor: kTheryColor,
                          child: InkWell(onTap: () {

                          },
                            child: SvgPicture.asset(
                              'assets/svg/ci_file-add.svg', // Ensure you have this SVG file in your assets directory
                            ),
                          ),
                        ),
                        Text('File', textScaleFactor:
                        ScaleSize.textScaleFactor(
                            context),

                        ),
                      ],
                    ),
                  ),

                ],
              ),
              Flexible(flex:2, child: Container(

                margin: EdgeInsets.only(top: 20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25)),
                ),
                child: Column(
                  children: [
                    Flexible(
                        flex:2,child:
                      GetBuilder(
                        init: GroupChatController(),
                        builder: (controller) {
                          return ListView.builder(
                              itemCount: controller.allMessage.length,
                              reverse: true,
                              itemBuilder: (context,index){
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    ContainerChatMessage(isSender: true, isReciver: false, msgtxt: "${controller.allMessage[index]['message']}"),
                                  ],
                                );
                              });
                        }
                      )
                      ,),
                    Flexible(flex: 0,child: GetBuilder(
                        init:GroupChatController(),
                        builder: (controller) {
                          return EdtGroup(tec: controller.messageTec , hintText: "Write your message",
                            onPressed: (){
                            controller.SendMessage();
                            },
                          );
                        }
                    ))
                  ],
                ),
              ))
            ],
          ),

          )),
        ),
      ],
    );
  }
}
