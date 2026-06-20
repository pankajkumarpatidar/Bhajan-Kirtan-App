import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';

import '../../models/bhajan_model.dart';

class AudioPlayerScreen extends StatefulWidget {
  final BhajanModel bhajan;

  const AudioPlayerScreen({
    super.key,
    required this.bhajan,
  });

  @override
  State<AudioPlayerScreen> createState() =>
      _AudioPlayerScreenState();
}

class _AudioPlayerScreenState
    extends State<AudioPlayerScreen> {

  final AudioPlayer _player = AudioPlayer();

  bool isPlaying = false;
  bool isLoading = true;

  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();

    _loadAudio();

    _player.playerStateStream.listen((state) {

      if (!mounted) return;

      setState(() {
        isPlaying = state.playing;
      });

      if (state.processingState ==
          ProcessingState.completed) {

        _player.seek(Duration.zero);

        setState(() {
          isPlaying = false;
        });
      }
    });

    _player.durationStream.listen((d) {

      if (!mounted) return;

      setState(() {
        duration = d ?? Duration.zero;
      });
    });

    _player.positionStream.listen((p) {

      if (!mounted) return;

      setState(() {
        position = p;
      });
    });
  }

  Future<void> _loadAudio() async {

    try {

      await _player.setUrl(
        widget.bhajan.audioUrl,
      );

    } catch (e) {

      debugPrint(e.toString());

    }

    if (mounted) {

      setState(() {

        isLoading = false;

      });

    }

  }

  String formatTime(Duration d) {

    final minutes =
        d.inMinutes.remainder(60);

    final seconds =
        d.inSeconds.remainder(60);

    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xffF8F8F8),

      appBar: AppBar(

        centerTitle: true,

        title: Text(

          widget.bhajan.title,

          maxLines: 1,

          overflow: TextOverflow.ellipsis,

          style: GoogleFonts.poppins(

            fontWeight: FontWeight.w600,

          ),

        ),

      ),

      body: SafeArea(

        child: SingleChildScrollView(

          padding: const EdgeInsets.all(20),

          child: Column(

            children: [
const SizedBox(height: 20),

              Container(
                height: 260,
                width: 260,
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.music_note,
                  size: 120,
                  color: Colors.deepOrange,
                ),
              ),

              const SizedBox(height: 30),

              Text(
                widget.bhajan.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              if (isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: CircularProgressIndicator(),
                )
              else ...[

                Slider(
                  value: position.inSeconds.toDouble().clamp(
                    0,
                    duration.inSeconds.toDouble() == 0
                        ? 1
                        : duration.inSeconds.toDouble(),
                  ),
                  min: 0,
                  max: duration.inSeconds.toDouble() == 0
                      ? 1
                      : duration.inSeconds.toDouble(),
                  activeColor: Colors.orange,
                  onChanged: (value) async {
                    await _player.seek(
                      Duration(seconds: value.toInt()),
                    );
                  },
                ),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [

                    Text(
                      formatTime(position),
                      style: GoogleFonts.poppins(),
                    ),

                    Text(
                      formatTime(duration),
                      style: GoogleFonts.poppins(),
                    ),

                  ],
                ),

                const SizedBox(height: 35),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,
                  children: [

                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.skip_previous,
                        size: 35,
                      ),
                    ),

                    FloatingActionButton(
                      heroTag: "play",
                      backgroundColor: Colors.orange,
                      elevation: 5,
                      onPressed: () async {

                        if (isPlaying) {

                          await _player.pause();

                        } else {

                          await _player.play();

                        }

                      },
                      child: Icon(
                        isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                        size: 40,
                      ),
                    ),

                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.skip_next,
                        size: 35,
                      ),
                    ),

                  ],
                ),

                const SizedBox(height: 35),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,
                  children: [

                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.favorite_border,
                        color: Colors.red,
                      ),
                    ),

                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.repeat),
                    ),

                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.shuffle),
                    ),

                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.share),
                    ),

                  ],
                ),

              ],

              const SizedBox(height: 30),
],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}