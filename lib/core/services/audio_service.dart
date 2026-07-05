import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';

import '../../models/bhajan_model.dart';

class AudioService extends ChangeNotifier {
  AudioService._();

  static final AudioService instance =
      AudioService._();

  final AudioPlayer player = AudioPlayer();

  BhajanModel? currentBhajan;

  List<BhajanModel> _playlist = [];

  int _currentIndex = -1;

  bool _loading = false;

  bool get isLoading => _loading;

  bool get isPlaying => player.playing;

  Duration get position =>
      player.position;

  Duration get duration =>
      player.duration ?? Duration.zero;

  List<BhajanModel> get playlist =>
      List.unmodifiable(_playlist);

  int get currentIndex =>
      _currentIndex;
  Future<void> playBhajan(
    BhajanModel bhajan,
  ) async {

    try {

      /// Same song already playing
      if (currentBhajan?.id == bhajan.id &&
          player.playing) {
        return;
      }

      _loading = true;

      notifyListeners();

      currentBhajan = bhajan;

      final index = _playlist.indexWhere(
        (e) => e.id == bhajan.id,
      );

      if (index != -1) {
        _currentIndex = index;
      }

      await player.stop();

      await player.setAudioSource(
        AudioSource.uri(
          Uri.parse(
            bhajan.audioUrl,
          ),
          tag: MediaItem(
            id: bhajan.id,
            title: bhajan.title,
            album: "Kirtan App",
            artist: bhajan.categoryId,
            artUri:
                bhajan.image.isNotEmpty
                    ? Uri.parse(
                        bhajan.image,
                      )
                    : null,
          ),
        ),
      );

      await player.play();

      _loading = false;

      notifyListeners();

    } catch (e) {

      _loading = false;

      debugPrint(
        "Play Error : $e",
      );

      notifyListeners();

    }

  }
  Future<void> pause() async {

    await player.pause();

    notifyListeners();

  }

  Future<void> stop() async {

    await player.stop();

    currentBhajan = null;

    _playlist.clear();

    _currentIndex = -1;

    _loading = false;

    notifyListeners();

  }

  Future<void> seek(
    Duration position,
  ) async {

    await player.seek(position);

  }

  Future<void> togglePlayPause() async {

  try {

    if (player.playing) {

      await player.pause();

    } else {

      await player.play();

    }

    notifyListeners();

  } catch (e) {

    debugPrint("Toggle Error: $e");

  }

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

    if (_playlist.isEmpty) {

      _currentIndex = -1;

      currentBhajan = null;

      notifyListeners();

      return;

    }

    if (startIndex < 0) {

      startIndex = 0;

    }

    if (startIndex >= _playlist.length) {

      startIndex =
          _playlist.length - 1;

    }

    _currentIndex = startIndex;

    currentBhajan =
        _playlist[_currentIndex];

    notifyListeners();

  }

  Future<void> playNext() async {

    if (_playlist.isEmpty) return;

    if (_currentIndex >=
        _playlist.length - 1) {
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

    if (_currentIndex >=
        _playlist.length - 1) {
      return null;
    }

    return _playlist[
      _currentIndex + 1
    ];

  }

  BhajanModel? get previousBhajan {

    if (_playlist.isEmpty) return null;

    if (_currentIndex <= 0) {
      return null;
    }

    return _playlist[
      _currentIndex - 1
    ];

  }
  void initialize() {

    player.playerStateStream.listen(
      (state) async {

        if (state.processingState ==
            ProcessingState.completed) {

          if (_playlist.isNotEmpty &&
              _currentIndex <
                  _playlist.length - 1) {

            await playNext();

          } else {

            await stop();

          }

        }

        notifyListeners();

      },
    );

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