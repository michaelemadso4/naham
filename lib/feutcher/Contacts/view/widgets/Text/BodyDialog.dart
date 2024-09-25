import 'package:flutter/material.dart';

import '../../../../../helper/scalesize.dart';
class BodyDialog extends StatelessWidget {
  final String data;
  const BodyDialog({super.key,required this.data});

  @override
  Widget build(BuildContext context) {
    return Text(data,
      style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 25,
        color: Colors.black,
      ),

      textScaleFactor:
      ScaleSize.textScaleFactor(
          context),
    );
  }
}
