import 'package:flutter/material.dart';

class MicRecordBtn extends StatelessWidget {
  final VoidCallback onLongPress;
  final onLongPressEnd;
  final bool isPersing, isLoading ;
  const MicRecordBtn({super.key,required this.onLongPress,required this.onLongPressEnd,required this.isLoading, required this.isPersing});

  @override
  Widget build(BuildContext context) {
    var size, height, width;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return GestureDetector(
      onTap: onLongPress,
      // onLongPress: onLongPress,
      // onLongPressEnd:onLongPressEnd ,
      child: Container(
        margin: EdgeInsets.only(left: 20,right: 20,top: 50,bottom: 30),
        width: width* 0.5,
        height: width * 0.5,
        decoration: BoxDecoration(
          color:Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(1, 3), // changes position of shadow
            ),
          ],
        ),
        child:Container(
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isPersing?Colors.green:Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: isLoading?CircularProgressIndicator():Icon(Icons.mic_none,color: Colors.red,
            size: 50,
          ),
        ),
      ),
    );
  }
}
