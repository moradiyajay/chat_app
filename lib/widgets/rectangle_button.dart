import 'package:flutter/material.dart';

class RectangleButton extends StatelessWidget {
  final String text;
  final VoidCallback callback;
  final Color backgroundColor;
  const RectangleButton(
      {Key? key,
      required this.text,
      required this.callback,
      required this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      width: double.infinity,
      height: 60,
      child: TextButton(
        onPressed: callback,
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(backgroundColor),
        ),
      ),
    );
  }
}
