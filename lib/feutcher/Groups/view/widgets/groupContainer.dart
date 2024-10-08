import 'package:flutter/material.dart';
import 'package:naham/helper/colors/colorsconstant.dart';
import 'package:naham/helper/scalesize.dart';

class Groupcontainer extends StatelessWidget {
  final grouptitle ;
  final sendrmsg;
  final msgtxt;
  final onTap;
  final onPressed;
  const Groupcontainer({super.key,
  required this.grouptitle,
  required this.sendrmsg,
  required this.msgtxt,
  required this.onTap,
    required this.onPressed
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 2,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.all(10),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: kPrimaryColor,
                    child: Icon(Icons.person_outline),
                  ),
                  SizedBox(width: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${grouptitle}',style: TextStyle(color: Colors.black,fontSize:18),
                        textScaleFactor:
                        ScaleSize.textScaleFactor(
                            context),
                      ),
                      Text('${sendrmsg}: ${msgtxt}',style: TextStyle(color: Colors.grey,fontSize:18),
                        textScaleFactor:
                        ScaleSize.textScaleFactor(
                            context),
                      ),
                    ],
                  )
                ],),
            ),
          ),
        ),
        Flexible(

            flex: 0,
            child: IconButton(onPressed: onPressed, icon: CircleAvatar(
    radius: 30
    ,backgroundColor: kPrimaryColor,child: Icon(Icons.chat,color: Colors.white,),)))
      ],
    );
  }
}
