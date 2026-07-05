import 'package:flutter/material.dart';

import 'mini_player.dart';

class AppScaffold extends StatelessWidget {

  final PreferredSizeWidget? appBar;

  final Widget body;

  final Widget? drawer;

  final Widget? floatingActionButton;

  final bool showMiniPlayer;

  final FloatingActionButtonLocation?
      floatingActionButtonLocation;

  final Color? backgroundColor;

  const AppScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.drawer,
    this.floatingActionButton,
    this.showMiniPlayer = true,
    this.floatingActionButtonLocation,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          backgroundColor,

      appBar: appBar,

      drawer: drawer,

      floatingActionButton:
          floatingActionButton,

      floatingActionButtonLocation:
          floatingActionButtonLocation,

      body: Column(

        children: [

          Expanded(
            child: body,
          ),

          showMiniPlayer
    ? const MiniPlayer()
    : const SizedBox(),

        ],

      ),

    );

  }

}