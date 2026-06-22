import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens/favorites/favorites_screen.dart';
import '../screens/recent/recently_played_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  Widget menuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.orange,
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        size: 18,
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xffFF9800),
                    Color(0xffFF6F00),
                  ],
                ),
              ),
              child: Column(
                children: [

                  const CircleAvatar(
                    radius: 38,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.music_note,
                      size: 42,
                      color: Colors.orange,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    "Kirtan App",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "Listen • Read • Download",
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                children: [

                  menuTile(
                    icon: Icons.home_rounded,
                    title: "Home",
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),

                  menuTile(
                    icon: Icons.favorite,
                    title: "Favorites",
                    onTap: () {

                      Navigator.pop(context);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const FavoritesScreen(),
                        ),
                      );

                    },
                  ),

                 menuTile(
  icon: Icons.history,
  title: "Recently Played",
  onTap: () {

    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const RecentlyPlayedScreen(),
      ),
    );

  },
),

                  menuTile(
                    icon: Icons.download,
                    title: "Downloads",
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),

                  menuTile(
                    icon: Icons.queue_music,
                    title: "Playlist",
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),

                  const Divider(),

                  menuTile(
                    icon: Icons.share,
                    title: "Share App",
                    onTap: () {},
                  ),

                  menuTile(
                    icon: Icons.star_rate,
                    title: "Rate App",
                    onTap: () {},
                  ),

                  menuTile(
                    icon: Icons.settings,
                    title: "Settings",
                    onTap: () {},
                  ),

                  menuTile(
                    icon: Icons.info_outline,
                    title: "About",
                    onTap: () {},
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "Version 1.0.0",
                style: GoogleFonts.poppins(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}