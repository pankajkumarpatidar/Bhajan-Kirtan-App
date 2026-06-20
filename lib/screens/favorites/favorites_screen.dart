import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/services/favorite_service.dart';
import '../../models/bhajan_model.dart';
import '../../repository/bhajan_repository.dart';
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
      BhajanRepository();

  List<BhajanModel> favoriteBhajans = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();

    loadFavorites();
  }

  Future<void> loadFavorites() async {

    loading = true;

    setState(() {});

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

    loading = false;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Favorites",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : favoriteBhajans.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [

                      const Icon(
                        Icons.favorite_border,
                        size: 90,
                        color: Colors.red,
                      ),

                      const SizedBox(height: 20),

                      Text(
                        "No Favorite Bhajans",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "अपने पसंदीदा भजन\nHeart दबाकर जोड़ें।",
                        textAlign: TextAlign.center,
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

                  itemCount:
                      favoriteBhajans.length,

                  itemBuilder:
                      (context, index) {

                    final bhajan =
                        favoriteBhajans[index];

                    return Card(
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

                      child: ListTile(

                        leading: CircleAvatar(
                          backgroundColor:
                              Colors.orange
                                  .shade100,

                          child: const Icon(
                            Icons.music_note,
                            color:
                                Colors.deepOrange,
                          ),
                        ),

                        title: Text(
                          bhajan.title,
                          style:
                              GoogleFonts.poppins(
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),

                        subtitle: Text(
                          bhajan.categoryId,
                        ),

                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                        ),

                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  LyricsScreen(
                                bhajan: bhajan,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
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
}