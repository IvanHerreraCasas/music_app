import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/riverpod/providers.dart';

class ControlButtons extends ConsumerWidget {
  const ControlButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioPlayerNotifier = ref.watch(audioPlayerProvider.notifier);

    final shuffleIcon = ref.watch(
      audioPlayerProvider.select(
        (value) {
          switch (value.shuffleMode) {
            case AudioServiceShuffleMode.none:
              return const Icon(
                Icons.shuffle_outlined,
                size: 25,
                color: Colors.black,
              );
            case AudioServiceShuffleMode.all:
              return Icon(
                Icons.shuffle_outlined,
                size: 25,
                color: Theme.of(context).primaryColor,
              );
            case AudioServiceShuffleMode.group:
              throw Error();
          }
        },
      ),
    );

    final repeatIcon = ref.watch(
      audioPlayerProvider.select(
        (value) {
          switch (value.repeatMode) {
            case AudioServiceRepeatMode.none:
              return const Icon(
                Icons.repeat_outlined,
                size: 25,
                color: Colors.black,
              );
            case AudioServiceRepeatMode.one:
              return Icon(
                Icons.repeat_one_outlined,
                size: 25,
                color: Theme.of(context).primaryColor,
              );
            case AudioServiceRepeatMode.all:
              return Icon(
                Icons.repeat_outlined,
                size: 25,
                color: Theme.of(context).primaryColor,
              );
            case AudioServiceRepeatMode.group:
              throw Error();
          }
        },
      ),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => audioPlayerNotifier.changeRepeatMode(),
          child: repeatIcon,
        ),
        const SizedBox(width: 30),
        GestureDetector(
          onTap: () => audioPlayerNotifier.skipToPrevious(),
          child: const Icon(
            Icons.skip_previous,
            size: 25,
          ),
        ),
        const SizedBox(width: 30),
        GestureDetector(
          onTap: () => audioPlayerNotifier.playPause(),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColor,
            ),
            child: Icon(
              ref.watch(audioPlayerProvider.select((value) => value.playing)) ? Icons.pause : Icons.play_arrow,
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 30),
        GestureDetector(
          onTap: () => audioPlayerNotifier.skipToNext(),
          child: const Icon(
            Icons.skip_next,
            size: 25,
          ),
        ),
        const SizedBox(width: 30),
        GestureDetector(
          onTap: () => audioPlayerNotifier.changeShuffleMode(),
          child: shuffleIcon,
        ),
      ],
    );
  }
}
