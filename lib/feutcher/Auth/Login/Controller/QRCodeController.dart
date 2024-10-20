import 'dart:io';

import 'package:get/get.dart';

class QRCodeController extends GetxController{

  bool isQRShow = false;
  String ipaddress = '';
  Future<String?> getSpecificIpAddress() async {
    try {
      for (var interface in await NetworkInterface.list()) {
        for (var addr in interface.addresses) {
          if (addr.type == InternetAddressType.IPv4 ) {
            return addr.address;  // Return the specific IP address if found
          }
        }
      }
    } catch (e) {
      print("Failed to get IP address: $e");
    }
    return null;  // Return null if the specific IP is not found
  }

  void runAdbTcpip() async {
    try {
      // Attempt to run adb tcpip 5555 command
      var result = await Process.run('adb', ['tcpip', '5555']);
      print(result.stdout); // Output from command
      print(result.stderr); // Any error messages
    } catch (e) {
      print('Error: $e');
    }
  }

  GenerateQRCode()async{
    runAdbTcpip();
    ipaddress = (await getSpecificIpAddress())!;

    isQRShow =true;
    update();
  }
}