import 'package:flutter/material.dart';

class MicRecordBtn extends StatelessWidget {
  const MicRecordBtn({super.key});

  @override
  Widget build(BuildContext context) {
    var size, height, width;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return InkWell(
      borderRadius: BorderRadius.circular(60),
      onTap: (){print("obke");},

      child: Container(
        margin: EdgeInsets.only(left: 20,right: 20,top: 50,bottom: 30),
        width: width* 0.5,
        height: width * 0.5,
        decoration: BoxDecoration(
          color:Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(1, 3), // changes position of shadow
            ),
          ],
        ),
        child:Container(
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Icon(Icons.mic_none,color: Colors.red,
            size: 50,
          ),
        ),
      ),
    );
  }
}