import 'package:flutter/material.dart';

import '../core/services/favorite_service.dart';

class FavoriteButton extends StatefulWidget {
  final String bhajanId;

  const FavoriteButton({
    super.key,
    required this.bhajanId,
  });

  @override
  State<FavoriteButton> createState() =>
      _FavoriteButtonState();
}

class _FavoriteButtonState
    extends State<FavoriteButton> {

  late bool isFavorite;

  @override
  void initState() {
    super.initState();

    isFavorite = FavoriteService.isFavorite(
      widget.bhajanId,
    );
  }

  Future<void> toggleFavorite() async {

    await FavoriteService.toggleFavorite(
      widget.bhajanId,
    );

    final fav = FavoriteService.isFavorite(
      widget.bhajanId,
    );

    if (!mounted) return;

    setState(() {
      isFavorite = fav;
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        content: Text(
          fav
              ? "❤️ Favorites में जोड़ दिया"
              : "🤍 Favorites से हटा दिया",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return AnimatedSwitcher(
      duration: const Duration(
        milliseconds: 250,
      ),

      child: IconButton(
        key: ValueKey(isFavorite),

        tooltip: isFavorite
            ? "Remove Favorite"
            : "Add Favorite",

        onPressed: toggleFavorite,

        icon: Icon(
          isFavorite
              ? Icons.favorite
              : Icons.favorite_border,

          color: Colors.red,
        ),
      ),
    );
  }
}