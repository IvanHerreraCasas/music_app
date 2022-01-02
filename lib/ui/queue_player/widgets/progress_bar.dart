import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/riverpod/providers.dart';

class AudioProgressBar extends ConsumerWidget {
  const AudioProgressBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch<Duration>(
      audioPlayerProvider.select(
        (value) => value.progress,
      ),
    );

    final total = ref.watch<Duration>(
      audioPlayerProvider.select((value) => value.total),
    );    

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      //TODO: optimize progress bar
      child: ProgressBar(
        progress: progress,
        total: total,
        onSeek: (position) => ref.watch(audioPlayerProvider.notifier).seek(position),
      ),
    );
  }
}
