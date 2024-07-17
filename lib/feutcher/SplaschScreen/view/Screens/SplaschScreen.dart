import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naham/helper/colors/colorsconstant.dart';

import '../../controller/SplaschController.dart';

class SplaschScreen extends StatelessWidget {
  const SplaschScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: Splaschcontroller(),
      builder: (controller) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [kPrimaryColor, kSceonderyColor,],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: Image.asset('assets/images/logo.webp'),
          ),
        );
      }
    );
  }
}
