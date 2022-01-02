import 'dart:io';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:music_app/services/extensions.dart';

class SongWidget extends StatelessWidget {
  const SongWidget({Key? key, required this.song}) : super(key: key);

  final MediaItem song;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image(
              fit: BoxFit.cover,
              height: 60,
              width: 60,
              image: (song.artUri != null)
                ? FileImage(
                    File(song.artUri!.path),                    
                  )
                : const AssetImage(
                    'assets/default_music.png',
                  ) as ImageProvider,
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song.album ?? '',
                  style: Theme.of(context).textTheme.headline4,
                  maxLines: 1,
                ),
                const SizedBox(height: 5),
                Text(
                  song.title,
                  style: Theme.of(context).textTheme.headline3,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            song.duration?.format() ?? '',
            style: Theme.of(context).textTheme.headline4,
          )
        ],
      ),
    );
  }

  
}
