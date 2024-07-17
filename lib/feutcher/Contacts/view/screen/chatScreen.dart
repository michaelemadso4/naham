import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:naham/feutcher/Contacts/controller/firebaseChatController.dart';
import 'package:naham/feutcher/Contacts/controller/pusherChatController.dart';
import 'package:naham/feutcher/Contacts/controller/userinfoController.dart';
import 'package:naham/feutcher/Contacts/view/widgets/edtchat/edtchat.dart';
import 'package:naham/helper/colors/colorsconstant.dart';
import 'package:naham/helper/scalesize.dart';
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
              colors: [kPrimaryColor, kSceonderyColor,],
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
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(25)
                      ),
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(top: 30,
                          left: 10,right: 10
                      ),
                      child: Row(
                        children: [
                          IconButton(onPressed: (){Get.back();}, icon: Icon(Icons.keyboard_arrow_left_sharp,color: Colors.black,)),
                          FutureBuilder(future:controller.GetUserInfo() ,
                            builder: (context,snapshot) {
                              if(snapshot.connectionState ==ConnectionState.waiting){
                                return Container(
                                  color: Colors.cyanAccent.withOpacity(0.1),
                                  width: width *0.1,
                                  height: height * 0.01,
                                );
                              }else if(snapshot.hasData){
                                UserprofileModel userProfielModel = UserprofileModel();
                                userProfielModel = UserprofileModel.fromJson(snapshot.data);

                                return  Row(
                                  children: [
                                    Text('${userProfielModel.data!.id}', textScaleFactor:
                                    ScaleSize.textScaleFactor(
                                        context),),
                                    SizedBox(width: 5,),
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:  Colors.white
                                      ),
                                      width: 15,
                                      height: 15,
                                      padding: EdgeInsets.all(2),
                                      child: Container(decoration:
                                        BoxDecoration(
                                          color:userProfielModel.data!.isOnline != null ? Colors.green:Colors.red,
                                          shape: BoxShape.circle,
                                        )
                                        ,),
                                    )
                                  ],
                                );
                              }
                              else{
                                return Center(child: Text('No data'));
                              }
                            }
                          ),
                          Spacer(),
                          Row(children: [
                            IconButton(onPressed: (){}, icon: Icon(Icons.call_outlined,color: Colors.black,)),
                            IconButton(onPressed: (){}, icon: SvgPicture.asset(
                              width: width * 0.07,
                              'assets/svg/camera.svg', // Ensure you have this SVG file in your assets directory
                            )),
                          ],)

                        ],),
                    );
                  }
                ),
              ),
              Flexible(child: Container(
                margin: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: kTheryColor,
                      child: InkWell(onTap: (){

                      },
                        child: SvgPicture.asset(
                          width: width*0.06 ,
                          'assets/svg/ep_location.svg', // Ensure you have this SVG file in your assets directory
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: kTheryColor,
                      child: InkWell(onTap: (){

                      },
                        child: Icon(Icons.mic_none_outlined)
                      ),
                    ),
                    CircleAvatar(
                      radius: 25,

                      backgroundColor: kTheryColor,
                      child: InkWell(onTap: (){

                      },
                        child: SvgPicture.asset(
                          width: width*0.06 ,

                          'assets/svg/camera.svg', // Ensure you have this SVG file in your assets directory
                        ),
                      ),
                    ),
                  ],),
              )),
              GetBuilder(
                  init: PusherChatController(),
                  builder: (controller){
                    return  Flexible(
                      child: Column(
                        children: [

                          Expanded(
                            flex:1,
                            child: StreamBuilder(
                              stream: controller.channel.stream.asBroadcastStream() ,
                              builder: (context,snapshot){
                                if(snapshot.hasData){
                                  var data = json.decode(snapshot.data);
                                  print(data);

                                }
                                return SizedBox.shrink();
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: controller.msgTEC,
                                    decoration: InputDecoration(hintText: 'Enter a message'),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.send),
                                  onPressed: () {
                                    controller.sendMessage(controller.msgTEC.text,21);
                                    controller.msgTEC.clear();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  })

            ],
          ),
        ),
      ],
    );
  }
}
