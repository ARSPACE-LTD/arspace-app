import 'package:flutter/material.dart';

class HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double radius = 15; // Adjust the radius as needed

    path
      ..moveTo(size.width / 2, 0) // Top center
      ..quadraticBezierTo(size.width / 2 + radius, 0, size.width, size.height / 4) // Top right
      ..lineTo(size.width, size.height * 3 / 4) // Bottom right
      ..quadraticBezierTo(size.width / 2 + radius, size.height, size.width / 2, size.height) // Bottom center
      ..quadraticBezierTo(size.width / 2 - radius, size.height, 0, size.height * 3 / 4) // Bottom left
      ..lineTo(0, size.height / 4) // Top left
      ..quadraticBezierTo(size.width / 2 - radius, 0, size.width / 2, 0) // Top center
      ..close(); // Close the path to form a hexagon with rounded bottom corners

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}