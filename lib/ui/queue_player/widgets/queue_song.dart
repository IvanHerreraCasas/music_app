import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/riverpod/providers.dart';

class QueueSong extends ConsumerWidget {
  const QueueSong({Key? key, required this.song, required this.index}) : super(key: key);

  final MediaItem song;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioPlayerNotifier = ref.watch(audioPlayerProvider.notifier);
    final isPlaying = ref.watch(audioPlayerProvider.select((value) => value.queueIndex == index));

    return IgnorePointer(
      ignoring: isPlaying,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          children: [
            isPlaying
                ? Icon(Icons.equalizer_outlined, color: Theme.of(context).primaryColor)
                : const Icon(Icons.drag_handle_outlined),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    song.title,
                    style: Theme.of(context).textTheme.headline3,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${song.artist} | ${song.album}',
                    style: Theme.of(context).textTheme.headline4,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
            const SizedBox(width: 10),
            PopupMenuButton(
              elevation: 5,
              icon: Icon(
                Icons.adaptive.more,
                color: isPlaying ? Colors.grey : Colors.black,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Text(
                    'Remove from queue',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  onTap: () => audioPlayerNotifier.removeQueueItemAt(index),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
