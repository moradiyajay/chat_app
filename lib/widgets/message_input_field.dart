import 'package:flutter/material.dart';

class MessageInputField extends StatelessWidget {
  final Function onSendClick;
  final TextEditingController conroller;

  const MessageInputField({
    Key? key,
    required this.onSendClick,
    required this.conroller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.1),
          borderRadius: BorderRadius.circular(25),
        ),
        child: TextField(
          controller: conroller,
          decoration: InputDecoration(
            suffixIcon: GestureDetector(
              onTap: () => onSendClick(conroller.text),
              child: const Icon(
                Icons.send_rounded,
                color: Colors.black45,
              ),
            ),
            hintText: 'Type here',
            hintStyle: const TextStyle(color: Colors.black45),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 24,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
