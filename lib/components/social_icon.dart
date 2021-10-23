// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialIcon extends StatelessWidget {
  final String assetName;
  final VoidCallback callback;

  SocialIcon({required this.assetName, Key? key, required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            width: 1,
            color: Theme.of(context).primaryColor.withOpacity(0.35),
          ),
        ),
        child: SvgPicture.asset(
          assetName,
          width: 20,
          height: 20,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
