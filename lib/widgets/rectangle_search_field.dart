import 'package:chat_app/components/text_field_container.dart';
import 'package:flutter/material.dart';

class RectangleSearchField extends StatefulWidget {
  final Function onSearchBtnClick;
  final Function onBackBtnClick;
  // final bool isSearching;
  final TextEditingController searchController;

  const RectangleSearchField({
    Key? key,
    required this.searchController,
    required this.onSearchBtnClick,
    required this.onBackBtnClick,
    // required this.isSearching,
  }) : super(key: key);

  @override
  State<RectangleSearchField> createState() => _RectangleSearchFieldState();
}

class _RectangleSearchFieldState extends State<RectangleSearchField> {
  @override
  Widget build(BuildContext context) {
    return TextFieldContiner(
      primaryColor: Theme.of(context).primaryColor,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            icon: const Icon(Icons.arrow_back),
            padding: EdgeInsets.zero,
            alignment: Alignment.centerLeft,
            color: Colors.white,
            onPressed: () => widget.onBackBtnClick(),
          ),
          Expanded(
            child: TextField(
              cursorColor: Colors.white,
              controller: widget.searchController,
              onSubmitted: (value) => widget.onSearchBtnClick(value),
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                fillColor: Colors.white,
                focusColor: Colors.white,
                hintText: 'username',
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            alignment: Alignment.centerRight,
            icon: const Icon(Icons.search),
            color: Colors.white,
            onPressed: () =>
                widget.onSearchBtnClick(widget.searchController.text),
          )
        ],
      ),
    );
  }
}
