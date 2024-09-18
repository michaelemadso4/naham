import 'package:flutter/material.dart';
import 'package:naham/helper/colors/colorsconstant.dart';
import 'package:naham/helper/scalesize.dart';

class ContainerChatMessage extends StatelessWidget {
  final bool isSender,isReciver;
  final String msgtxt;
  const ContainerChatMessage({super.key,required this.isSender,required this.isReciver,required this.msgtxt});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20,top: 10,right: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(25),bottomLeft:Radius.circular(25),
        topLeft: isReciver?Radius.circular(25):Radius.circular(0),
          topRight: isReciver?Radius.circular(0):Radius.circular(20)
        ),
        gradient: LinearGradient(
          colors: isReciver?[kPrimaryColor, kSceonderyColor,]:[kTheryColor,k5thColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Text(msgtxt,
         style: TextStyle(
             color: isReciver?Colors.white:Colors.black,
         ),textScaleFactor:
        ScaleSize.textScaleFactor(
            context),
      ),
    );
  }
}
