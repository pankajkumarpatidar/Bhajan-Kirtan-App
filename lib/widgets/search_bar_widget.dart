import 'package:flutter/material.dart';

import '../screens/search/search_screen.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 15,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const SearchScreen(),
            ),
          );
        },
        child: IgnorePointer(
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),

                const Icon(
                  Icons.search,
                  color: Colors.orange,
                ),

                const SizedBox(width: 10),

                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "भजन खोजें...",
                      border: InputBorder.none,
                    ),
                  ),
                ),

                IconButton(
                  onPressed: null,
                  icon: const Icon(
                    Icons.mic_none_rounded,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}