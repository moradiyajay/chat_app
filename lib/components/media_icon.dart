import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class MediaIcon extends StatelessWidget {
  final Color backgroundColor;
  final String text;
  final IconData icon;
  final VoidCallback onClick;
  final double padding;
  const MediaIcon({
    Key? key,
    required this.backgroundColor,
    required this.text,
    required this.onClick,
    required this.icon,
    this.padding = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            // margin: const EdgeInsets.symmetric(horizontal: 15),
            padding: EdgeInsets.all(text.isEmpty ? padding : 15),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: backgroundColor.withOpacity(0.1)),
            child: Icon(
              icon,
              color: backgroundColor,
              size: text.isEmpty ? 26 : 24,
            ),
          ),
          if (text != '') ...[
            const SizedBox(height: 10),
            Text(
              text,
              style: const TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ]
        ],
      ),
    );
  }
}
