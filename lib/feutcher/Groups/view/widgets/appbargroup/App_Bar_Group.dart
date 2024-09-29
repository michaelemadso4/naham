import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naham/feutcher/Groups/view/widgets/TextG/abbParSupTitle.dart';
import 'package:naham/feutcher/Groups/view/widgets/TextG/appbar_Title.dart';
class AppBarGroup extends StatelessWidget {
  final String apptitle;
  final int member,isonline;
  const AppBarGroup({super.key,required this.apptitle,required this.isonline,required this.member});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15)
      ),
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Flexible(child: IconButton(icon: Icon(Icons.arrow_back,color: Colors.black,),onPressed: (){
            Get.back();
          },)),
          Flexible(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppbarTitle(txt: "$apptitle"),
              Abbparsuptitle(txt: '$member members, $isonline online')
            ],
          ) )
        ],
      ),
    );
  }
}
