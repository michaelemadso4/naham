import 'package:flutter/material.dart';
import 'package:naham/helper/colors/colorsconstant.dart';

class ContainerSheetView extends StatelessWidget {
  final VoidCallback onTap;
  final String pathname;
  const ContainerSheetView({super.key,required this.onTap, required this.pathname});

  @override
  Widget build(BuildContext context) {
    var size, height, width;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(left: 20,top: 10,right: 20),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              borderRadius:BorderRadius.circular(25),
            color: kPrimaryColor,
          ),
          child: Row(
            children: [
              Expanded(flex: 0,child: Image.network("https://i.ibb.co/K2VxkRj/google-docs.png",width:width*0.15 ,height: height*0.1,)),
              Expanded(
                 flex: 2,
                  child: Text(pathname.replaceAll("https://zchat.tadafuq.ae/storage/sheets/",''),style: TextStyle(color: Colors.white),)),
              Expanded(
                  flex: 1,
                  child: Icon(Icons.file_open,color: Colors.white,))
            ],
          ),
        ));
  }
}
