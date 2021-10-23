// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:chat_app/components/text_field_container.dart';
import 'package:flutter/material.dart';

class RectangleInputField extends StatelessWidget {
  final String hintText;
  final Color secondaryColor;
  final Color primaryColor;
  final IconData icon;
  RectangleInputField({
    Key? key,
    required this.hintText,
    required this.primaryColor,
    required this.secondaryColor,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContiner(
      primaryColor: primaryColor,
      child: TextField(
        cursorColor: secondaryColor,
        style: TextStyle(color: secondaryColor),
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: secondaryColor,
          ),
          fillColor: secondaryColor,
          hintText: hintText,
          hintStyle: TextStyle(color: secondaryColor),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
