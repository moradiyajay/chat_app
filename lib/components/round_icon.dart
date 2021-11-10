import 'package:flutter/material.dart';

class RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onClick;
  final Color backgroundColor;

  const RoundIconButton({
    Key? key,
    required this.icon,
    required this.onClick,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        child: Icon(
          icon,
          color: Colors.white,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
          border: Border.all(
            width: 1,
            color: Theme.of(context).primaryColor.withOpacity(0.35),
          ),
        ),
      ),
    );
  }
}
