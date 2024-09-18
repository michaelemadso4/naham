import 'package:flutter/material.dart';
import 'package:naham/helper/colors/colorsconstant.dart';

class EditableTextWidget extends StatelessWidget {
  final TextEditingController tec;
  final String hintText;
  final onChanged;
  EditableTextWidget({required this.tec,required this.hintText,this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: k5thColor,

        borderRadius: BorderRadius.circular(30)
      ),
      padding: EdgeInsets.only(left: 20),
      child: TextField(
        controller: tec,
        onChanged:onChanged ,
        decoration: InputDecoration(
            border: InputBorder.none,
          hintText:hintText
        ),

      ),
    );
  }
}