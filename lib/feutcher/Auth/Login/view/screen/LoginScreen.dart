import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naham/feutcher/Auth/Login/Controller/LoginController.dart';
import 'package:naham/feutcher/Auth/Login/Controller/QRCodeController.dart';
import 'package:naham/feutcher/Auth/Login/view/widgets/EditTxt.dart';
import 'package:naham/feutcher/Auth/Login/view/widgets/btnGenQR.dart';
import 'package:naham/feutcher/Auth/Login/view/widgets/btnLogin.dart';
import 'package:naham/feutcher/mainScreen/view/Screen/mainScreen.dart';
import 'package:naham/helper/colors/colorsconstant.dart';
import 'package:naham/helper/scalesize.dart';
import 'package:qr_flutter/qr_flutter.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size, height, width;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                kPrimaryColor,
                kSceonderyColor,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: double.infinity,
          child: Transform.scale(
            scale: 1,
            child: Opacity(
              opacity: 0.1,
              child: Image.asset(
                'assets/images/logo.webp',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: ListView(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(25)),
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(top: 50, left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            'assets/images/logo.webp',
                            width: width * 0.1,
                          ),
                          Text(
                            'Login',
                            textScaleFactor: ScaleSize.textScaleFactor(context),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(45),
                              color: Colors.white.withOpacity(
                                0.3,
                              ),
                            ),
                            child: Icon(Icons.person),
                          ),
                        ],
                      ),
                    ),
    GetBuilder(
      init:QRCodeController(),
      builder: (controller) {
        return BTNGenQR(
        txtbtn: "Generate QR Code",
        onPressed: () {
        controller.GenerateQRCode();
        },
        );
      }
    ),
                    GetBuilder<QRCodeController>(
                      builder: (controller) {
                        return controller.isQRShow
                            ? Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white),
                              child: QrImageView(
                                data: controller.ipaddress,
                                version: QrVersions.auto,
                                size: 200.0,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Scan  QR Code ${controller.ipaddress}',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        )
                            : SizedBox(height: 100,); // Use SizedBox.shrink() to avoid layout issues
                      },
                    ),
                    Expanded(
                      flex: 2,
                      child: GetBuilder(
                          init: LoginController(context: context),
                          builder: (controller) {
                            return Form(
                              key: controller.formkey,
                              child: Container(
                                  padding: EdgeInsets.all(20),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(35),
                                          topLeft: Radius.circular(35))),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Welcome Back!',
                                        textScaleFactor:
                                        ScaleSize.textScaleFactor(context),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 25),
                                      ),
                                      Text(
                                        '',
                                        textScaleFactor:
                                        ScaleSize.textScaleFactor(context),
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 18),
                                        textAlign: TextAlign.center,
                                      ),
                                      EditTextLogin(
                                        title: 'Email',
                                        tec: controller.EmailTEC,
                                        hinttext: 'Yourmail@mail.com',
                                        validvalu: 'Please Enter Your Email',
                                        obscureText: false,
                                      ),
                                      EditTextLogin(
                                        title: 'Password',
                                        tec: controller.PasswordTEC,
                                        hinttext: '**********',
                                        validvalu: 'Please Enter Your Password',
                                        obscureText: true,
                                      ),

                                      controller.IsLogin?CircularProgressIndicator(): BTNLogin(
                                          txtbtn: 'Sign In',
                                          onPressed: () {
                                            if(controller.formkey.currentState!.validate()){
                                              controller.SignInWebService();
                                            }
                                          }),
                                    ],
                                  )),
                            );
                          }),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
