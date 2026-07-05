import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/services/favorite_service.dart';
import '../../models/bhajan_model.dart';
import '../../repository/bhajan_repository.dart';
import '../../widgets/search_tile.dart';
import '../lyrics/lyrics_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() =>
      _FavoritesScreenState();
}

class _FavoritesScreenState
    extends State<FavoritesScreen> {

  final BhajanRepository repository =
      BhajanRepository.instance;

  final TextEditingController
      searchController =
      TextEditingController();

  List<BhajanModel> favoriteBhajans = [];

  List<BhajanModel> filteredBhajans = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {

    setState(() {
      loading = true;
    });

    final ids =
        FavoriteService.getAllFavorites();

    final allBhajans =
        await repository.getAllBhajans();

    favoriteBhajans = allBhajans
        .where(
          (bhajan) =>
              ids.contains(bhajan.id),
        )
        .toList();

    filteredBhajans =
        List.from(favoriteBhajans);

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
            List.from(favoriteBhajans);
      });

      return;
    }

    final text =
        value.toLowerCase().trim();

    setState(() {

      filteredBhajans =
          favoriteBhajans.where((bhajan) {

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
          "Favorites",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: RefreshIndicator(

        onRefresh: loadFavorites,

        child: Column(

          children: [

            Padding(
              padding:
                  const EdgeInsets.fromLTRB(
                16,
                16,
                16,
                10,
              ),
              child: TextField(
                controller:
                    searchController,
                onChanged: search,
                decoration:
                    InputDecoration(
                  hintText:
                      "Favorite Bhajan खोजें...",

                  prefixIcon:
                      const Icon(
                    Icons.search,
                  ),

                  suffixIcon:
                      searchController
                              .text
                              .isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                searchController
                                    .clear();

                                search("");
                              },
                              icon:
                                  const Icon(
                                Icons.clear,
                              ),
                            )
                          : null,

                  filled: true,

                  fillColor:
                      Colors.white,

                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius
                            .circular(
                      16,
                    ),
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
                        MainAxisAlignment
                            .center,
                    children: [

                      const Icon(
                        Icons
                            .favorite_border,
                        color:
                            Colors.red,
                        size: 90,
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      Text(
                        "No Favorite Bhajans",
                        style:
                            GoogleFonts
                                .poppins(
                          fontSize: 21,
                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),

                      const SizedBox(
                        height: 8,
                      ),

                      Text(
                        "अपने पसंदीदा भजन\nHeart दबाकर जोड़ें।",
                        textAlign:
                            TextAlign
                                .center,
                        style:
                            GoogleFonts
                                .poppins(
                          color:
                              Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              )

            else

              Expanded(
                child:
                    ListView.builder(

                  physics:
                      const AlwaysScrollableScrollPhysics(),

                  padding:
                      const EdgeInsets
                          .all(16),

                  itemCount:
                      filteredBhajans
                          .length,
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
                        padding: const EdgeInsets.only(
                          right: 24,
                        ),
                        alignment:
                            Alignment.centerRight,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius:
                              BorderRadius.circular(18),
                        ),
                        child: const Icon(
                          Icons.delete_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),

                      onDismissed: (_) async {

                        await FavoriteService
                            .toggleFavorite(
                          bhajan.id,
                        );

                        await loadFavorites();

                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          SnackBar(
                            content: Text(
                              "${bhajan.title} Favorites से हटा दिया",
                            ),
                            duration:
                                const Duration(
                              seconds: 2,
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
                                  18),
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
                              loadFavorites();
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
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Future.delayed(
      const Duration(milliseconds: 300),
      () {
        if (mounted) {
          loadFavorites();
        }
      },
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}