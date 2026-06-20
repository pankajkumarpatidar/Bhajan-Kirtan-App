import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/bhajan_model.dart';
import '../../repository/bhajan_repository.dart';
import '../lyrics/lyrics_screen.dart';

class CategoryScreen extends StatelessWidget {
  final String categoryId;
  final String categoryName;

  const CategoryScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),

      appBar: AppBar(
        centerTitle: true,
        title: Text(
          categoryName,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: StreamBuilder<List<BhajanModel>>(
        stream: BhajanRepository().getBhajans(categoryId),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          final bhajans = snapshot.data ?? [];

          if (bhajans.isEmpty) {
            return const Center(
              child: Text("अभी कोई भजन उपलब्ध नहीं है"),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bhajans.length,
            itemBuilder: (context, index) {

              final bhajan = bhajans[index];

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),

                child: ListTile(
                  contentPadding: const EdgeInsets.all(15),

                  leading: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.orange.shade100,
                    child: const Icon(
                      Icons.music_note,
                      color: Colors.deepOrange,
                    ),
                  ),

                  title: Text(
                    bhajan.title,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),

                  subtitle: Text(categoryName),
trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                  ),

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
                ),
              );
            },
          );
        },
      ),
    );
  }
}