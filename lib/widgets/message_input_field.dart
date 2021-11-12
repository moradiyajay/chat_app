import 'package:flutter/material.dart';

import 'package:chat_app/components/round_icon.dart';

class MessageInputField extends StatelessWidget {
  final Function onSendClick;
  final VoidCallback onAddClick;
  final TextEditingController conroller;

  const MessageInputField({
    Key? key,
    required this.onSendClick,
    required this.onAddClick,
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
          enableSuggestions: true,
          textCapitalization: TextCapitalization.sentences,
          controller: conroller,
          textInputAction: TextInputAction.done,
          onEditingComplete: () => onSendClick(conroller.text),
          decoration: InputDecoration(
            prefixIcon: GestureDetector(
              onTap: onAddClick,
              child: Container(
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                margin: const EdgeInsets.symmetric(vertical: 11),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor.withOpacity(0.8),
                  border: Border.all(
                    width: 1,
                    color: Theme.of(context).primaryColor.withOpacity(0.35),
                  ),
                ),
              ),
            ),
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
              horizontal: 0,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
