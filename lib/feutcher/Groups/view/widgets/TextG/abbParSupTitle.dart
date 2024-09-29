import 'package:flutter/material.dart';
class Abbparsuptitle extends StatelessWidget {
  final String txt;

  const Abbparsuptitle({super.key,required this.txt});

  @override
  Widget build(BuildContext context) {
    return Text(txt,
      style: TextStyle(
        fontSize: 18,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
