import 'package:flutter/material.dart';
import 'package:naham/feutcher/Contacts/view/widgets/containerChat/containerChatMessage.dart';

class ChatOperator extends StatelessWidget {
  final String type;

  final Widget message, image,sheet,location,video,voice;

  const ChatOperator({
    super.key,
    required this.type,
    required this.message,
    required this.image,
    required this.sheet,
    required this.location,
    required this.video,
    required this.voice,
  });

  @override
  Widget build(BuildContext context) {
    if (type == "message") {
      return message;
    } else if (type == "image") {
      return image;
    }else if (type == "sheet") {
      return sheet;
    }
    else if (type == "location") {
      return location;
    }else if (type == "video") {
      return video;
    }else if (type == "voice") {
      return voice;
    }

    else {
      return Container();
    }
  }
}
