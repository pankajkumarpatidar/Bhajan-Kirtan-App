import 'package:flutter/material.dart';

import '../../widgets/app_drawer.dart';
import '../../widgets/category_card.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/search_bar_widget.dart';
import '../../widgets/section_title.dart';
import '../../widgets/quick_action_card.dart';

import '../bhajan/bhajan_screen.dart';
import '../favorites/favorites_screen.dart';
import '../recent/recently_played_screen.dart';
import '../playlist/playlist_screen.dart';
import '../../widgets/app_scaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<Map<String, dynamic>> categories = [

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

  ];

  @override
  Widget build(BuildContext context) {

    return AppScaffold(

      drawer: const AppDrawer(),

      backgroundColor: const Color(0xffF7F8FC),

      body: SafeArea(

        child: CustomScrollView(

          physics: const BouncingScrollPhysics(),

          slivers: [
/// Premium App Bar
            const SliverToBoxAdapter(
              child: CustomAppBar(),
            ),

            /// Search
            const SliverToBoxAdapter(
              child: SearchBarWidget(),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 20),
            ),

            /// Featured Banner
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Container(
                  height: 210, // Overflow Fixed
                  width: double.infinity,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xffFF9800),
                        Color(0xffFF6F00),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withValues(alpha: 0.35),
                        blurRadius: 22,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(22),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,

                      children: [

                        const Icon(
                          Icons.auto_awesome,
                          color: Colors.white,
                          size: 34,
                        ),

                        const Text(
                          "🌸 आज का विशेष भजन",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const Text(
                          "राधे राधे जपो चले आएंगे बिहारी",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: FilledButton.icon(
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.orange,
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: () {
                              // TODO Today's Bhajan
                            },
                            icon: const Icon(
                              Icons.play_arrow_rounded,
                            ),
                            label: const Text(
                              "अभी सुनें",
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
                      title: "Favorites",
                      subtitle: "Your Bhajans",
                      color: Colors.red,
                      onTap: () {
                     Navigator.push(
                       context,
                     MaterialPageRoute(
                    builder: (_) => const FavoritesScreen(),
                   ),
                  );
                  },
                 ),

                    QuickActionCard(
                     icon: Icons.history,
                      title: "Recent",
                       subtitle: "Recently Played",
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
                      icon: Icons.download_rounded,
                      title: "Downloads",
                      subtitle: "Offline Music",
                      color: Colors.green,
                      onTap: () {
                        // TODO Downloads Screen
                      },
                    ),

                    QuickActionCard(
  icon: Icons.queue_music,
  title: "Playlist",
  subtitle: "My Playlist",
  color: Colors.green,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const PlaylistScreen(),
      ),
    );
  },
),

                  ],
                ),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.18,
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 30),
            ),

            const SliverToBoxAdapter(
              child: SectionTitle(
                title: "भजन श्रेणियाँ",
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 18),
            ),
/// Categories Grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final category = categories[index];

                    return TweenAnimationBuilder<double>(
                      duration: Duration(
                        milliseconds: 250 + (index * 100),
                      ),
                      tween: Tween(
                        begin: 0,
                        end: 1,
                      ),
                      curve: Curves.easeOutBack,
                      builder: (
                        context,
                        value,
                        child,
                      ) {
                        return Transform.scale(
                          scale: value,
                          child: Opacity(
                            opacity: value,
                            child: child,
                          ),
                        );
                      },
                      child: CategoryCard(
                        title: category["title"] as String,
                        image: category["image"] as String,
                        color: category["color"] as Color,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BhajanScreen(
                                categoryId:
                                    category["id"] as String,
                                categoryName:
                                    category["title"] as String,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  childCount: categories.length,
                ),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18,
                  childAspectRatio: 0.90,
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 35),
            ),

            /// Footer
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: 0.05,
                        ),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [

                      Icon(
                        Icons.music_note_rounded,
                        size: 42,
                        color: Colors.orange.shade700,
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        "Kirtan App",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "Listen • Read • Download",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "Version 1.0.0",
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
],
        ),
      ),

      
    );
  }
}