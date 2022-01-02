import 'dart:io';
import 'dart:typed_data';
import 'package:audio_service/audio_service.dart';
import 'package:music_app/models/album.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';

class AudioQuery {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  Future<List<MediaItem>> queryMediaItems() async {
    final songs = await _audioQuery.querySongs();
    final tempDir = await getTemporaryDirectory();

    List<MediaItem> mediaItems = [];

    for (SongModel song in songs) {
      if (song.isMusic ?? false) {
        File file = File('${tempDir.path}/${song.albumId}.jpg');
        final exist = await file.exists();

        mediaItems.add(
          MediaItem(
            id: song.id.toString(),
            title: song.title,
            album: song.album,
            artist: song.artist,
            duration: Duration(milliseconds: song.duration ?? 0),
            artUri: exist ? Uri.file(file.path) : null,
            extras: {'path': song.data},
          ),
        );
      }
    }
    return mediaItems;
  }

  Future<List<Album>> queryAlbums() async {
    final albums = await _audioQuery.queryAlbums();
    List<Album> _albums = [];

    final tempDir = await getTemporaryDirectory();

    for (AlbumModel album in albums) {
      Uint8List? imageUint8List = await _audioQuery.queryArtwork(album.id, ArtworkType.ALBUM);
      File file = File('${tempDir.path}/${album.id}.jpg');
      bool exist = await file.exists();

      if (imageUint8List != null && !exist) {
        await file.create();
        file.writeAsBytesSync(imageUint8List);
        exist = true;
      }

      _albums.add(
        Album(
          id: album.id,
          title: album.album,
          artist: album.artist ?? '',
          songCount: album.numOfSongs,
          path: exist ? file.path : null,
        ),
      );
    }
    return _albums;
  }
}
