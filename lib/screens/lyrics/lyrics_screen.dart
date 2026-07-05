import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../core/services/audio_service.dart';
import '../../models/bhajan_model.dart';
import '../../widgets/add_to_playlist_sheet.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/favorite_button.dart';
import '../audio/audio_player_screen.dart';

class LyricsScreen extends StatefulWidget {

  final BhajanModel bhajan;

  const LyricsScreen({

    super.key,

    required this.bhajan,

  });

  @override
  State<LyricsScreen> createState() =>
      _LyricsScreenState();

}

class _LyricsScreenState
    extends State<LyricsScreen> {

  double fontSize = 22;

  bool touchLock = false;

  bool keepScreenOn = false;

  bool fullScreen = false;

  @override
  void dispose() {

    WakelockPlus.disable();

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );

    super.dispose();

  }

  void openSettings() {

    showModalBottomSheet(

      context: context,

      shape: const RoundedRectangleBorder(

        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),

      ),

      builder: (_) {

        return StatefulBuilder(

          builder: (context, setSheetState) {

            return SafeArea(

              child: Padding(

                padding: const EdgeInsets.all(20),

                child: Column(

                  mainAxisSize: MainAxisSize.min,

                  children: [

                    Text(

                      "Lyrics Settings",

                      style: GoogleFonts.poppins(

                        fontSize: 20,

                        fontWeight: FontWeight.bold,

                      ),

                    ),

                    const SizedBox(height: 20),

                    CheckboxListTile(

                      value: touchLock,

                      title: const Text(
                        "🔒 Touch Lock",
                      ),

                      onChanged: (value) {

                        setState(() {

                          touchLock = value!;

                        });

                        setSheetState(() {});

                      },

                    ),

                    CheckboxListTile(

                      value: keepScreenOn,

                      title: const Text(
                        "📱 Keep Screen On",
                      ),

                      onChanged: (value) async {

                        keepScreenOn = value!;

                        if (keepScreenOn) {

                          await WakelockPlus.enable();

                        } else {

                          await WakelockPlus.disable();

                        }

                        setState(() {});

                        setSheetState(() {});

                      },

                    ),

                    CheckboxListTile(

                      value: fullScreen,

                      title: const Text(
                        "⛶ Full Screen",
                      ),

                      onChanged: (value) async {

                        fullScreen = value!;

                        if (fullScreen) {

                          await SystemChrome.setEnabledSystemUIMode(
                            SystemUiMode.immersiveSticky,
                          );

                        } else {

                          await SystemChrome.setEnabledSystemUIMode(
                            SystemUiMode.edgeToEdge,
                          );

                        }

                        setState(() {});

                        setSheetState(() {});

                        Navigator.pop(context);

                      },

                    ),

                  ],

                ),

              ),

            );

          },

        );

      },

    );

  }

  @override
  Widget build(BuildContext context) {

    final lyrics =
        widget.bhajan.lyrics.isEmpty
            ? "इस भजन के बोल अभी उपलब्ध नहीं हैं।"
            : widget.bhajan.lyrics;

    final lines = lyrics.split("\n");

    return AppScaffold(

      backgroundColor: const Color(0xffF5F6FA),

      appBar: fullScreen
          ? null
          : AppBar(

              elevation: 0,

              backgroundColor: Colors.white,

              centerTitle: true,

              title: Text(

                widget.bhajan.title,

                maxLines: 1,

                overflow: TextOverflow.ellipsis,

                style: GoogleFonts.poppins(

                  color: Colors.black87,

                  fontWeight: FontWeight.w600,

                ),

              ),

              actions: [

                FavoriteButton(
                  bhajanId: widget.bhajan.id,
                ),

                IconButton(

                  icon: const Icon(
                    Icons.playlist_add,
                  ),

                  onPressed: () {

                    showModalBottomSheet(

                      context: context,

                      isScrollControlled: true,

                      shape: const RoundedRectangleBorder(

                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),

                      ),

                      builder: (_) => AddToPlaylistSheet(

                        bhajanId: widget.bhajan.id,

                      ),

                    );

                  },

                ),

                IconButton(

                  icon: const Icon(
                    Icons.settings,
                  ),

                  onPressed: openSettings,

                ),

              ],

            ),
      body: Stack(

        children: [

          Positioned.fill(

            child: IgnorePointer(

              ignoring: touchLock,

              child: Padding(

                padding: const EdgeInsets.fromLTRB(
                  16,
                  12,
                  16,
                  0,
                ),

                child: ClipRRect(

                  borderRadius:
                      BorderRadius.circular(26),

                  child: BackdropFilter(

                    filter: ImageFilter.blur(
                      sigmaX: 18,
                      sigmaY: 18,
                    ),

                    child: Container(

                      decoration: BoxDecoration(

                        color:
                            Colors.white.withOpacity(
                          0.72,
                        ),

                        borderRadius:
                            BorderRadius.circular(
                          26,
                        ),

                        border: Border.all(
                          color: Colors.white,
                          width: 1.2,
                        ),

                        boxShadow: [

                          BoxShadow(

                            color:
                                Colors.black.withOpacity(
                              .08,
                            ),

                            blurRadius: 20,

                            offset:
                                const Offset(0, 10),

                          ),

                        ],

                      ),

                      child: SingleChildScrollView(

                        padding:
                            const EdgeInsets.fromLTRB(
                          24,
                          26,
                          24,
                          80,
                        ),

                        child: Column(

                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .stretch,

                          children: [

                            if (fullScreen)

                              Align(

                                alignment:
                                    Alignment.centerLeft,

                                child: IconButton(

                                  icon: const Icon(
                                    Icons.arrow_back,
                                  ),

                                  onPressed: () async {

                                    setState(() {

                                      fullScreen = false;

                                    });

                                    await SystemChrome
                                        .setEnabledSystemUIMode(

                                      SystemUiMode
                                          .edgeToEdge,

                                    );

                                  },

                                ),

                              ),

                            const SizedBox(
                              height: 8,
                            ),

                            Center(

                              child: Icon(

                                Icons.menu_book_rounded,

                                size: 42,

                                color: Colors.orange,

                              ),

                            ),

                            const SizedBox(
                              height: 12,
                            ),

                            Center(

                              child: Text(

                                "भजन के बोल",

                                style:
                                    GoogleFonts.poppins(

                                  fontSize: 24,

                                  fontWeight:
                                      FontWeight.bold,

                                ),

                              ),

                            ),

                            const SizedBox(
                              height: 28,
                            ),

                            ...List.generate(

                              lines.length,

                              (index) {

                                final line =
                                    lines[index].trim();

                                if (line.isEmpty) {

                                  return const SizedBox(
                                    height: 18,
                                  );

                                }

                                final group =
                                    (index ~/ 2) % 4;

                                Color color;

                                switch (group) {

                                  case 0:

                                    color =
                                        Colors.red.shade700;

                                    break;

                                  case 1:

                                    color =
                                        Colors.blue.shade700;

                                    break;

                                  case 2:

                                    color =
                                        Colors.green.shade700;

                                    break;

                                  default:

                                    color =
                                        Colors.deepPurple.shade700;

                                }

                                return Padding(

                                  padding:
                                      const EdgeInsets.only(
                                    bottom: 12,
                                  ),

                                  child: SelectableText(

                                    line,

                                    textAlign:
                                        TextAlign.center,

                                    style:
                                        GoogleFonts.poppins(

                                      fontSize: fontSize,

                                      fontWeight:
                                          FontWeight.w600,

                                      height: 1.9,

                                      color: color,

                                    ),

                                  ),

                                );

                              },

                            ),

                          ],

                        ),

                      ),

                    ),

                  ),

                ),

              ),

            ),

          ),
          Positioned(

            left: 18,

            right: 18,

            bottom: 12,

            child: IgnorePointer(

              ignoring: touchLock,

              child: Row(

                crossAxisAlignment:
                    CrossAxisAlignment.end,

                children: [

                  Column(

                    mainAxisSize: MainAxisSize.min,

                    children: [

                      FloatingActionButton.small(

                        heroTag: "fontPlus",

                        backgroundColor:
                            Colors.orange,

                        elevation: 6,

                        onPressed: () {

                          if (fontSize < 40) {

                            setState(() {

                              fontSize++;

                            });

                          }

                        },

                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),

                      ),

                      const SizedBox(
                        height: 12,
                      ),

                      FloatingActionButton.small(

                        heroTag: "fontMinus",

                        backgroundColor:
                            Colors.orange,

                        elevation: 6,

                        onPressed: () {

                          if (fontSize > 16) {

                            setState(() {

                              fontSize--;

                            });

                          }

                        },

                        child: const Icon(
                          Icons.remove,
                          color: Colors.white,
                        ),

                      ),

                    ],

                  ),

                  const SizedBox(width: 16),

                  Expanded(

                    child: SizedBox(

                      height: 56,

                      child: FilledButton.icon(

                        style: FilledButton.styleFrom(

                          backgroundColor:
                              Colors.orange,

                          shape:
                              const StadiumBorder(),

                          elevation: 8,

                        ),

                        icon: const Icon(
                          Icons.play_arrow_rounded,
                        ),

                        label: const Text(
                          "भजन सुनें",
                        ),

                        onPressed: () async {

                          await AudioService.instance
                              .playBhajan(
                            widget.bhajan,
                          );

                          if (!mounted) return;

                          Navigator.push(

                            context,

                            MaterialPageRoute(

                              builder: (_) =>
                                  AudioPlayerScreen(

                                bhajan:
                                    widget.bhajan,

                              ),

                            ),

                          );

                        },

                      ),

                    ),

                  ),

                ],

              ),

            ),

          ),

          if (touchLock)

            Positioned.fill(

              child: Container(

                color: Colors.transparent,

                child: SafeArea(

                  child: Align(

                    alignment: Alignment.topRight,

                    child: Padding(

                      padding:
                          const EdgeInsets.all(16),

                      child: FloatingActionButton.small(

                        heroTag: "unlock",

                        backgroundColor:
                            Colors.orange,

                        onPressed: () {

                          setState(() {

                            touchLock = false;

                          });

                        },

                        child: const Icon(

                          Icons.lock_open,

                          color: Colors.white,

                        ),

                      ),

                    ),

                  ),

                ),

              ),

            ),

        ],

      ),

    );

  }

}