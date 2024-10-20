import 'package:flutter/material.dart';
import 'package:naham/helper/colors/colorsconstant.dart';
import 'package:naham/helper/scalesize.dart';
class BTNGenQR extends StatelessWidget {
  final txtbtn;
  final onPressed;
  const BTNGenQR({super.key, required this.txtbtn,required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      foregroundColor: kSceonderyColor,
      backgroundColor: Colors.white ,
      minimumSize: Size(200, 45),
      padding: EdgeInsets.all(20),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
    );
    return Container(
      margin: EdgeInsets.all(20),
      child: ElevatedButton(
        style: raisedButtonStyle,
        onPressed: onPressed,
        child: Text(txtbtn,textScaleFactor: ScaleSize.textScaleFactor(context)),
      ),
    );
  }
}
