import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:music_app/services/extensions.dart';

class AlbumSong extends StatelessWidget {
  const AlbumSong({Key? key, required this.song}) : super(key: key);

  final MediaItem song;

  @override
  Widget build(BuildContext context) {

    return Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  song.title,
                  style: Theme.of(context).textTheme.headline3,
                ),
                const SizedBox(height: 10),
                Text(
                  song.artist ?? '',
                  style: Theme.of(context).textTheme.headline4,
                )
              ],
            ),
          ),
          Text(
            song.duration?.format() ?? '',
            style: Theme.of(context).textTheme.headline4,
          )
        ],
      );
  }
}
