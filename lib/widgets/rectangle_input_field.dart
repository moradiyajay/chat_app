import 'package:chat_app/components/text_field_container.dart';
import 'package:flutter/material.dart';

class RectangleInputField extends StatelessWidget {
  final String hintText;
  final Color secondaryColor;
  final Color primaryColor;
  final IconData icon;
  final Function onSaved;
  final TextInputAction textInputAction;

  const RectangleInputField({
    Key? key,
    required this.hintText,
    required this.primaryColor,
    required this.secondaryColor,
    required this.icon,
    required this.onSaved,
    this.textInputAction = TextInputAction.next,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContiner(
      primaryColor: primaryColor,
      child: TextFormField(
        autocorrect: false,
        enableSuggestions: false,
        cursorColor: secondaryColor,
        textCapitalization: TextCapitalization.none,
        keyboardType: TextInputType.emailAddress,
        onSaved: (value) => onSaved(value),
        style: TextStyle(color: secondaryColor),
        textInputAction: textInputAction,
        validator: (value) {
          const pattern = r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
          final regExp = RegExp(pattern);

          if (!regExp.hasMatch(value!)) {
            return 'Enter a valid mail';
          } else {
            return null;
          }
        },
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
