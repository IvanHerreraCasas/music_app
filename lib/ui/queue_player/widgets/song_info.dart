import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/riverpod/providers.dart';

class SongInfo extends ConsumerWidget {
  const SongInfo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final song = ref.watch(audioPlayerProvider.select((value) => value.currentSong));

    

    return Column(
      children: [
        Text(
          song?.title ?? '',
          style: Theme.of(context).textTheme.headline1,
        ),
        const SizedBox(height: 20),
        Text(
          song?.album ?? '',
          style: Theme.of(context).textTheme.headline4,
        ),
      ],
    );
  }
}
