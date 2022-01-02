import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class MyAudioHandler extends BaseAudioHandler {
  final _player = AudioPlayer();
  var _playList = ConcatenatingAudioSource(children: []);

  MyAudioHandler() {
    _notifyAudioHandlerAboutPlaybackEvents();
    _listenForDurationChanges();
    _listenForCurrentSongIndexChanges();
    _listenForSequenceStateChanges();
    _listenForShuffleModeChanges();
    _listenForRepeatModeChanges();
  }

  void _notifyAudioHandlerAboutPlaybackEvents() {
    _player.playbackEventStream.listen(
      (PlaybackEvent event) {
        final playing = _player.playing;
        final queueIndex = _player.effectiveIndices?.indexOf(_player.currentIndex ?? 0);
        playbackState.add(
          playbackState.value.copyWith(
            controls: [
              MediaControl.skipToPrevious,
              if (playing) MediaControl.pause else MediaControl.play,
              MediaControl.stop,
              MediaControl.skipToNext,
            ],
            systemActions: const {
              MediaAction.seek,
            },
            androidCompactActionIndices: const [0, 1, 3],
            processingState: const {
              ProcessingState.idle: AudioProcessingState.idle,
              ProcessingState.loading: AudioProcessingState.loading,
              ProcessingState.buffering: AudioProcessingState.buffering,
              ProcessingState.ready: AudioProcessingState.ready,
              ProcessingState.completed: AudioProcessingState.completed,
            }[_player.processingState]!,
            repeatMode: const {
              LoopMode.off: AudioServiceRepeatMode.none,
              LoopMode.one: AudioServiceRepeatMode.one,
              LoopMode.all: AudioServiceRepeatMode.all,
            }[_player.loopMode]!,
            shuffleMode: _player.shuffleModeEnabled ? AudioServiceShuffleMode.all : AudioServiceShuffleMode.none,
            playing: playing,
            updatePosition: _player.position,
            bufferedPosition: _player.bufferedPosition,
            speed: _player.speed,
            queueIndex: queueIndex,
          ),
        );
      },
    );
  }

  void _listenForCurrentSongIndexChanges() {
    _player.currentIndexStream.listen((index) {
      final playlist = queue.value;

      if (index == null || playlist.isEmpty) return;
      if (_player.shuffleModeEnabled) {
        ///Example
        ///Normal queue indices = [0, 1, 2, 3, 4, 5]
        ///Shuffle queue indices = [3, 5, 0, 2, 1, 4]
        ///If the index obtained from the stream is 2, the real index of the song in the shuffle queue is 4.
        ///Can be checked with the logs.

        //log('shuffle queue indices' + _player.shuffleIndices!.toString());
        //log('normal index: ' + index.toString());
        index = _player.shuffleIndices!.indexOf(index);
        //log('effective index: ' + index.toString());
      }
      if (index < playlist.length && index > -1) {
        mediaItem.add(playlist[index]);
      }
    });
  }

  void _listenForSequenceStateChanges() {
    _player.sequenceStateStream.listen(
      (SequenceState? sequenceState) {
        final sequence = sequenceState?.effectiveSequence;

        if (sequence == null || sequence.isEmpty) return;
        final items = sequence.map((source) => source.tag as MediaItem);
        queue.add(items.toList());
      },
    );
  }

  void _listenForDurationChanges() {
    _player.durationStream.listen(
      (duration) {
        var index = _player.currentIndex;
        final newQueue = queue.value;
        if (index == null || newQueue.isEmpty) return;

        if (_player.shuffleModeEnabled) {
          index = _player.shuffleIndices!.indexOf(index);
        }
        final oldMediaItem = newQueue[index];
        final newMediaItem = oldMediaItem.copyWith(duration: duration);
        newQueue[index] = newMediaItem;
        mediaItem.add(newMediaItem);
      },
    );
  }

  void _listenForShuffleModeChanges() {
    _player.shuffleModeEnabledStream.listen(
      (enabled) {
        int? queueIndex = _player.currentIndex;
        if (queueIndex != null) {
          if (queueIndex < queue.value.length && queueIndex > -1) {
            queueIndex = _player.effectiveIndices?.indexOf(_player.currentIndex ?? 0);
          }
        }
        playbackState.add(
          playbackState.value.copyWith(
            shuffleMode: enabled ? AudioServiceShuffleMode.all : AudioServiceShuffleMode.none,
            queueIndex: queueIndex,
          ),
        );
      },
    );
  }

  void _listenForRepeatModeChanges() {
    _player.loopModeStream.listen(
      (loopMode) {
        late AudioServiceRepeatMode repeatMode;
        switch (loopMode) {
          case LoopMode.off:
            repeatMode = AudioServiceRepeatMode.none;
            break;
          case LoopMode.one:
            repeatMode = AudioServiceRepeatMode.one;
            break;
          case LoopMode.all:
            repeatMode = AudioServiceRepeatMode.all;
            break;
        }
        playbackState.add(
          playbackState.value.copyWith(
            repeatMode: repeatMode,
          ),
        );
      },
    );
  }

  UriAudioSource _createAudioSource(MediaItem mediaItem) {
    return AudioSource.uri(
      Uri.file(mediaItem.extras!['path']),
      tag: mediaItem,
    );
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> skipToNext() => _player.seekToNext();

  @override
  Future<void> skipToPrevious() => _player.seekToPrevious();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> removeQueueItemAt(int index) => _playList.removeAt(index);

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    switch (repeatMode) {
      case AudioServiceRepeatMode.none:
        _player.setLoopMode(LoopMode.off);
        break;
      case AudioServiceRepeatMode.one:
        _player.setLoopMode(LoopMode.one);
        break;
      case AudioServiceRepeatMode.group:
        break;
      case AudioServiceRepeatMode.all:
        _player.setLoopMode(LoopMode.all);
        break;
    }
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    if (shuffleMode == AudioServiceShuffleMode.none) {
      _player.setShuffleModeEnabled(false);
    } else {
      _player.setShuffleModeEnabled(true);
      await _player.shuffle();
    }
  }

  @override
  Future<void> stop() async {
    playbackState.add(playbackState.value.copyWith(processingState: AudioProcessingState.completed));
    await _player.stop();
  }

  @override
  Future customAction(String name, [Map<String, dynamic>? extras]) async {
    switch (name) {
      case 'start':
        {
          final source = await extras!['queue'].map(_createAudioSource).toList().cast<AudioSource>();
          //queue.add(extras['queue']);
          await setShuffleMode(AudioServiceShuffleMode.none);
          _playList = ConcatenatingAudioSource(children: source);
          await _player.setAudioSource(
            _playList,
            initialIndex: extras['index'],
          );
          play();
        }
        break;
      case 'reorder':
        {
          int oldIndex = extras!['oldIndex'] as int;
          int newIndex = extras['newIndex'] as int;
          final indexedAudioSource = _player.sequence![oldIndex];

          if (newIndex > oldIndex) {
            await _playList.insert(newIndex, indexedAudioSource);
            await _playList.removeAt(oldIndex);
          } else {
            await _playList.removeAt(oldIndex);
            await _playList.insert(newIndex, indexedAudioSource);
          }
        }
    }
  }
}
