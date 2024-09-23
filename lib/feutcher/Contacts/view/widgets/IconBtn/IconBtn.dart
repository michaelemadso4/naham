import 'package:flutter/material.dart';
import 'package:naham/helper/colors/colorsconstant.dart';
class IconBtn extends StatelessWidget {
  final icon;
  const IconBtn({super.key,required this.icon});

  @override
  Widget build(BuildContext context) {
    return  CircleAvatar(
      radius: 30 ,
      backgroundColor: kTheryColor,
      child: Icon(icon,color: Colors.black,
      size: 35 ,
      ),
    );
  }
}
