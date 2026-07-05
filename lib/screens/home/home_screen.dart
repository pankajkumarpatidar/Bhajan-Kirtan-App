import 'dart:math';
import 'package:flutter/material.dart';

import '../../core/services/audio_service.dart';
import '../../models/bhajan_model.dart';
import '../../repository/bhajan_repository.dart';

import '../../widgets/app_drawer.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/category_card.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/quick_action_card.dart';
import '../../widgets/search_bar_widget.dart';
import '../../widgets/section_title.dart';

import '../bhajan/bhajan_screen.dart';
import '../favorites/favorites_screen.dart';
import '../playlist/playlist_screen.dart';
import '../recent/recently_played_screen.dart';
import '../audio/audio_player_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen> {

  BhajanModel? todaysBhajan;

  bool loadingToday = true;

  List<BhajanModel> allBhajans = [];

  static const List<Map<String, dynamic>>
      categories = [

    {
      "id": "radha_krishna",
      "title": "राधा कृष्ण",
      "image": "radha.png",
      "color": Color(0xffFF9800),
    },

    {
      "id": "shree_ram",
      "title": "श्री राम",
      "image": "ram.png",
      "color": Color(0xffE53935),
    },

    {
      "id": "hanuman",
      "title": "हनुमान",
      "image": "hanuman.png",
      "color": Color(0xffFF7043),
    },

    {
      "id": "shiv",
      "title": "शिव",
      "image": "shiv.png",
      "color": Color(0xff5E35B1),
    },

    {
      "id": "ganesh",
      "title": "गणेश",
      "image": "ganesh.png",
      "color": Color(0xffFB8C00),
    },

    {
      "id": "khatu_shyam",
      "title": "खाटू श्याम",
      "image": "khatu.png",
      "color": Color(0xff8E24AA),
    },

    {
      "id": "navdurga",
      "title": "नवदुर्गा",
      "image": "durga.png",
      "color": Color(0xffD81B60),
    },

    {
      "id": "aarti",
      "title": "आरती संग्रह",
      "image": "aarti.png",
      "color": Color(0xff00897B),
    },

    {
      "id": "manbhavan_kirtan",
      "title": "मनभावन कीर्तन",
      "image": "manbhavan.png",
      "color": Color.fromARGB(255, 24, 197, 219),
    },

    {
      "id": "sanwaliya_seth",
      "title": "सांवलिया सेठ",
      "image": "sanwliya.png",
      "color": Color.fromARGB(255, 224, 24, 181),
    },

  ];

  @override
  void initState() {
    super.initState();

    loadTodayBhajan();
  }
  Future<void> loadTodayBhajan() async {

    final repository = BhajanRepository.instance;

    allBhajans =
        await repository.getAllBhajans();

    if (allBhajans.isEmpty) {

      if (mounted) {

        setState(() {
          loadingToday = false;
        });

      }

      return;

    }

    final today = DateTime.now();

    final random = Random(
      today.year +
          today.month +
          today.day,
    );

    todaysBhajan = allBhajans[
        random.nextInt(
      allBhajans.length,
    )];

    if (mounted) {

      setState(() {
        loadingToday = false;
      });

    }

  }

  Future<void> playTodayBhajan() async {

  if (todaysBhajan == null) return;

  final index = allBhajans.indexWhere(
    (e) => e.id == todaysBhajan!.id,
  );

  AudioService.instance.setPlaylist(
    allBhajans,
    index < 0 ? 0 : index,
  );

  await AudioService.instance.playBhajan(
    todaysBhajan!,
  );

  if (!mounted) return;

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => AudioPlayerScreen(
        bhajan: todaysBhajan!,
      ),
    ),
  );

}

  @override
  Widget build(BuildContext context) {

    return AppScaffold(

      drawer: const AppDrawer(),

      backgroundColor: Colors.white,

      body: SafeArea(

        child: CustomScrollView(

          physics:
              const BouncingScrollPhysics(),

          slivers: [
            /// Premium App Bar
            const SliverToBoxAdapter(
              child: CustomAppBar(),
            ),

            /// Search Bar
            const SliverToBoxAdapter(
              child: SearchBarWidget(),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 22),
            ),

            /// Today's Featured Bhajan
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Container(
                  height: 195,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(26),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xffFFB74D),
                        Color(0xffFB8C00),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withValues(
                          alpha: 0.18,
                        ),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(22),
                    child: loadingToday
                        ? const Center(
                            child:
                                CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [

                              Row(
                                children: [

                                  const Icon(
                                    Icons.auto_awesome,
                                    color: Colors.white,
                                    size: 18,
                                  ),

                                  const SizedBox(width: 8),

                                  Text(
                                    "आज का विशेष भजन",
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.95,
                                      ),
                                      fontSize: 15,
                                      fontWeight:
                                          FontWeight.w600,
                                    ),
                                  ),

                                ],
                              ),

                              Text(
                                todaysBhajan?.title ??
                                    "भजन उपलब्ध नहीं",
                                maxLines: 2,
                                overflow:
                                    TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight:
                                      FontWeight.bold,
                                  height: 1.25,
                                ),
                              ),

                              const Text(
                                "भक्ति में मन को शांति मिले",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),

                              Align(
  alignment: Alignment.centerLeft,
  child: FilledButton.icon(
    onPressed: loadingToday ? null : playTodayBhajan,
    icon: const Icon(Icons.play_arrow_rounded),
    label: const Text("अभी सुनें"),
    style: FilledButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: const Color(0xffFB8C00),
      elevation: 0,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 12,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    ),
  ),
),
                            ],
                          ),
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 28),
            ),

            /// Quick Actions
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              sliver: SliverGrid(
                delegate: SliverChildListDelegate(
                  [

                    QuickActionCard(
                      icon: Icons.favorite_rounded,
                      title: "Favorite",
                      subtitle: "",
                      color: Colors.redAccent,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const FavoritesScreen(),
                          ),
                        );
                      },
                    ),

                    QuickActionCard(
                      icon: Icons.history_rounded,
                      title: "Recent",
                      subtitle: "",
                      color: Colors.orange,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const RecentlyPlayedScreen(),
                          ),
                        );
                      },
                    ),

                    QuickActionCard(
                      icon: Icons.queue_music_rounded,
                      title: "Playlist",
                      subtitle: "",
                      color: Colors.green,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const PlaylistScreen(),
                          ),
                        );
                      },
                    ),

                  ],
                ),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.92,
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 34),
            ),
            /// Categories Title
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    const SectionTitle(
                      title: "भजन श्रेणियाँ",
                    ),

                    const SizedBox(height: 8),

                    Container(
                      width: 28,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xffFB8C00),
                        borderRadius:
                            BorderRadius.circular(50),
                      ),
                    ),

                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 22),
            ),

            /// Categories Grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              sliver: SliverGrid(
                delegate:
                    SliverChildBuilderDelegate(
                  (context, index) {

                    final category =
                        categories[index];

                    return TweenAnimationBuilder<double>(
                      duration: Duration(
                        milliseconds:
                            180 + (index * 50),
                      ),
                      tween: Tween(
                        begin: 0.97,
                        end: 1,
                      ),
                      curve: Curves.easeOut,
                      builder: (
                        context,
                        value,
                        child,
                      ) {

                        return Transform.scale(
                          scale: value,
                          child: child,
                        );

                      },
                      child: CategoryCard(
                        title:
                            category["title"]
                                as String,
                        image:
                            category["image"]
                                as String,
                        color:
                            category["color"]
                                as Color,
                        onTap: () {

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  BhajanScreen(
                                categoryId:
                                    category["id"]
                                        as String,
                                categoryName:
                                    category["title"]
                                        as String,
                              ),
                            ),
                          );

                        },
                      ),
                    );

                  },
                  childCount:
                      categories.length,
                ),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.88,
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 50),
            ),
            /// Footer
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 40,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 22,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(22),
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: 0.04,
                        ),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [

                      Icon(
                        Icons.music_note_rounded,
                        size: 34,
                        color: Colors.orange.shade700,
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        "Kirtan App",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff212121),
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        "Developed by Pankaj Patidar- 9340066006",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 90),
            ),

          ],
        ),
      ),
    );
  }
}