import 'package:flutter/material.dart';
import 'package:naham/helper/colors/colorsconstant.dart';
import 'package:naham/helper/scalesize.dart';

class Titledialog extends StatelessWidget {
  final String data;
  const Titledialog({super.key,required this.data});

  @override
  Widget build(BuildContext context) {
    return Text(data,
      style: TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 35,
        color: kPrimaryColor,

      ),
      textScaleFactor:
      ScaleSize.textScaleFactor(
          context),
    );
  }
}
