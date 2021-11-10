// ignore_for_file: must_be_immutable

import 'package:chat_app/screens/chat_room_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SendMessage extends StatelessWidget {
  MessageType messageType;
  bool isMe;

  TextStyle messageStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  SendMessage({
    Key? key,
    required this.ds,
    required this.isMe,
    required this.messageType,
  }) : super(key: key);

  final DocumentSnapshot<Object?> ds;
  final Radius radius = const Radius.circular(10);

  @override
  Widget build(BuildContext context) {
    Timestamp ts = ds['ts'];
    String message = ds['message'];
    String imageUrl = ds['fileUrl'];
    DateTime dateTime = ts.toDate();
    EdgeInsets padding = messageType != MessageType.Text
        ? const EdgeInsets.symmetric(horizontal: 5, vertical: 5)
        : const EdgeInsets.symmetric(horizontal: 16, vertical: 8);

    Widget messageLayout() {
      switch (messageType) {
        case MessageType.Text:
          return TextMessage(
            message: message,
            textColor: isMe ? Colors.white : Colors.black,
            dateTime: dateTime,
          );
        case MessageType.Image:
          return ImageMessage(
            imageUrl: imageUrl,
            message: message,
            textColor: isMe ? Colors.white : Colors.black,
            dateTime: dateTime,
          );
        default:
          return TextMessage(
            message: message,
            textColor: isMe ? Colors.white : Colors.black,
            dateTime: dateTime,
          );
      }
    }

    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          padding: padding,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          decoration: BoxDecoration(
            color: isMe
                ? Theme.of(context).primaryColor.withOpacity(0.8)
                : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: radius,
              topRight: radius,
              bottomRight: isMe ? Radius.zero : radius,
              bottomLeft: isMe ? radius : Radius.zero,
            ),
            boxShadow: const [
              BoxShadow(
                blurRadius: 5,
                color: Colors.black12,
              ),
            ],
          ),
          // alignment: Alignment.centerRight,
          child: messageLayout(),
        ),
      ],
    );
  }
}

class TextMessage extends StatelessWidget {
  const TextMessage({
    Key? key,
    required this.message,
    required this.textColor,
    required this.dateTime,
  }) : super(key: key);

  final String message;
  final Color textColor;
  final DateTime dateTime;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          constraints: const BoxConstraints(
            maxWidth: 140,
          ),
          child: Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          DateFormat('hh:mm aa').format(dateTime),
          style: TextStyle(
            fontSize: 11,
            color: textColor,
          ),
        ),
        const SizedBox(width: 4),
        Icon(
          Icons.check,
          size: 12,
          color: textColor,
        ),
      ],
    );
  }
}

class ImageMessage extends StatelessWidget {
  const ImageMessage({
    Key? key,
    required this.imageUrl,
    required this.message,
    required this.textColor,
    required this.dateTime,
  }) : super(key: key);

  final String imageUrl;
  final String message;
  final Color textColor;
  final DateTime dateTime;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        Container(
          constraints: const BoxConstraints(
            minWidth: 150,
            maxWidth: 250,
            minHeight: 100,
            maxHeight: 250,
          ),
          padding: EdgeInsets.only(bottom: message.isEmpty ? 16 : 34),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              imageUrl,
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
            ),
          ),
        ),
        const SizedBox(height: 5),
        if (message.isNotEmpty)
          Positioned(
            left: 0,
            bottom: 11,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                message,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textWidthBasis: TextWidthBasis.longestLine,
                style: TextStyle(
                  fontSize: 16,
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        Positioned(
          bottom: 0,
          right: 8,
          child: Row(
            children: [
              Text(
                DateFormat('hh:mm aa').format(dateTime),
                style: TextStyle(fontSize: 11, color: textColor),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.check,
                size: 12,
                color: textColor,
              ),
            ],
          ),
        )
      ],
    );
  }
}
