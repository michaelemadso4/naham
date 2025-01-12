import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naham/feutcher/mainScreen/controller/maincontroller.dart';
import 'package:naham/helper/colors/colorsconstant.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size, height, width;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return GetBuilder(
      init: MainController(
        context: context,
      ) ,
      builder: (controller) {
        return Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [kPrimaryColor, kSceonderyColor,],
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
              body: Center(
                child: controller.widgetOptions.elementAt(controller.selectedIndex),
              ),
              bottomNavigationBar: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Contact',
                  ),
                  // BottomNavigationBarItem(
                  //   icon: Icon(Icons.sos_outlined),
                  //   label: 'SOS',
                  // ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.group),
                    label: 'Group',
                  ),
                ],
                currentIndex: controller.selectedIndex,
                backgroundColor: Colors.black,
                unselectedItemColor: Colors.grey,
                selectedItemColor: Colors.white,
                onTap: controller.onItemTapped,
              ),
            ),
          ],
        );
      }
    );
  }
}
