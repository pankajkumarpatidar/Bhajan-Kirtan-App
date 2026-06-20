import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/bhajan_model.dart';

class SearchTile extends StatelessWidget {
  final BhajanModel bhajan;
  final VoidCallback onTap;

  const SearchTile({
    super.key,
    required this.bhajan,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: bhajan.image.isEmpty
              ? Container(
                  width: 55,
                  height: 55,
                  color: Colors.orange.shade100,
                  child: const Icon(
                    Icons.music_note,
                    color: Colors.deepOrange,
                  ),
                )
              : Image.network(
                  bhajan.image,
                  width: 55,
                  height: 55,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Container(
                      width: 55,
                      height: 55,
                      color: Colors.orange.shade100,
                      child: const Icon(
                        Icons.music_note,
                        color: Colors.deepOrange,
                      ),
                    );
                  },
                ),
        ),
        title: Text(
          bhajan.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          bhajan.categoryId,
          style: GoogleFonts.poppins(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
        ),
        onTap: onTap,
      ),
    );
  }
}