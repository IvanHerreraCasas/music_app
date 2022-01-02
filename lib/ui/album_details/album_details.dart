import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/models/album.dart';
import 'package:music_app/riverpod/providers.dart';
import 'package:music_app/ui/album_details/widgets/album_info.dart';
import 'package:music_app/ui/album_details/widgets/list_songs.dart';
import 'package:music_app/ui/widgets/current_song.dart';

class AlbumDetails extends StatelessWidget {
  const AlbumDetails({Key? key, required this.album}) : super(key: key);

  final Album album;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          30,
          MediaQuery.of(context).padding.top + 20,
          30,
          80,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back),
                ),
                Text(
                  'Detail Album',
                  style: Theme.of(context).textTheme.headline2,
                ),
                const Icon(Icons.music_note),
              ],
            ),
            const SizedBox(height: 30),
            AlbumInfo(album: album),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'List Song',
                  style: Theme.of(context).textTheme.headline2,
                ),
                Consumer(
                  builder: (context, ref, child) {
                    return GestureDetector(
                      onTap: () {
                        final songs = ref.watch(songsProvider);
                        ref.watch(audioPlayerProvider.notifier).startPlayList(
                              songs.where((element) => element.album == album.title).toList(),
                              0,
                            );
                      },
                      child: Text(
                        'Play',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    );
                  },
                )
              ],
            ),
            const SizedBox(height: 30),
            ListAlbumSongs(album: album),
          ],
        ),
      ),
      bottomSheet: const CurrentSong(),
    );
  }
}
