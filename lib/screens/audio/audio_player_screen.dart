import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/services/audio_service.dart';
import '../../core/services/recent_service.dart';
import '../../models/bhajan_model.dart';
import '../../widgets/add_to_playlist_sheet.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/favorite_button.dart';

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

  late AudioService audio;

  @override
  void initState() {
    super.initState();

    audio = AudioService.instance;

    RecentService.addRecent(
      widget.bhajan.id,
    );
  }

  String formatTime(Duration d) {

    final hours = d.inHours;

    final minutes =
        d.inMinutes.remainder(60);

    final seconds =
        d.inSeconds.remainder(60);

    if (hours > 0) {

      return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";

    }

    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }
@override
Widget build(BuildContext context) {

  return Consumer<AudioService>(

    builder: (context, audio, child) {

      return AppScaffold(

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

          actions: [

            FavoriteButton(
              bhajanId: widget.bhajan.id,
            ),

            IconButton(
              icon: const Icon(
                Icons.playlist_add,
              ),
              onPressed: () {

                showModalBottomSheet(

                  context: context,

                  isScrollControlled: true,

                  shape: const RoundedRectangleBorder(

                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25),
                    ),

                  ),

                  builder: (_) => AddToPlaylistSheet(
                    bhajanId: widget.bhajan.id,
                  ),

                );

              },
            ),

            IconButton(
              onPressed: () {
                // TODO Share
              },
              icon: const Icon(
                Icons.share,
              ),
            ),

          ],

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

          audio.currentBhajan?.title ??
              widget.bhajan.title,

          textAlign: TextAlign.center,

          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),

        ),

        const SizedBox(height: 30),

        Slider(

          value: audio.position.inSeconds
              .toDouble()
              .clamp(
                0,
                audio.duration.inSeconds == 0
                    ? 1
                    : audio.duration.inSeconds
                        .toDouble(),
              ),

          min: 0,

          max: audio.duration.inSeconds == 0
              ? 1
              : audio.duration.inSeconds
                  .toDouble(),

          activeColor: Colors.orange,

          onChanged: (value) async {

            await audio.seek(

              Duration(
                seconds: value.toInt(),
              ),

            );

          },

        ),
Row(
  mainAxisAlignment:
      MainAxisAlignment.spaceBetween,
  children: [

    Text(
      formatTime(
        audio.position,
      ),
      style: GoogleFonts.poppins(),
    ),

    Text(
      formatTime(
        audio.duration,
      ),
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
      onPressed: () async {
        await audio.playPrevious();
      },
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
        await audio.togglePlayPause();
      },
      child: Icon(
        audio.isPlaying
            ? Icons.pause
            : Icons.play_arrow,
        size: 40,
      ),
    ),

    IconButton(
      onPressed: () async {
        await audio.playNext();
      },
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

    FavoriteButton(
      bhajanId: widget.bhajan.id,
    ),

    IconButton(
      tooltip: "Download",
      onPressed: () {
        // TODO Download
      },
      icon: const Icon(
        Icons.download,
      ),
    ),

  ],
),

const SizedBox(height: 30),

],
      ),
    ),
  ),
);
},
  );
}
@override
void dispose() {
  super.dispose();
}
    }