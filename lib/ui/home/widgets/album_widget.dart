import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music_app/models/album.dart';

class AlbumWidget extends StatelessWidget {
  const AlbumWidget({Key? key, required this.album}) : super(key: key);

  final Album album;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: album.path == null
                ? Image.asset(
                    'assets/default_music.png',
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    File(album.path!),
                    fit: BoxFit.cover,
                  ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    album.title,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.headline3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${album.songCount} Song',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
