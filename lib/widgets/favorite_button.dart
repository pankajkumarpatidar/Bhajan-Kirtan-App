import 'package:flutter/material.dart';

import '../core/services/favorite_service.dart';

class FavoriteButton extends StatefulWidget {
  final String bhajanId;

  const FavoriteButton({
    super.key,
    required this.bhajanId,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = FavoriteService.isFavorite(widget.bhajanId);
  }

  Future<void> toggleFavorite() async {
    await FavoriteService.toggleFavorite(widget.bhajanId);

    setState(() {
      isFavorite = FavoriteService.isFavorite(widget.bhajanId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: toggleFavorite,
      icon: Icon(
        isFavorite
            ? Icons.favorite
            : Icons.favorite_border,
        color: Colors.red,
      ),
    );
  }
}