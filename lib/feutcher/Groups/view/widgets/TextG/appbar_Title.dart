import 'package:flutter/material.dart';

class AppbarTitle extends StatelessWidget {
  final String txt;
  const AppbarTitle({super.key,required this.txt});

  @override
  Widget build(BuildContext context) {
    return Text(txt,
    style: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w900,
    ),
    );
  }
}
