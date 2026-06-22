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
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const SearchScreen(),
            ),
          );
        },
        child: Container(
          height: 58,
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [

              const Icon(
                Icons.search_rounded,
                color: Colors.orange,
                size: 28,
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Text(
                  "भजन खोजें...",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 16,
                  ),
                ),
              ),

              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.mic_none_rounded,
                  color: Colors.deepOrange,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}