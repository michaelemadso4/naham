import 'package:flutter/material.dart';

import '../../../../../helper/scalesize.dart';
class Body2txt extends StatelessWidget {
  final String data;
  const Body2txt({super.key,required this.data});

  @override
  Widget build(BuildContext context) {
    return Text(data,
      style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 20,
        color: Colors.white,
      ),

      textScaleFactor:
      ScaleSize.textScaleFactor(
          context),
    );
  }
}
