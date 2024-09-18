import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ContainerChatImage extends StatelessWidget {

  final String imgSrc;
  final VoidCallback onTap;
  const ContainerChatImage({super.key,required this.imgSrc,required this.onTap});

  @override
  Widget build(BuildContext context) {
    var size, height, width;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return GestureDetector(
      onTap: onTap,
      onLongPress: (){
        Clipboard.setData(ClipboardData(text: imgSrc));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image link copied to clipboard!',style: TextStyle(color: Colors.black),),backgroundColor: Colors.amberAccent,),
        );
      },
      child: Container(
        margin:EdgeInsets.all(20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Image.network("${imgSrc}",
            width: width*0.8,
            height: width*0.6,
            fit: BoxFit.cover,

          ),
        ),
      ),
    );
  }
}
