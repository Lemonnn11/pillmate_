import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class BottomIcon extends StatelessWidget {
  final Image image;
  final String label;

  BottomIcon({required this.image, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 26,
          height: 26,
          child: image,
        ),
        SizedBox(
          height: 6,
        ),
        Text(
          label,
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.bold, color:Color(0xff8B8B8B), fontFamily: 'PlexSansThaiRg'),
        ),
      ],
    );
  }
}