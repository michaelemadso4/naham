import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naham/feutcher/Contacts/controller/ContactController.dart';
import 'package:naham/feutcher/Contacts/model/contactmodel.dart';
import 'package:naham/feutcher/Contacts/view/screen/CallScreen/videoCall/vidocallScreen.dart';
import 'package:naham/feutcher/Contacts/view/screen/chatcontactScreen.dart';
import 'package:naham/feutcher/Contacts/view/widgets/contactContainer.dart';
import 'package:naham/helper/colors/colorsconstant.dart';
import 'package:naham/helper/scalesize.dart';
import 'package:naham/helper/sherdprefrence/shardprefKeyConst.dart';
import 'package:naham/helper/sherdprefrence/sharedprefrenc.dart';

import '../../controller/chatMainScreen/chatCallController.dart';
import 'CallScreen/CallScreen.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size, height, width;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25)),
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(top: 30, left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/images/logo.webp',
                  width: width * 0.1,
                ),
                Text(
                  'Contacts',
                  textScaleFactor: ScaleSize.textScaleFactor(context),
                ),
                GetBuilder(
                    init: Contactcontroller(context: context),
                    builder: (controller) {
                      return GestureDetector(
                        onLongPress: () {
                          controller.LogOut();
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(45),
                            color: Colors.white.withOpacity(
                              0.3,
                            ),
                          ),
                          child: Icon(Icons.person),
                        ),
                      );
                    }),
              ],
            ),
          ),
          Flexible(
            flex: 2,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(35),
                      topLeft: Radius.circular(35))),
              child: GetBuilder(
                  init: Contactcontroller(context: context),
                  builder: (controller) {
                    return FutureBuilder(
                        future: controller.GetGroupUsers(),
                        builder: (context, groupuserSnapshot) {
                          if (groupuserSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (groupuserSnapshot.hasError) {
                            return Center(
                                child:
                                    Text('Error: ${groupuserSnapshot.error}'));
                          } else if (groupuserSnapshot.hasData) {
                            ContactModel contactModel = ContactModel();
                            contactModel =
                                ContactModel.fromJson(groupuserSnapshot.data);
                            return ListView.builder(
                                itemCount: contactModel.data!.length,
                                itemBuilder: (context, index) {
                                  return Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: ContactsContainer(
                                          lschat: '',
                                          usename:
                                              contactModel.data![index].name,
                                          onTap: () {
                                            CacheHelper.saveData(
                                                key: userprofielkey,
                                                value: contactModel
                                                    .data![index].id);
                                            Get.to(() => Chatcontactscreen());
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        flex: 0,
                                        child: GetBuilder(
                                            init: ChatCallController(context),
                                            builder: (controller) {
                                              return CircleAvatar(
                                                backgroundColor: kPrimaryColor,
                                                child: IconButton(
                                                  onPressed: () async {
                                                    await CacheHelper.saveData(
                                                        key: userprofielkey,
                                                        value: contactModel
                                                            .data![index].id);

                                                    controller.SendCall();
                                                    Get.to(() => CallScreen(),
                                                        arguments: {
                                                          "userProfileKey":
                                                              contactModel
                                                                  .data![index]
                                                                  .id
                                                        });
                                                  },
                                                  icon: Icon(
                                                    Icons.call,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              );
                                            }),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: CircleAvatar(
                                          backgroundColor: kPrimaryColor,
                                          child: IconButton(
                                            onPressed: () {
                                              CacheHelper.saveData(
                                                  key: userprofielkey,
                                                  value: contactModel
                                                      .data![index].id);
                                              Get.to(() => CallScreen());
                                            },
                                            icon: Icon(
                                              Icons.messenger,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: GetBuilder(
                                            init: ChatCallController(context),
                                            builder: (controller) {
                                              return CircleAvatar(
                                                backgroundColor: kPrimaryColor,
                                                child: IconButton(
                                                  onPressed: () {
                                                    CacheHelper.saveData(
                                                        key: userprofielkey,
                                                        value: contactModel
                                                            .data![index].id);
                                                    controller.sendVideoCalling();
                                                    Get.to(() =>
                                                        VideoCallScreen());
                                                  },
                                                  icon: Icon(
                                                    Icons.missed_video_call,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              );
                                            }),
                                      )
                                    ],
                                  );
                                });
                          } else {
                            return Center(child: Text('No data'));
                          }
                        });
                  }),
            ),
          )
        ],
      ),
    );
  }
}
