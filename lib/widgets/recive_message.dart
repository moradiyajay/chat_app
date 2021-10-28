import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReciveMessage extends StatelessWidget {
  const ReciveMessage({
    Key? key,
    required this.ds,
  }) : super(key: key);

  final DocumentSnapshot<Object?> ds;
  final Radius radius = const Radius.circular(10);

  @override
  Widget build(BuildContext context) {
    Timestamp ts = ds['ts'];
    DateTime dateTime = ts.toDate();
    return Row(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSecondary,
            borderRadius: BorderRadius.only(
              topLeft: radius,
              topRight: radius,
              bottomRight: radius,
              bottomLeft: Radius.zero,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                ds['message'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                DateFormat('hh:mm aa').format(dateTime),
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
