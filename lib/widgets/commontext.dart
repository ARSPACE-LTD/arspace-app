import 'package:flutter/cupertino.dart';

class CommonTextWidget extends StatelessWidget {
  final String? heading;
  final String fontFamily;
  final double fontSize;
  final double lineHeight;
  final Color color;
  final double letterSpacing;
  final TextAlign textAlign;
  final TextOverflow textOverflow;
  final FontWeight? fontWeight;
  final TextDecoration textDecoration;
  final FontStyle fontStyle;
  final int? maxLines;


  const CommonTextWidget({
    Key? key,
    this.fontStyle = FontStyle.normal,
    required this.heading,
    this.textDecoration = TextDecoration.none,
    required this.fontFamily,
    required this.fontSize,
    required this.color,
    this.letterSpacing = 0,
    this.lineHeight = 1,
    this.fontWeight,
    this.maxLines,
    this.textAlign = TextAlign.start,
    this.textOverflow = TextOverflow.visible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      heading!,
      textAlign: textAlign,
      overflow: textOverflow,
      maxLines: maxLines,
      style: TextStyle(
          fontStyle: fontStyle,
          decoration: textDecoration,
          fontFamily: fontFamily,
          fontWeight:fontWeight??FontWeight.w600,
          height: lineHeight,
          fontSize: fontSize,
          letterSpacing: letterSpacing,
          color: color),
    );
  }
}
