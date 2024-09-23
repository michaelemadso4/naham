import 'package:flutter/material.dart';
import 'package:naham/helper/scalesize.dart';
class Titletxt extends StatelessWidget {
  final String data;
  const Titletxt({super.key,required this.data});

  @override
  Widget build(BuildContext context) {
    return Text(data,
    style: TextStyle(
      fontWeight: FontWeight.w800,
      fontSize: 25,
      color: Colors.white,

    ),
      textScaleFactor:
      ScaleSize.textScaleFactor(
          context),
    );
  }
}
