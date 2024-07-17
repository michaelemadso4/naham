import 'package:flutter/material.dart';
import 'package:naham/helper/colors/colorsconstant.dart';
import 'package:naham/helper/scalesize.dart';

class ContactsContainer extends StatelessWidget {
  final onTap;
  final usename ;
  final lschat;
  const ContactsContainer({super.key,required this.onTap,this.usename,this.lschat});

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
              Text('$usename',style: TextStyle(color: Colors.black,fontSize:18),
                textScaleFactor:
                ScaleSize.textScaleFactor(
                    context),
              ),
              Text('$lschat',style: TextStyle(color: Colors.grey,fontSize:18),
                textScaleFactor:
                ScaleSize.textScaleFactor(
                    context),
              ),
            ],
          )
        ],),
      ),
    );
  }
}
