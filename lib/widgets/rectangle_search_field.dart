import 'package:chat_app/components/text_field_container.dart';
import 'package:flutter/material.dart';

class RectangleSearchField extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return TextFieldContiner(
      primaryColor: Theme.of(context).primaryColor,
      child: TextField(
        cursorColor: Colors.white,
        controller: searchController,
        onSubmitted: (value) => onSearchBtnClick(value),
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          fillColor: Colors.white,
          focusColor: Colors.white,
          hintText: 'username',
          border: InputBorder.none,
          prefixIcon: IconButton(
            icon: const Icon(Icons.arrow_back),
            padding: EdgeInsets.zero,
            alignment: Alignment.centerLeft,
            color: Colors.white,
            onPressed: () => onBackBtnClick(),
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.search),
            color: Colors.white,
            onPressed: () => onSearchBtnClick(searchController.text),
          ),
          hintStyle: const TextStyle(
            color: Colors.white70,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
