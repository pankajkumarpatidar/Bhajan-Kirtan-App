import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/services/playlist_service.dart';
import '../../models/bhajan_model.dart';
import '../../repository/bhajan_repository.dart';
import '../audio/audio_player_screen.dart';

class PlaylistDetailsScreen extends StatefulWidget {

  final String playlistId;

  final String playlistName;

  const PlaylistDetailsScreen({
    super.key,
    required this.playlistId,
    required this.playlistName,
  });

  @override
  State<PlaylistDetailsScreen> createState() =>
      _PlaylistDetailsScreenState();
}

class _PlaylistDetailsScreenState
    extends State<PlaylistDetailsScreen> {

  final BhajanRepository repository =
      BhajanRepository();

  List<BhajanModel> bhajans = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadBhajans();
  }

  Future<void> loadBhajans() async {

    loading = true;

    setState(() {});

    final playlist =
        PlaylistService.getPlaylist(
      widget.playlistId,
    );

    if (playlist == null) {

      loading = false;

      setState(() {});

      return;

    }

    final allBhajans =
        await repository.getAllBhajans();

    bhajans = allBhajans.where((e) {

      return playlist.bhajans.contains(e.id);

    }).toList();

    loading = false;

    setState(() {});

  }
@override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text(
          widget.playlistName,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),

      body: loading

          ? const Center(
              child: CircularProgressIndicator(),
            )

          : Column(

              children: [

                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(18),

                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius:
                        BorderRadius.circular(18),
                  ),

                  child: Column(

                    children: [

                      CircleAvatar(
                        radius: 32,
                        backgroundColor:
                            Colors.orange.shade100,
                        child: const Icon(
                          Icons.queue_music,
                          size: 34,
                          color: Colors.deepOrange,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        widget.playlistName,
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "${bhajans.length} Bhajans",
                        style: GoogleFonts.poppins(
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 18),

                      Row(

                        children: [

                          Expanded(
                            child: ElevatedButton.icon(

                              onPressed: bhajans.isEmpty
                                  ? null
                                  : () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              AudioPlayerScreen(
                                            bhajan:
                                                bhajans.first,
                                          ),
                                        ),
                                      );
                                    },

                              icon: const Icon(
                                Icons.play_arrow,
                              ),

                              label:
                                  const Text("Play"),

                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: OutlinedButton.icon(

                              onPressed: () {},

                              icon: const Icon(
                                Icons.shuffle,
                              ),

                              label:
                                  const Text("Shuffle"),

                            ),
                          ),

                        ],

                      ),

                    ],

                  ),

                ),
Expanded(

                  child: bhajans.isEmpty

                      ? Center(

                          child: Column(

                            mainAxisAlignment:
                                MainAxisAlignment.center,

                            children: [

                              const Icon(
                                Icons.queue_music,
                                size: 80,
                                color: Colors.grey,
                              ),

                              const SizedBox(height: 15),

                              Text(
                                "No Bhajans",
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                "Add bhajans to this playlist.",
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                ),
                              ),

                            ],

                          ),

                        )

                      : ListView.builder(

                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),

                          itemCount: bhajans.length,

                          itemBuilder: (context, index) {

                            final bhajan =
                                bhajans[index];

                            return Card(

                              margin:
                                  const EdgeInsets.only(
                                bottom: 12,
                              ),

                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                        16),
                              ),

                              child: ListTile(

                                leading: CircleAvatar(
                                  backgroundColor:
                                      Colors.orange.shade100,
                                  child: const Icon(
                                    Icons.music_note,
                                    color:
                                        Colors.deepOrange,
                                  ),
                                ),

                                title: Text(
                                  bhajan.title,
                                  maxLines: 1,
                                  overflow:
                                      TextOverflow.ellipsis,
                                  style:
                                      GoogleFonts.poppins(
                                    fontWeight:
                                        FontWeight.w600,
                                  ),
                                ),

                                subtitle: Text(
                                  bhajan.categoryId,
                                ),
trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {

                                    await PlaylistService
                                        .removeBhajan(
                                      widget.playlistId,
                                      bhajan.id,
                                    );

                                    loadBhajans();

                                  },
                                ),

                                onTap: () {

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          AudioPlayerScreen(
                                        bhajan: bhajan,
                                      ),
                                    ),
                                  );

                                },

                              ),

                            );

                          },

                        ),

                ),

              ],

            ),

    );

  }

}