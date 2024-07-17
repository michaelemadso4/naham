import 'package:flutter/material.dart';

class EditableTextWidget extends StatelessWidget {
  final TextEditingController tec;
  final String hintText;

  EditableTextWidget({required this.tec,required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30)
      ),
      padding: EdgeInsets.only(left: 20),
      child: TextField(
        controller: tec,
        decoration: InputDecoration(
            border: InputBorder.none,
            labelText: 'Enter message',
          hintText:hintText
        ),
      ),
    );
  }
}