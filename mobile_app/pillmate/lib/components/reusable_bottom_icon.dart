import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class BottomIcon extends StatelessWidget {
  final Image image;
  final String label;
  final Color fontColor;

  BottomIcon({required this.image, required this.label, required this.fontColor});

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
              fontSize: 12, fontWeight: FontWeight.bold,
              color:fontColor,
              fontFamily: 'PlexSansThaiRg'),
        ),
      ],
    );
  }
}