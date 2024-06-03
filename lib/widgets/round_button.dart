import 'package:arspace/util/theme.dart';
import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final double width;
  final double height;
  final Color borderColor;
  final Widget child;
  final double padding;
  final Color background;

  RoundButton({
    required this.width,
    required this.height,
    this.borderColor = Colors.transparent,
    this.padding = 10.0,
    required this.child,
    this.background = ThemeProvider.blackColor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: background,
        border: Border.all(
          color: borderColor,
        ),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: child,
      ),
    );
  }
}