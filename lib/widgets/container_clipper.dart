import 'package:flutter/material.dart';

class ContainerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size. height);
    path.lineTo(size.width, 0.0);

    double yOffset = size.height * 0.65;
    path.addOval(Rect.fromCircle(center: Offset(0.0, yOffset), radius: 12.0));
    path.addOval(Rect.fromCircle(center: Offset(size.width, yOffset), radius: 12.0));

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}