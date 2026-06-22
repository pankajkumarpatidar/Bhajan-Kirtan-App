import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/services/playlist_service.dart';
import '../models/playlist_model.dart';

class AddToPlaylistSheet extends StatefulWidget {

  final String bhajanId;

  const AddToPlaylistSheet({
    super.key,
    required this.bhajanId,
  });

  @override
  State<AddToPlaylistSheet> createState() =>
      _AddToPlaylistSheetState();
}

class _AddToPlaylistSheetState
    extends State<AddToPlaylistSheet> {

  List<PlaylistModel> playlists = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() {

    playlists =
        PlaylistService.getAllPlaylists();

    setState(() {});

  }

  Future<void> addPlaylist() async {

    final controller =
        TextEditingController();

    await showDialog(

      context: context,

      builder: (_) {

        return AlertDialog(

          title: const Text(
            "New Playlist",
          ),

          content: TextField(

            controller: controller,

            decoration:
                const InputDecoration(
              hintText: "Playlist Name",
            ),

          ),

          actions: [

            TextButton(

              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text("Cancel"),

            ),

            ElevatedButton(

              onPressed: () async {

                if (controller.text
                    .trim()
                    .isEmpty) {
                  return;
                }

                await PlaylistService
                    .createPlaylist(
                  controller.text.trim(),
                );

                if (mounted) {
                  Navigator.pop(context);
                }

                load();

              },

              child: const Text(
                "Create",
              ),

            ),

          ],

        );

      },

    );

  }
@override
  Widget build(BuildContext context) {

    return SafeArea(

      child: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          mainAxisSize: MainAxisSize.min,

          children: [

            Row(

              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,

              children: [

                Text(

                  "Add to Playlist",

                  style: GoogleFonts.poppins(

                    fontSize: 20,

                    fontWeight: FontWeight.bold,

                  ),

                ),

                IconButton(

                  onPressed: addPlaylist,

                  icon: const Icon(
                    Icons.add_circle,
                    color: Colors.orange,
                  ),

                ),

              ],

            ),

            const SizedBox(height: 15),

            if (playlists.isEmpty)

              Padding(

                padding: const EdgeInsets.symmetric(
                  vertical: 40,
                ),

                child: Column(

                  children: [

                    const Icon(
                      Icons.queue_music,
                      size: 70,
                      color: Colors.orange,
                    ),

                    const SizedBox(height: 15),

                    Text(

                      "No Playlist Found",

                      style: GoogleFonts.poppins(

                        fontSize: 18,

                        fontWeight: FontWeight.w600,

                      ),

                    ),

                    const SizedBox(height: 8),

                    Text(

                      "Tap + to create your first playlist",

                      style: GoogleFonts.poppins(
                        color: Colors.grey,
                      ),

                    ),

                  ],

                ),

              )

            else

              Flexible(

                child: ListView.builder(

                  shrinkWrap: true,

                  itemCount: playlists.length,

                  itemBuilder: (context,index){

                    final playlist =
                        playlists[index];

                    return Card(

                      child: ListTile(

                        leading: const CircleAvatar(

                          backgroundColor:
                              Colors.orange,

                          child: Icon(
                            Icons.queue_music,
                            color: Colors.white,
                          ),

                        ),

                        title: Text(
                          playlist.name,
                        ),

                        subtitle: Text(
                          "${playlist.bhajans.length} Bhajans",
                        ),

                        trailing: const Icon(
                          Icons.add,
                        ),

                        onTap: () async {
await PlaylistService.addBhajan(
                            playlist.id,
                            widget.bhajanId,
                          );

                          if (!mounted) return;

                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            SnackBar(
                              content: Text(
                                "Added to ${playlist.name}",
                              ),
                              backgroundColor:
                                  Colors.green,
                            ),
                          );

                          Navigator.pop(context);
                        },

                      ),

                    );

                  },

                ),

              ),

            const SizedBox(height: 10),

          ],

        ),

      ),

    );

  }

}