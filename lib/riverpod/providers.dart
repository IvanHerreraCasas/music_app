import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/models/album.dart';
import 'package:music_app/models/play_list_state.dart';
import 'package:music_app/riverpod/audio_player_notifier.dart';

final songsProvider = StateProvider<List<MediaItem>>((ref) => []);
final albumsProvider = StateProvider<List<Album>>((ref) => []);
final audioHandlerProvider = Provider<AudioHandler>((ref) => throw UnimplementedError());

final audioPlayerProvider = StateNotifierProvider<AudioPlayerNotifier, PlayListState>(
  (ref) => AudioPlayerNotifier(ref.read(audioHandlerProvider)),
);
