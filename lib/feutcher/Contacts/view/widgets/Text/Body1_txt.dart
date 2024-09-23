import 'package:flutter/material.dart';

import '../../../../../helper/scalesize.dart';
class Body1txt extends StatelessWidget {
  final String data;
  const Body1txt({super.key,required this.data});

  @override
  Widget build(BuildContext context) {
    return Text(data,
      style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16,
        color: Colors.white,
      ),
      textScaleFactor:
      ScaleSize.textScaleFactor(
          context),
      textAlign: TextAlign.center,
    );
  }
}
