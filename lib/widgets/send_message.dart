import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SendMessage extends StatelessWidget {
  const SendMessage({
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
        const Spacer(),
        Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.only(
              topLeft: radius,
              topRight: radius,
              bottomRight: Radius.zero,
              bottomLeft: radius,
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
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.mark_chat_unread_outlined,
                size: 10,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
