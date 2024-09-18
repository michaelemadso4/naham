import 'package:flutter/material.dart';

class ContainerVoiceChat extends StatelessWidget {
  final Widget widget;
  const ContainerVoiceChat ({super.key,required this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(

      width: 100,
      child:  Row(
        children: [
          Expanded(child: Icon(Icons.voice_chat)),
          widget,

        ],
      ),
    )
    ;
  }
}
