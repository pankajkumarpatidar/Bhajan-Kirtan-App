import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/services/audio_service.dart';
import '../screens/audio/audio_player_screen.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioService>(
      builder: (context, audio, child) {
        if (audio.currentBhajan == null) {
          return const SizedBox.shrink();
        }

        return Material(
          elevation: 8,
          color: Colors.white,
          child: InkWell(
            onTap: () {

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => AudioPlayerScreen(
        bhajan: audio.currentBhajan!,
      ),
    ),
  );

},
            child: SafeArea(
              top: false,
              child: Container(
                height: 72,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.music_note,
                        color: Colors.deepOrange,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Text(
                        audio.currentBhajan!.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    IconButton(
                      onPressed: () async {
                        await audio.playPrevious();
                      },
                      icon: const Icon(Icons.skip_previous),
                    ),

                    IconButton(
                      onPressed: () async {
                        await audio.togglePlayPause();
                      },
                      icon: Icon(
                        audio.isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_fill,
                        size: 36,
                      ),
                    ),

                    IconButton(
                      onPressed: () async {
                        await audio.playNext();
                      },
                      icon: const Icon(Icons.skip_next),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}