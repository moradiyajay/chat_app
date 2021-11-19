import 'package:chat_app/components/text_field_container.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RectanglePasswordField extends StatefulWidget {
  final String hintText;
  final Color secondaryColor;
  final Color primaryColor;
  final IconData icon;
  final Function onSaved;
  final TextInputAction textInputAction;
  TextEditingController? controller;
  TextEditingController? confirmController;

  RectanglePasswordField({
    Key? key,
    required this.hintText,
    required this.primaryColor,
    required this.secondaryColor,
    required this.icon,
    required this.onSaved,
    this.textInputAction = TextInputAction.done,
    this.controller,
    this.confirmController,
  }) : super(key: key);

  @override
  State<RectanglePasswordField> createState() => _RectanglePasswordFieldState();
}

class _RectanglePasswordFieldState extends State<RectanglePasswordField> {
  bool secureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFieldContiner(
      primaryColor: widget.primaryColor,
      child: TextFormField(
        autocorrect: false,
        enableSuggestions: false,
        cursorColor: widget.secondaryColor,
        obscureText: secureText,
        textCapitalization: TextCapitalization.none,
        controller: widget.controller,
        style: TextStyle(color: widget.secondaryColor),
        textInputAction: widget.textInputAction,
        onSaved: (value) => widget.onSaved(value),
        validator: (value) {
          if (value!.isEmpty || value.length < 8) {
            return 'Password must be at least 8 characters long.';
          } else if (widget.confirmController != null &&
              widget.confirmController!.text != value) {
            return 'Password must be same';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          icon: Icon(
            widget.icon,
            color: widget.secondaryColor,
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                secureText = !secureText;
              });
            },
            child: Icon(
              secureText ? Icons.visibility : Icons.visibility_off,
              color: widget.secondaryColor,
            ),
          ),
          fillColor: widget.secondaryColor,
          hintText: widget.hintText,
          hintStyle: TextStyle(color: widget.secondaryColor),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
