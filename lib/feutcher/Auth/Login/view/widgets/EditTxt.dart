import 'package:flutter/material.dart';
import 'package:naham/helper/colors/colorsconstant.dart';
import 'package:naham/helper/scalesize.dart';

class EditTextLogin extends StatelessWidget {
  final title;
  final tec;
  final hinttext;
  final obscureText;
  final validvalu;
  const EditTextLogin({super.key,required this.obscureText, required this.title,required this.tec,required this.hinttext,required this.validvalu});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.all(10),
            child: Text(title,
              textScaleFactor: ScaleSize.textScaleFactor(context),
              style: TextStyle(color: Colors.black,fontWeight: FontWeight.w900),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 20,top: 5,bottom: 5),
            decoration: BoxDecoration(
              color: k5thColor,
              borderRadius: BorderRadius.circular(10)
            ),
            child:
            TextFormField(
              controller: tec,
              style: TextStyle(color: Colors.grey,),
              obscureText: obscureText,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hinttext,
                hintStyle: TextStyle(color: Colors.grey),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(25)
                ),
                errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(25)

              ),
              ),
              validator: (value){
                if(value== null||value.isEmpty){
                  return "$validvalu";
                }return null;
              },
            ),
          )
        ],
      ),
    );
  }
}
