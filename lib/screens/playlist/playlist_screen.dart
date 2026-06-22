import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/services/playlist_service.dart';
import '../../models/playlist_model.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  State<PlaylistScreen> createState() =>
      _PlaylistScreenState();
}

class _PlaylistScreenState
    extends State<PlaylistScreen> {

  List<PlaylistModel> playlists = [];

  @override
  void initState() {
    super.initState();
    loadPlaylists();
  }

  void loadPlaylists() {

    playlists =
        PlaylistService.getAllPlaylists();

    setState(() {});
  }

  Future<void> createPlaylist() async {

    final controller =
        TextEditingController();

    await showDialog(

      context: context,

      builder: (_) {

        return AlertDialog(

          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20),
          ),

          title: Text(
            "Create Playlist",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
            ),
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

                loadPlaylists();

              },
              child: const Text("Create"),
            ),

          ],

        );

      },

    );

  }
@override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xffF7F8FC),

      appBar: AppBar(

        centerTitle: true,

        title: Text(
          "My Playlists",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),

      ),

      floatingActionButton:
          FloatingActionButton(

        backgroundColor: Colors.orange,

        onPressed: createPlaylist,

        child: const Icon(Icons.add),

      ),

      body: playlists.isEmpty

          ? Center(

              child: Column(

                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: [

                  const Icon(
                    Icons.queue_music,
                    size: 90,
                    color: Colors.orange,
                  ),

                  const SizedBox(height: 20),

                  Text(
                    "No Playlist Found",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Create your first playlist.",
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                    ),
                  ),

                ],

              ),

            )

          : ListView.builder(

              padding:
                  const EdgeInsets.all(16),

              itemCount: playlists.length,

              itemBuilder:
                  (context, index) {

                final playlist =
                    playlists[index];

                return Card(

                  margin:
                      const EdgeInsets.only(
                    bottom: 14,
                  ),

                  elevation: 2,

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      18,
                    ),
                  ),

                  child: ListTile(

                    leading: CircleAvatar(

                      backgroundColor:
                          Colors.orange.shade100,

                      child: const Icon(
                        Icons.queue_music,
                        color:
                            Colors.deepOrange,
                      ),

                    ),

                    title: Text(

                      playlist.name,

                      style:
                          GoogleFonts.poppins(
                        fontWeight:
                            FontWeight.w600,
                      ),

                    ),

                    subtitle: Text(

                      "${playlist.bhajans.length} Bhajans",

                    ),

                    trailing: PopupMenuButton(

                      itemBuilder: (_) => [

                        const PopupMenuItem(

                          value: "rename",

                          child: Text("Rename"),

                        ),

                        const PopupMenuItem(

                          value: "delete",

                          child: Text("Delete"),

                        ),

                      ],

                      onSelected: (value) async {
if (value == "rename") {

                          final controller =
                              TextEditingController(
                            text: playlist.name,
                          );

                          await showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title: const Text(
                                  "Rename Playlist",
                                ),
                                content: TextField(
                                  controller: controller,
                                  decoration:
                                      const InputDecoration(
                                    hintText:
                                        "Playlist Name",
                                  ),
                                ),
                                actions: [

                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(
                                          context);
                                    },
                                    child: const Text(
                                      "Cancel",
                                    ),
                                  ),

                                  ElevatedButton(
                                    onPressed: () async {

                                      await PlaylistService
                                          .renamePlaylist(
                                        playlist.id,
                                        controller.text
                                            .trim(),
                                      );

                                      if (mounted) {
                                        Navigator.pop(
                                            context);
                                      }

                                      loadPlaylists();

                                    },
                                    child: const Text(
                                      "Save",
                                    ),
                                  ),

                                ],
                              );
                            },
                          );

                        }

                        if (value == "delete") {

                          await PlaylistService
                              .deletePlaylist(
                            playlist.id,
                          );

                          loadPlaylists();

                        }

                      },

                    ),

                    onTap: () {

                      // TODO
                      // Playlist Details Screen

                    },

                  ),

                );

              },

            ),

    );

  }

}