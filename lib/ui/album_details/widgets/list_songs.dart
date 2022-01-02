import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/models/album.dart';
import 'package:music_app/riverpod/providers.dart';
import 'package:music_app/ui/album_details/widgets/album_song.dart';

class ListAlbumSongs extends ConsumerWidget {
  const ListAlbumSongs({Key? key, required this.album}) : super(key: key);
  final Album album;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<MediaItem> songs = ref.watch(songsProvider).where((item) => item.album == album.title).toList();
    return Expanded(
      child: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: songs.length,
        itemBuilder: (context, index) {
          return AlbumSong(song: songs[index]);
        },
        separatorBuilder: (context, index) => const SizedBox(height: 10),
      ),
    );
  }
}
