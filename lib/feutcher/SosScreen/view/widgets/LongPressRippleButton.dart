import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:math' as math show sin, pi, sqrt;
import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:naham/feutcher/SosScreen/controller/longpressController.dart';

class Longpressripplebutton extends StatelessWidget {
  const Longpressripplebutton({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: LongpressController(),
      builder: (controller) {
        return Stack(
          children: controller.listRadus.map((radius)=>Container(
            width: radius * controller.animation.value,
            height: radius*controller.animation.value,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue.withOpacity(1.0 - controller.animation.value)
            ),
          )).toList(),
        );
      }
    );
  }
}

