import 'package:flutter/material.dart';

class CustomClipPath extends CustomClipper<Path> {

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0,size.height* 0.4);
    path.quadraticBezierTo(size.width/5, size.height/1.4, size.width, size.height*0.5);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}