import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/bhajan_model.dart';
import '../../repository/bhajan_repository.dart';
import '../../repository/search_repository.dart';
import '../../widgets/search_tile.dart';
import '../lyrics/lyrics_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  final TextEditingController controller =
      TextEditingController();

  List<BhajanModel> allBhajans = [];

  List<BhajanModel> filteredBhajans = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();

    loadBhajans();
  }

  Future<void> loadBhajans() async {
  final repository = BhajanRepository.instance;

  allBhajans =
      await repository.getAllBhajans();

  debugPrint(
      "Loaded : ${allBhajans.length}");

  filteredBhajans = allBhajans;

  if (mounted) {
    setState(() {
      loading = false;
    });
  }
}

  void search(String value) {

    setState(() {

      filteredBhajans =
          SearchRepository.search(
        allBhajans,
        value,
      );

    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: Text(
          "Search Bhajan",
          style: GoogleFonts.poppins(),
        ),

      ),

      body: Column(

        children: [

          Padding(

            padding: const EdgeInsets.all(16),

            child: TextField(

              controller: controller,

              onChanged: search,

              decoration: InputDecoration(

                hintText: "Search Bhajan...",
prefixIcon: const Icon(Icons.search),

                suffixIcon: controller.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          controller.clear();

                          setState(() {
                            filteredBhajans = allBhajans;
                          });
                        },
                        icon: const Icon(Icons.clear),
                      )
                    : null,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),

          if (loading)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (filteredBhajans.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  "कोई भजन नहीं मिला",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: filteredBhajans.length,
                itemBuilder: (context, index) {
                  final bhajan = filteredBhajans[index];

                  return SearchTile(
                    bhajan: bhajan,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LyricsScreen(
                            bhajan: bhajan,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}