import 'package:flutter/material.dart';

import '../../../../../helper/colors/colorsconstant.dart';
class BackgroundGroup extends StatelessWidget {
  const BackgroundGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [ Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              kTheryColor,
              kPrimaryColor,
              kSceonderyColor,
              kTheryColor,
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
      ),
        Container(
          width: double.infinity,
          height: double.infinity,
          child: Transform.scale(
            scale: 1,
            child: Opacity(
              opacity: 0.1,
              child: Image.asset(
                'assets/images/logo.webp',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
        ),],
    );
  }
}
