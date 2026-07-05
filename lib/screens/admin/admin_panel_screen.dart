import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/services/auth_service.dart';
import '../../widgets/app_scaffold.dart';

import 'manage_bhajans_screen.dart';
import 'manage_categories_screen.dart';
import 'add_notification_screen.dart';

import 'profile_screen.dart';

class AdminPanelScreen extends StatelessWidget {

  const AdminPanelScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final bool isSuperAdmin =
        AuthService.instance.isSuperAdmin;

    return AppScaffold(

      backgroundColor:
          const Color(0xffF8F8F8),

      appBar: AppBar(

        centerTitle: true,

        title: Text(

          "Admin Panel",

          style: GoogleFonts.poppins(

            fontWeight:
                FontWeight.w600,

          ),

        ),

      ),

      body: ListView(

        padding:
            const EdgeInsets.all(20),

        children: [

          Text(

            "Management",

            style: GoogleFonts.poppins(

              fontSize: 24,

              fontWeight:
                  FontWeight.bold,

            ),

          ),

          const SizedBox(
            height: 20,
          ),

          Card(

            shape:
                RoundedRectangleBorder(

              borderRadius:
                  BorderRadius.circular(
                18,
              ),

            ),

            child: ListTile(

              leading:
                  const CircleAvatar(

                child: Icon(
                  Icons.menu_book,
                ),

              ),

              title: const Text(
                "Manage Bhajans",
              ),

              subtitle: const Text(
                "Add, Edit & Delete Bhajans",
              ),

              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 18,
              ),

              onTap: () {

                Navigator.push(

                  context,

                  MaterialPageRoute(

                    builder: (_) =>
                        const ManageBhajansScreen(),

                  ),

                );

              },

            ),

          ),

          const SizedBox(
            height: 15,
          ),

          Card(

            shape:
                RoundedRectangleBorder(

              borderRadius:
                  BorderRadius.circular(
                18,
              ),

            ),

            child: ListTile(

              leading:
                  const CircleAvatar(

                child: Icon(
                  Icons.category,
                ),

              ),

              title: const Text(
                "Manage Categories",
              ),

              subtitle: const Text(
                "Add, Edit &Delete Categories",
              ),

              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 18,
              ),

              onTap: () {

                Navigator.push(

                  context,

                  MaterialPageRoute(

                    builder: (_) =>
                        const ManageCategoriesScreen(),

                  ),

                );

              },

            ),

          ),
          

          const SizedBox(
  height: 15,
),

// 👇 यहाँ यह पूरा Code Paste करो
if (isSuperAdmin) ...[

  Card(

    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
    ),

    child: ListTile(

      leading: const CircleAvatar(
        backgroundColor: Color(0xffFFF3E0),
        child: Icon(
          Icons.notifications_active,
          color: Colors.deepOrange,
        ),
      ),

      title: const Text("Push Notification"),

      subtitle: const Text(
        "Send Notification to Users",
      ),

      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 18,
      ),

      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const AddNotificationScreen(),
          ),
        );
      },
    ),
  ),

  const SizedBox(height: 15),

],

// 👇 इसके बाद Profile Card रहेगा
Card(

  shape:
      RoundedRectangleBorder(

    borderRadius:
        BorderRadius.circular(
      18,
    ),

  ),

  child: ListTile(

    leading:
        const CircleAvatar(

      child: Icon(
        Icons.person,
      ),

              ),
              title: const Text(
                "Profile",
              ),

              subtitle: const Text(
                "Account Settings",
              ),

              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 18,
              ),

              onTap: () {

                Navigator.push(

                  context,

                  MaterialPageRoute(

                    builder: (_) =>
                        const ProfileScreen(),

                  ),

                );

              },

            ),

          ),

          const SizedBox(
            height: 30,
          ),

          Center(

            child: Column(

              children: [

                Text(

                  isSuperAdmin
                      ? "Logged in as Super Admin"
                      : "Logged in as Admin",

                  style: GoogleFonts.poppins(

                    fontWeight:
                        FontWeight.w600,

                    color: isSuperAdmin
                        ? Colors.deepPurple
                        : Colors.green,

                  ),

                ),

                const SizedBox(
                  height: 8,
                ),

                Text(

                  "Kirtan Admin Panel v1.0",

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

    );

  }

}