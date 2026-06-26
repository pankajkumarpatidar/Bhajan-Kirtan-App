import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';

import '../../models/bhajan_model.dart';

class AudioService extends ChangeNotifier {
  AudioService._();

  static final AudioService instance = AudioService._();

  final AudioPlayer player = AudioPlayer();

  BhajanModel? currentBhajan;

  List<BhajanModel> _playlist = [];

  int _currentIndex = -1;

  bool get isPlaying => player.playing;

  Duration get position => player.position;

  Duration get duration => player.duration ?? Duration.zero;

  Future<void> playBhajan(
    BhajanModel bhajan,
  ) async {
    try {
      currentBhajan = bhajan;

      final index = _playlist.indexWhere(
        (e) => e.id == bhajan.id,
      );

      if (index != -1) {
        _currentIndex = index;
      }

      await player.setAudioSource(
        AudioSource.uri(
          Uri.parse(bhajan.audioUrl),
          tag: MediaItem(
            id: bhajan.id,
            title: bhajan.title,
            album: "Kirtan App",
            artist: bhajan.categoryId,
            artUri: bhajan.image.isNotEmpty
                ? Uri.parse(bhajan.image)
                : null,
          ),
        ),
      );

      await player.play();

      notifyListeners();
    } catch (e) {
      debugPrint("Play Error : $e");
    }
  }

  Future<void> pause() async {
    await player.pause();
    notifyListeners();
  }

  Future<void> stop() async {
    await player.stop();
    notifyListeners();
  }

  Future<void> seek(
    Duration position,
  ) async {
    await player.seek(position);
  }

  Future<void> togglePlayPause() async {
    if (player.playing) {
      await player.pause();
    } else {
      await player.play();
    }

    notifyListeners();
  }

  Stream<Duration> get positionStream =>
      player.positionStream;

  Stream<Duration?> get durationStream =>
      player.durationStream;

  Stream<PlayerState> get playerStateStream =>
      player.playerStateStream;
void setPlaylist(
    List<BhajanModel> bhajans,
    int startIndex,
  ) {
    _playlist = List.from(bhajans);

    _currentIndex = startIndex;

    if (_playlist.isNotEmpty &&
        startIndex >= 0 &&
        startIndex < _playlist.length) {
      currentBhajan = _playlist[startIndex];
    }

    notifyListeners();
  }

  Future<void> playNext() async {
    if (_playlist.isEmpty) return;

    if (_currentIndex >= _playlist.length - 1) {
      return;
    }

    _currentIndex++;

    await playBhajan(
      _playlist[_currentIndex],
    );
  }

  Future<void> playPrevious() async {
    if (_playlist.isEmpty) return;

    if (_currentIndex <= 0) {
      return;
    }

    _currentIndex--;

    await playBhajan(
      _playlist[_currentIndex],
    );
  }

  BhajanModel? get nextBhajan {
    if (_playlist.isEmpty) return null;

    if (_currentIndex >= _playlist.length - 1) {
      return null;
    }

    return _playlist[_currentIndex + 1];
  }

  BhajanModel? get previousBhajan {
    if (_playlist.isEmpty) return null;

    if (_currentIndex <= 0) {
      return null;
    }

    return _playlist[_currentIndex - 1];
  }
void initialize() {

    player.playerStateStream.listen((state) async {

      if (state.processingState ==
          ProcessingState.completed) {

        if (_currentIndex <
            _playlist.length - 1) {

          await playNext();

        }

      }

      notifyListeners();

    });

    player.positionStream.listen((_) {
      notifyListeners();
    });

    player.durationStream.listen((_) {
      notifyListeners();
    });

  }

  @override
  void dispose() {

    player.dispose();

    super.dispose();

  }

}