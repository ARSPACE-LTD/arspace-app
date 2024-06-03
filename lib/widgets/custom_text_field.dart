import 'package:flutter/material.dart';

import '../util/theme.dart';

class CustomTextField extends StatelessWidget {
  //final String title;
  final String? hintText;
  final TextStyle? hintStyle;
  final TextEditingController? controller;
  final bool obscureText;
  final Color? backgroundColor;
  final int? minLines; // Set this
  final int? maxLines;
  final int? maxLength;
  final bool readOnly;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final FocusNode? focusNode;
  final VoidCallback? ontap;

  const CustomTextField({
    Key? key,
    //  required this.title,
    this.ontap,
    this.hintText,
    this.hintStyle ,
    this.controller,
    this.obscureText = false,
    this.backgroundColor ,
    this.onChanged,
    this.keyboardType,
    this.validator,
    this.suffixIcon,
    this.prefixIcon,
    this.focusNode,
    this.minLines,
    this.maxLength,
    this.maxLines,
    this.readOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /*    Text(
          title,
          style:  TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            fontFamily: 'Circular Std',
            fontStyle: FontStyle.normal,
            color: ThemeProvider.secondary
          ),
        ),*/
        TextFormField(
          onTap: ontap,
          focusNode: focusNode,
          controller: controller,
          obscureText: obscureText,
          onChanged: onChanged,
          keyboardType: keyboardType,
          validator: validator,
          readOnly: readOnly,
          minLines: minLines,
          maxLines: maxLines,
          maxLength: maxLength,

          style: TextStyle(color:backgroundColor== ThemeProvider.whiteColor ? ThemeProvider.text_background : ThemeProvider.whiteColor,),

          decoration: InputDecoration(
            filled: true,
            fillColor: backgroundColor,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: ThemeProvider.primary,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15,
            ),
            hintText: hintText,

            hintStyle: TextStyle(
              fontSize: 18,
              color:backgroundColor== ThemeProvider.whiteColor ? Color(0xFFA7A9B1) : ThemeProvider.greyColor,
              fontFamily: 'Intern',
            ),
          ),

        ),
      ],
    );
  }
}
