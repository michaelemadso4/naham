import 'package:flutter/material.dart';
import 'package:naham/helper/colors/colorsconstant.dart';

class EdtGroup extends StatelessWidget {
  final TextEditingController tec;
  final String hintText ;
  final VoidCallback onPressed;

  const EdtGroup({super.key,required this.tec,required this.hintText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),

      child: Row(
        children: [

          Flexible(flex: 2,child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(1.2)
            ),
            child: Container(
              padding: EdgeInsets.only(left: 15,top: 5,bottom: 5,right: 15),
              decoration: BoxDecoration(
                  color: k5thColor,
                borderRadius: BorderRadius.circular(20)
              ),
              child: TextField(
                controller: tec,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText:hintText
                ),),
            ),
          ),
          ),
          Flexible(flex: 0,child: IconButton(
            icon: CircleAvatar(
                backgroundColor: kPrimaryColor,
                child: Icon(Icons.near_me,color: Colors.white,)),
            onPressed: onPressed,
          )),

        ],
      ),
    );
  }
}
