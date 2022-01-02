import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/riverpod/providers.dart';
import 'package:music_app/ui/queue_player/queue_player.dart';

class CurrentSong extends ConsumerWidget {
  const CurrentSong({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(audioPlayerProvider.select((value) => value.currentSong));
    final playing = ref.watch(audioPlayerProvider.select((value) => value.playing));
    final audioPlayerNotifier = ref.watch(audioPlayerProvider.notifier);

    if (currentSong == null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        height: 80,
        width: double.infinity,
        alignment: Alignment.centerLeft,
        color: Theme.of(context).primaryColor.withOpacity(0.05),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.asset(
            'assets/default_music.png',
            width: 60,
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const QueuePlayerScreen())),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        height: 80,
        width: double.infinity,
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: currentSong.artUri == null
                  ? Image.asset(
                      'assets/default_music.png',
                      width: 60,
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      File(currentSong.artUri!.path),
                      width: 60,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentSong.title,
                    style: Theme.of(context).textTheme.headline3,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    currentSong.artist ?? '',
                    style: Theme.of(context).textTheme.headline4,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => audioPlayerNotifier.skipToPrevious(),
                    child: const Icon(Icons.skip_previous_outlined, size: 30),
                  ),
                  GestureDetector(
                    onTap: () => audioPlayerNotifier.playPause(),
                    child: Icon(playing ? Icons.pause_outlined : Icons.play_arrow, size: 30)
                  ),
                  GestureDetector(
                    onTap: () => audioPlayerNotifier.skipToNext(),
                    child: const Icon(Icons.skip_next_outlined, size: 30),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
