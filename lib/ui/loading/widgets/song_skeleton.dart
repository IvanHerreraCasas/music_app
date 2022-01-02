import 'package:flutter/material.dart';
import 'package:music_app/ui/loading/widgets/skeleton.dart';

class SongSkeleton extends StatelessWidget {
  const SongSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Skeleton(height: 60, width: 60),
          const SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Skeleton(height: 15),
                SizedBox(height: 5),
                Skeleton(height: 30),
              ],
            ),
          ),
          const SizedBox(width: 10),
          const Skeleton(height: 25, width: 50),
        ],
      ),
    );
  }
}
