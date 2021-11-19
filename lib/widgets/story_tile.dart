import 'package:flutter/material.dart';

class StoryTile extends StatelessWidget {
  final String profileUrl;
  final String name;
  final bool isYou;
  final VoidCallback onTap;
  const StoryTile(
      {Key? key,
      required this.profileUrl,
      required this.name,
      required this.onTap,
      this.isYou = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                Container(
                  padding: EdgeInsets.all(isYou ? 0 : 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [
                      Colors.yellow.shade600,
                      Colors.orange.shade400,
                      Colors.red.shade400
                    ]),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: CircleAvatar(
                      minRadius: 28,
                      backgroundImage: NetworkImage(
                        profileUrl,
                      ),
                    ),
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
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 15,
                color: Colors.black.withOpacity(0.75),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StoryTileShimmer extends StatelessWidget {
  final Color color;
  const StoryTileShimmer({
    Key? key,
    required this.color,
  }) : super(key: key);

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
              Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [
                    Colors.yellow.shade600,
                    Colors.orange.shade400,
                    Colors.red.shade400
                  ]),
                ),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                  child: CircleAvatar(
                    minRadius: 28,
                    backgroundColor: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Container(
            width: double.infinity,
            color: color,
          )
        ],
      ),
    );
  }
}
