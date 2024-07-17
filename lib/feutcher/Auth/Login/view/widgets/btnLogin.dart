import 'package:flutter/material.dart';
import 'package:naham/helper/colors/colorsconstant.dart';
import 'package:naham/helper/scalesize.dart';
class BTNLogin extends StatelessWidget {
  final txtbtn;
  final onPressed;
  const BTNLogin({super.key, required this.txtbtn,required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor:  kSceonderyColor,
      minimumSize: Size(double.infinity, 45),
      padding: EdgeInsets.symmetric(horizontal: 16,vertical: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
    );
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: ElevatedButton(
        style: raisedButtonStyle,
        onPressed: onPressed,
        child: Text(txtbtn,textScaleFactor: ScaleSize.textScaleFactor(context)),
      ),
    );
  }
}
