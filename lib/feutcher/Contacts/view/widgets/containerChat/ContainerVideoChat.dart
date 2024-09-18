import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContainerVideoChat extends StatelessWidget {
  final String path;
  const ContainerVideoChat({super.key,required this.path});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      child:
      InkWell(
        onTap: (){

          Get.toNamed(
              '/videoplayer',
              arguments:
              '$path');
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.network(
              'https://i.pinimg.com/originals/d9/6c/93/d96c9383beb63a6457c96eefc3511379.jpg',
              width: 100,
            ),
            Center(
                child:
                Icon(
                  Icons
                      .play_arrow,
                  color: Colors
                      .white,
                  size: 60,
                )),
          ],
        ),
      ),);
  }
}
