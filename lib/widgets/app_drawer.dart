import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

import '../screens/admin/admin_panel_screen.dart';
import '../screens/admin/login_screen.dart';

import '../screens/favorites/favorites_screen.dart';
import '../screens/playlist/playlist_screen.dart';
import '../screens/recent/recently_played_screen.dart';
import '../screens/about/about_screen.dart';
import 'package:share_plus/share_plus.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
  });

  Widget menuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.orange,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: color,
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

    final auth =
        context.watch<AuthProvider>();

    return Drawer(

      child: SafeArea(

        child: Column(

          children: [

            Container(

              width: double.infinity,

              padding:
                  const EdgeInsets.all(24),

              decoration:
                  const BoxDecoration(

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

                    backgroundColor:
                        Colors.white,

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

                      fontWeight:
                          FontWeight.bold,

                    ),

                  ),

                  const SizedBox(height: 4),

                  Text(

                    "श्री बालाजी सुंदरकाण्ड मित्र मण्डल,सकरानी जागीर द्वारा संचालित",

                    style: GoogleFonts.poppins(

                      color: Colors.white,

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
                    icon: Icons.queue_music,
                    title: "Playlist",
                    onTap: () {

                      Navigator.pop(context);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const PlaylistScreen(),
                        ),
                      );

                    },
                  ),

                  const Divider(),

                  if (!auth.isLoggedIn)

                    menuTile(
                      icon: Icons.login,
                      title: "Admin Login",
                      onTap: () {

                        Navigator.pop(context);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const LoginScreen(),
                          ),
                        );

                      },
                    ),

                  if (auth.isLoggedIn) ...[

                    menuTile(
                      icon: Icons.admin_panel_settings,
                      title: "Admin Panel",
                      onTap: () {

                        Navigator.pop(context);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const AdminPanelScreen(),
                          ),
                        );

                      },
                    ),

                    menuTile(
                      icon: Icons.logout,
                      color: Colors.red,
                      title: "Logout",
                      onTap: () async {

                        Navigator.pop(context);

                        await auth.logout();

                      },
                    ),

                  ],

                  const Divider(),
                  menuTile(
  icon: Icons.share,
  title: "Share App",
  onTap: () {

    Navigator.pop(context);

    SharePlus.instance.share(
      ShareParams(
        text:
            "🙏 Kirtan App\n\n"
            "भजन, कीर्तन, आरती, सुंदरकाण्ड और अन्य आध्यात्मिक सामग्री का सुंदर संग्रह।\n\n"
            "डाउनलोड करें:\n"
            "https://drive.google.com/uc?export=download&id=107QieeTczawM9ZktFUZ4lrYAQjdTY4Pv\n\n"
            "🙏 जय श्री राम 🙏",
      ),
    );

  },
),


                  menuTile(
  icon: Icons.info_outline,
  title: "About",
  onTap: () {

    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AboutScreen(),
      ),
    );

  },
),

                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [

                  Text(
                    "Kirtan App",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: Colors.orange,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "Version 1.0.0",
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}