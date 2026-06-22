import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/services/recent_service.dart';
import '../../models/bhajan_model.dart';
import '../../repository/bhajan_repository.dart';
import '../../widgets/search_tile.dart';
import '../lyrics/lyrics_screen.dart';

class RecentlyPlayedScreen extends StatefulWidget {
  const RecentlyPlayedScreen({super.key});

  @override
  State<RecentlyPlayedScreen> createState() =>
      _RecentlyPlayedScreenState();
}

class _RecentlyPlayedScreenState
    extends State<RecentlyPlayedScreen> {

  final BhajanRepository repository =
      BhajanRepository();

  final TextEditingController
      searchController =
      TextEditingController();

  List<BhajanModel> recentBhajans = [];

  List<BhajanModel> filteredBhajans = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadRecent();
  }

  Future<void> loadRecent() async {

    setState(() {
      loading = true;
    });

    final ids =
        RecentService.getRecentIds();

    final allBhajans =
        await repository.getAllBhajans();

    recentBhajans = [];

    for (final id in ids) {

      try {

        final bhajan =
            allBhajans.firstWhere(
          (e) => e.id == id,
        );

        recentBhajans.add(bhajan);

      } catch (_) {}

    }

    filteredBhajans =
        List.from(recentBhajans);

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  void search(String value) {

    if (value.trim().isEmpty) {

      setState(() {
        filteredBhajans =
            List.from(recentBhajans);
      });

      return;
    }

    final text =
        value.toLowerCase().trim();

    setState(() {

      filteredBhajans =
          recentBhajans.where((bhajan) {

        return bhajan.title
                .toLowerCase()
                .contains(text) ||
            bhajan.lyrics
                .toLowerCase()
                .contains(text) ||
            bhajan.categoryId
                .toLowerCase()
                .contains(text);

      }).toList();

    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xffF7F8FC),

      appBar: AppBar(

        centerTitle: true,

        title: Text(
          "Recently Played",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),

      ),

      body: RefreshIndicator(

        onRefresh: loadRecent,

        child: Column(

          children: [

            Padding(

              padding:
                  const EdgeInsets.all(16),

              child: TextField(

                controller:
                    searchController,

                onChanged: search,

                decoration:
                    InputDecoration(

                  hintText:
                      "Search...",

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
                            16),

                    borderSide:
                        BorderSide.none,

                  ),

                ),

              ),

            ),

            if (loading)

              const Expanded(

                child: Center(

                  child:
                      CircularProgressIndicator(),

                ),

              )

            else if (filteredBhajans
                .isEmpty)

              Expanded(

                child: Center(

                  child: Column(

                    mainAxisAlignment:
                        MainAxisAlignment.center,

                    children: [

                      const Icon(
                        Icons.history,
                        size: 90,
                        color: Colors.orange,
                      ),

                      const SizedBox(
                          height: 20),

                      Text(
                        "No Recently Played",
                        style:
                            GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                          height: 8),

                      Text(
                        "Play any bhajan to\nsee it here.",
                        textAlign:
                            TextAlign.center,
                        style:
                            GoogleFonts.poppins(
                          color: Colors.grey,
                        ),
                      ),

                    ],

                  ),

                ),

              )

            else

              Expanded(

                child: ListView.builder(

                  padding:
                      const EdgeInsets.all(
                          16),

                  itemCount:
                      filteredBhajans.length,
itemBuilder: (context, index) {

                    final bhajan =
                        filteredBhajans[index];

                    return Dismissible(

                      key: Key(bhajan.id),

                      direction:
                          DismissDirection.endToStart,

                      background: Container(

                        margin: const EdgeInsets.only(
                          bottom: 14,
                        ),

                        padding:
                            const EdgeInsets.only(
                          right: 24,
                        ),

                        alignment:
                            Alignment.centerRight,

                        decoration: BoxDecoration(

                          color: Colors.red,

                          borderRadius:
                              BorderRadius.circular(
                            18,
                          ),

                        ),

                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 30,
                        ),

                      ),

                      onDismissed: (_) async {

                        await RecentService.removeRecent(
                          bhajan.id,
                        );

                        await loadRecent();

                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context)
                            .showSnackBar(

                          SnackBar(

                            content: Text(
                              "${bhajan.title} हटा दिया",
                            ),

                          ),

                        );

                      },

                      child: Card(

                        elevation: 2,

                        margin:
                            const EdgeInsets.only(
                          bottom: 14,
                        ),

                        shape:
                            RoundedRectangleBorder(

                          borderRadius:
                              BorderRadius.circular(
                            18,
                          ),

                        ),

                        child: SearchTile(

                          bhajan: bhajan,

                          onTap: () {

                            Navigator.push(

                              context,

                              MaterialPageRoute(

                                builder: (_) =>
                                    LyricsScreen(
                                  bhajan: bhajan,
                                ),

                              ),

                            ).then((_) {

                              loadRecent();

                            });

                          },

                        ),

                      ),

                    );

                  },

                ),

              ),

          ],

        ),

      ),

      floatingActionButton:
          filteredBhajans.isEmpty
              ? null
              : FloatingActionButton.extended(

                  backgroundColor: Colors.red,

                  icon: const Icon(
                    Icons.delete_forever,
                  ),

                  label: const Text(
                    "Clear All",
                  ),

                  onPressed: () async {

                    await RecentService.clear();

                    await loadRecent();

                  },

                ),

    );

  }

  @override
  void dispose() {

    searchController.dispose();

    super.dispose();

  }

}