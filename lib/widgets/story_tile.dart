import 'package:flutter/material.dart';

class StoryTile extends StatelessWidget {
  final String profileUrl;
  final String name;
  final bool isYou;
  const StoryTile(
      {Key? key,
      required this.profileUrl,
      required this.name,
      this.isYou = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 110,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                minRadius: 33,
                backgroundImage: NetworkImage(
                  profileUrl,
                ),
              ),
              if (isYou)
                Positioned(
                  bottom: 0,
                  right: 10,
                  child: Container(
                    child: const Icon(Icons.add, color: Colors.white),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            isYou ? 'Add Story' : name,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16,
              color: Colors.black.withOpacity(0.75),
            ),
          ),
        ],
      ),
    );
  }
}
