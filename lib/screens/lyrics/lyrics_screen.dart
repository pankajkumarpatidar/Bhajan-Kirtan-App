import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/bhajan_model.dart';
import '../../widgets/favorite_button.dart';
import '../audio/audio_player_screen.dart';

class LyricsScreen extends StatefulWidget {
  final BhajanModel bhajan;

  const LyricsScreen({
    super.key,
    required this.bhajan,
  });

  @override
  State<LyricsScreen> createState() => _LyricsScreenState();
}

class _LyricsScreenState extends State<LyricsScreen> {
  double fontSize = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),

      appBar: AppBar(
        centerTitle: true,
        elevation: 0,

        title: Text(
          widget.bhajan.title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),

        actions: [

          FavoriteButton(
            bhajanId: widget.bhajan.id,
          ),

          IconButton(
            onPressed: () {
              // TODO Share
            },
            icon: const Icon(Icons.share),
          ),

        ],
      ),
floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(
          Icons.play_arrow,
        ),
        label: const Text("Play"),
        backgroundColor: Colors.orange,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AudioPlayerScreen(
                bhajan: widget.bhajan,
              ),
            ),
          );
        },
      ),

      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [

            Row(
              children: [

                const Text(
                  "Font Size",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Spacer(),

                IconButton(
                  onPressed: () {
                    if (fontSize > 16) {
                      setState(() {
                        fontSize--;
                      });
                    }
                  },
                  icon: const Icon(
                    Icons.remove_circle_outline,
                  ),
                ),

                Text(
                  fontSize.toInt().toString(),
                ),

                IconButton(
                  onPressed: () {
                    if (fontSize < 40) {
                      setState(() {
                        fontSize++;
                      });
                    }
                  },
                  icon: const Icon(
                    Icons.add_circle_outline,
                  ),
                ),
              ],
            ),

            const Divider(),
Expanded(
              child: SingleChildScrollView(
                child: SelectableText(
                  widget.bhajan.lyrics.isEmpty
                      ? "इस भजन के बोल अभी उपलब्ध नहीं हैं।"
                      : widget.bhajan.lyrics,
                  style: GoogleFonts.poppins(
                    fontSize: fontSize,
                    height: 1.8,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
);
  }
}