import 'package:flutter/material.dart';

class TextFieldContiner extends StatelessWidget {
  final Widget child;
  final Color primaryColor;
  const TextFieldContiner({
    Key? key,
    required this.child,
    required this.primaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: child,
    );
  }
}
