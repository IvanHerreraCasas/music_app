import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/riverpod/providers.dart';
import 'package:music_app/ui/home/widgets/widgets.dart';
import 'package:music_app/ui/queue_player/queue_player.dart';

class SongsPage extends ConsumerWidget {
  const SongsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songs = ref.watch(songsProvider);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: songs.length,
      itemExtent: 65,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () async {
            await ref.watch(audioPlayerProvider.notifier).startPlayList(songs, index);
            Navigator.push(context, MaterialPageRoute(builder: (context) => const QueuePlayerScreen()));
          },
          child: SongWidget(song: songs[index]),
        );
      },
    );
  }
}
