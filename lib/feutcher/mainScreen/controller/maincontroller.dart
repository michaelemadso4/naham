import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:naham/feutcher/Contacts/view/screen/ContactsScreen.dart';
import 'package:naham/feutcher/Groups/view/screen/groupScreen.dart';
import 'package:naham/feutcher/SosScreen/view/Screen/SosScreen.dart';

class MainController extends GetxController{

  BuildContext context;
  MainController({required this.context});

  int selectedIndex = 0;

  List<Widget> widgetOptions = <Widget>[
    ContactsScreen(),
    SOSScreen(),
    Groupscreen(),
  ];

  void onItemTapped(int index) {
      selectedIndex = index;
    update();
  }

}