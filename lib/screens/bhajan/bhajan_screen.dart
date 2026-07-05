import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/bhajan_model.dart';
import '../../repository/bhajan_repository.dart';
import '../../widgets/favorite_button.dart';
import '../lyrics/lyrics_screen.dart';
import '../../widgets/app_scaffold.dart';
import '../../core/services/audio_service.dart';

class BhajanScreen extends StatelessWidget {
  final String categoryId;
  final String categoryName;

  const BhajanScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
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
        stream: BhajanRepository.instance.getBhajans(categoryId),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
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
              child: Text(
                "अभी कोई भजन उपलब्ध नहीं है",
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: bhajans.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final bhajan = bhajans[index];

              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(18),
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.all(14),

                  leading: CircleAvatar(
                    radius: 28,
                    backgroundColor:
                        Colors.orange.shade100,
                    child: const Icon(
                      Icons.music_note,
                      color: Colors.deepOrange,
                    ),
                  ),

                  title: Text(
                    bhajan.title,
                    style: GoogleFonts.poppins(
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),

                  subtitle: Text(
                    categoryName,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                    ),
                  ),

                  trailing: FavoriteButton(
                    bhajanId: bhajan.id,
                  ),

                  onTap: () {

  AudioService.instance.setPlaylist(
    bhajans,
    index,
  );

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