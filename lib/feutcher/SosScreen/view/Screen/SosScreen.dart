import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naham/feutcher/SosScreen/view/widgets/LongPressRippleButton.dart';
import 'package:naham/helper/colors/colorsconstant.dart';
import 'package:naham/helper/scalesize.dart';
class SOSScreen extends StatelessWidget {
  const SOSScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size, height, width;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(25)
            ),
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(top: 30,
            left: 10,right: 10
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Image.asset('assets/images/logo.webp',width:width*0.1 ,),
                Text('SOS', textScaleFactor:
                ScaleSize.textScaleFactor(
                    context),),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(45),
                  color: Colors.white.withOpacity(0.3,),
                ),
                child: Icon(Icons.person),
                ),
            ],),
          ),
          SizedBox(height: 80,),

          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Emergency',
                style: TextStyle(
                  fontSize: 35
                ),
                textScaleFactor:
                ScaleSize.textScaleFactor(
                    context),
              ),

              SizedBox(height: 60,),
              // Longpressripplebutton(),
              InkWell(
                borderRadius: BorderRadius.circular(60),
                onLongPress: (){print("obke");},
                child: Container(
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
                      color: Colors.white,
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
                    child: Icon(Icons.mic_none,color: Colors.red,
                    size: 50,
                    ),
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CircleAvatar(
                      radius: 40,

                      backgroundColor: kTheryColor,
                      child: InkWell(onTap: (){

                      },
                      child: SvgPicture.asset(
                        'assets/svg/camera.svg', // Ensure you have this SVG file in your assets directory
                      ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: kTheryColor,
                      child: InkWell(onTap: (){

                      },
                      child: SvgPicture.asset(
                        'assets/svg/ep_location.svg', // Ensure you have this SVG file in your assets directory
                      ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 40,

                      backgroundColor: kTheryColor,
                      child: InkWell(onTap: (){

                      },
                      child: SvgPicture.asset(
                        'assets/svg/ci_file-add.svg', // Ensure you have this SVG file in your assets directory
                      ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
