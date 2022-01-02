import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/models/play_list_state.dart';

class AudioPlayerNotifier extends StateNotifier<PlayListState> {
  AudioPlayerNotifier(this._audioHandler) : super(const PlayListState(queue: [])) {
    _audioHandler.playbackState.listen(
      (PlaybackState playbackState) {
        state = state.copyWith(
          playing: playbackState.playing,
          queueIndex: playbackState.queueIndex,
          progress: playbackState.updatePosition,
          shuffleMode: playbackState.shuffleMode,
          repeatMode: playbackState.repeatMode,
        );
      },
    );

    _audioHandler.queue.listen((List<MediaItem> queue) {
      state = state.copyWith(queue: queue);
    });

    _audioHandler.mediaItem.listen((MediaItem? mediaItem) {
      state = state.copyWith(
        total: mediaItem?.duration,
      );
    });

    AudioService.position.listen((Duration position) {
      state = state.copyWith(progress: position);
    });
  }

  final AudioHandler _audioHandler;

  void playPause() {
    if (state.playing) {
      _audioHandler.pause();
    } else {
      _audioHandler.play();
    }
  }

  Future<void> startPlayList(List<MediaItem> queue, int index) async {
    
    await _audioHandler.customAction('start', {'queue': queue, 'index': index});
  }

  void reOrderQueue(int oldIndex, int newIndex) {
    _audioHandler.customAction('reorder', {'oldIndex': oldIndex, 'newIndex': newIndex});
  }

  void skipToNext() => _audioHandler.skipToNext();

  void skipToPrevious() => _audioHandler.skipToPrevious();

  void skipToQueueItem(int index) => _audioHandler.skipToQueueItem(index);

  void removeQueueItemAt(int index) => _audioHandler.removeQueueItemAt(index);

  void changeShuffleMode() {
    switch (state.shuffleMode) {
      case AudioServiceShuffleMode.none:
        _audioHandler.setShuffleMode(AudioServiceShuffleMode.all);
        break;
      case AudioServiceShuffleMode.all:
        _audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
        break;
      case AudioServiceShuffleMode.group:
        //Not used
        break;
    }
  }

  void changeRepeatMode() {
    switch (state.repeatMode) {
      case AudioServiceRepeatMode.none:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
        break;
      case AudioServiceRepeatMode.all:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.one);
        break;
      case AudioServiceRepeatMode.one:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
        break;
      case AudioServiceRepeatMode.group:
        //Not used
        break;
    }
  }

  void seek(Duration? position) {
    _audioHandler.seek(position ?? const Duration());
  }
}
