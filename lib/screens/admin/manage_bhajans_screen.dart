import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/services/auth_service.dart';
import '../../models/bhajan_model.dart';
import '../../providers/bhajan_provider.dart';
import '../../widgets/app_scaffold.dart';
import 'add_bhajan_screen.dart';

class ManageBhajansScreen extends StatefulWidget {
  const ManageBhajansScreen({
    super.key,
  });

  @override
  State<ManageBhajansScreen> createState() =>
      _ManageBhajansScreenState();
}

class _ManageBhajansScreenState
    extends State<ManageBhajansScreen> {

  String _search = "";

  @override
  void initState() {

    super.initState();

    context
        .read<BhajanProvider>()
        .startListening();

  }

  @override
  Widget build(BuildContext context) {

    final provider =
        context.watch<BhajanProvider>();

    final bool isSuperAdmin =
        AuthService.instance.isSuperAdmin;

    final List<BhajanModel> bhajans =
        provider.bhajans.where((bhajan) {

      final text =
          _search.toLowerCase();

      return bhajan.title
              .toLowerCase()
              .contains(text) ||

          bhajan.lyrics
              .toLowerCase()
              .contains(text);

    }).toList();

    return AppScaffold(

      backgroundColor:
          const Color(0xffF8F8F8),

      appBar: AppBar(

        centerTitle: true,

        title: Text(

          "Manage Bhajans",

          style: GoogleFonts.poppins(

            fontWeight:
                FontWeight.w600,

          ),

        ),

      ),

      floatingActionButton:
          FloatingActionButton.extended(

        backgroundColor: Colors.orange,

        icon: const Icon(
          Icons.add,
        ),

        label: const Text(
          "Add Bhajan",
        ),

        onPressed: () async {

          await Navigator.push(

            context,

            MaterialPageRoute(

              builder: (_) =>
                  const AddBhajanScreen(),

            ),

          );

        },

      ),

      body: provider.loading

          ? const Center(

              child:
                  CircularProgressIndicator(),

            )

          : Column(

              children: [

                Padding(

                  padding:
                      const EdgeInsets.all(16),

                  child: TextField(

                    decoration: InputDecoration(

                      hintText:
                          "Search Bhajan",

                      prefixIcon:
                          const Icon(
                        Icons.search,
                      ),

                      filled: true,

                      fillColor:
                          Colors.white,

                      border:
                          OutlineInputBorder(

                        borderRadius:
                            BorderRadius.circular(
                          15,
                        ),

                        borderSide:
                            BorderSide.none,

                      ),

                    ),

                    onChanged: (value) {

                      setState(() {

                        _search = value;

                      });

                    },

                  ),

                ),

                Expanded(

                  child: bhajans.isEmpty

                      ? const Center(

                          child: Text(

                            "No Bhajans Found",

                          ),

                        )

                      : ListView.builder(

                          padding:
                              const EdgeInsets.only(
                            bottom: 100,
                          ),

                          itemCount:
                              bhajans.length,

                          itemBuilder:
                              (context, index) {

                            final bhajan =
                                bhajans[index];
                            return Card(

                              margin:
                                  const EdgeInsets.symmetric(

                                horizontal: 16,

                                vertical: 6,

                              ),

                              shape:
                                  RoundedRectangleBorder(

                                borderRadius:
                                    BorderRadius.circular(
                                  16,
                                ),

                              ),

                              child: ListTile(

                                leading:
                                    CircleAvatar(

                                  radius: 28,

                                  backgroundImage:
                                      bhajan.image
                                              .isNotEmpty
                                          ? NetworkImage(
                                              bhajan.image,
                                            )
                                          : null,

                                  child:
                                      bhajan.image.isEmpty

                                          ? const Icon(
                                              Icons.music_note,
                                            )

                                          : null,

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

                                subtitle: Column(

                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,

                                  children: [

                                    Text(

                                      bhajan.categoryId,

                                      style:
                                          GoogleFonts.poppins(

                                        fontSize: 12,

                                      ),

                                    ),

                                    const SizedBox(
                                      height: 4,
                                    ),

                                    Row(

                                      children: [

                                        Icon(

                                          bhajan.audioUrl
                                                  .isEmpty

                                              ? Icons.close

                                              : Icons.check_circle,

                                          size: 16,

                                          color: bhajan
                                                  .audioUrl
                                                  .isEmpty

                                              ? Colors.red

                                              : Colors.green,

                                        ),

                                        const SizedBox(
                                          width: 4,
                                        ),

                                        Text(

                                          bhajan.audioUrl
                                                  .isEmpty

                                              ? "No Audio"

                                              : "Audio Added",

                                          style:
                                              GoogleFonts.poppins(

                                            fontSize: 11,

                                          ),

                                        ),

                                      ],

                                    ),

                                  ],

                                ),

                                trailing: isSuperAdmin

                                    ? PopupMenuButton<String>(
                                  onSelected:
                                      (value) async {

                                    if (value ==
                                        "edit") {

                                      await Navigator.push(

                                        context,

                                        MaterialPageRoute(

                                          builder: (_) =>
                                              AddBhajanScreen(

                                            bhajan: bhajan,

                                          ),

                                        ),

                                      );

                                    }

                                    if (value ==
                                        "delete") {

                                      final confirm =
                                          await showDialog<bool>(

                                        context: context,

                                        builder: (_) =>
                                            AlertDialog(

                                          title: const Text(
                                            "Delete Bhajan",
                                          ),

                                          content: Text(
                                            "Are you sure you want to delete '${bhajan.title}' ?",
                                          ),

                                          actions: [

                                            TextButton(

                                              onPressed: () {

                                                Navigator.pop(
                                                  context,
                                                  false,
                                                );

                                              },

                                              child: const Text(
                                                "Cancel",
                                              ),

                                            ),

                                            ElevatedButton(

                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.red,
                                              ),

                                              onPressed: () {

                                                Navigator.pop(
                                                  context,
                                                  true,
                                                );

                                              },

                                              child: const Text(
                                                "Delete",
                                              ),

                                            ),

                                          ],

                                        ),

                                      );

                                      if (confirm ==
                                          true) {

                                        await provider
                                            .deleteBhajan(
                                          bhajan.id,
                                        );

                                      }

                                    }

                                  },

                                  itemBuilder:
                                      (context) => [

                                    const PopupMenuItem(

                                      value: "edit",

                                      child: Row(

                                        children: [

                                          Icon(
                                            Icons.edit,
                                          ),

                                          SizedBox(
                                            width: 10,
                                          ),

                                          Text(
                                            "Edit",
                                          ),

                                        ],

                                      ),

                                    ),

                                    const PopupMenuItem(

                                      value: "delete",

                                      child: Row(

                                        children: [

                                          Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),

                                          SizedBox(
                                            width: 10,
                                          ),

                                          Text(
                                            "Delete",
                                          ),

                                        ],

                                      ),

                                    ),

                                  ],

                                )

                                    : null,

                              ),

                            );

                          },

                        ),

                ),
                Padding(

                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),

                  child: Row(

                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,

                    children: [

                      Text(

                        "Total Bhajans : ${bhajans.length}",

                        style: GoogleFonts.poppins(

                          color: Colors.grey,

                          fontWeight: FontWeight.w500,

                        ),

                      ),

                      Container(

                        padding:
                            const EdgeInsets.symmetric(

                          horizontal: 12,

                          vertical: 6,

                        ),

                        decoration: BoxDecoration(

                          color: Colors.orange
                              .withValues(alpha: 0.12),

                          borderRadius:
                              BorderRadius.circular(20),

                        ),

                        child: Text(

                          "Active : ${bhajans.where((e) => e.status).length}",

                          style: GoogleFonts.poppins(

                            color: Colors.orange,

                            fontWeight: FontWeight.w600,

                            fontSize: 12,

                          ),

                        ),

                      ),

                    ],

                  ),

                ),

              ],

            ),

    );

  }

}