import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:naham/helper/colors/colorsconstant.dart';
import 'package:naham/helper/scalesize.dart';

class ContainerLocationChat extends StatefulWidget {
  final String mapUrl;
  final VoidCallback onTap;

  const ContainerLocationChat({super.key,required this.mapUrl,required this.onTap});

  @override
  State<ContainerLocationChat> createState() => _ContainerLocationChatState();
}

class _ContainerLocationChatState extends State<ContainerLocationChat> {
  LatLng _position = LatLng(0, 0);
  @override
  void initState() {
    super.initState();
    _extractCoordinates(widget.mapUrl);
  }

  void _extractCoordinates(String url) {
    final Uri uri = Uri.parse(url);
    final String? query = uri.queryParameters['query'];

    if (query != null) {
      final List<String> coordinates = query.split(',');
      if (coordinates.length == 2) {
        final double latitude = double.parse(coordinates[0]);
        final double longitude = double.parse(coordinates[1]);
        setState(() {
          _position = LatLng(latitude, longitude);
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    var size, height, width;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: kPrimaryColor
      ),
      child: Column(
        children: [
          Container(
            height: height*0.2,
            child:GoogleMap(
              initialCameraPosition:CameraPosition(
                target: _position,
                zoom: 14.0,
              ),
              markers: {
                Marker(
                  markerId: MarkerId('position'),
                  position: _position,
                )
              },
            ) ,
          ),
          SizedBox(height: 10,),
          GestureDetector(
            onTap: widget.onTap,child: Text("Open location",
            style: TextStyle(
              color: Colors.black,
            ),textScaleFactor:
            ScaleSize.textScaleFactor(
                context),
          ),
          )
        ],
      ),
    );
  }
}
