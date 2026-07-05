import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'edit_profile_screen.dart';
import '../../widgets/app_scaffold.dart';

class ProfileScreen extends StatefulWidget {

  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();

}

class _ProfileScreenState
    extends State<ProfileScreen> {

  final User? user =
      FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {

    return AppScaffold(

      backgroundColor:
          const Color(0xffF8F8F8),

      appBar: AppBar(

        centerTitle: true,

        title: Text(

          "Profile",

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

          const SizedBox(
            height: 10,
          ),

          Center(

            child: CircleAvatar(

              radius: 55,

              backgroundColor:
                  Colors.orange.shade100,

              child: Icon(

                Icons.person,

                color: Colors.orange,

                size: 60,

              ),

            ),

          ),

          const SizedBox(
            height: 20,
          ),

          Center(

            child: Text(

              user?.displayName?.isNotEmpty == true

                  ? user!.displayName!

                  : "Administrator",

              style: GoogleFonts.poppins(

                fontSize: 22,

                fontWeight:
                    FontWeight.bold,

              ),

            ),

          ),

          const SizedBox(
            height: 6,
          ),

          Center(

            child: Text(

              user?.email ?? "",

              style: GoogleFonts.poppins(

                color: Colors.grey.shade700,

                fontSize: 14,

              ),

            ),

          ),

          const SizedBox(
            height: 30,
          ),

          Card(

            shape:
                RoundedRectangleBorder(

              borderRadius:
                  BorderRadius.circular(
                16,
              ),

            ),

            child: Column(

              children: [
                ListTile(

                  leading: const Icon(
                    Icons.person_outline,
                    color: Colors.orange,
                  ),

                  title: const Text(
                    "Name",
                  ),

                  subtitle: Text(

                    user?.displayName?.isNotEmpty == true

                        ? user!.displayName!

                        : "Administrator",

                  ),

                ),

                const Divider(height: 1),

                ListTile(

                  leading: const Icon(
                    Icons.email_outlined,
                    color: Colors.orange,
                  ),

                  title: const Text(
                    "Email",
                  ),

                  subtitle: Text(
                    user?.email ?? "-",
                  ),

                ),

                const Divider(height: 1),

                ListTile(

                  leading: const Icon(
                    Icons.badge_outlined,
                    color: Colors.orange,
                  ),

                  title: const Text(
                    "UID",
                  ),

                  subtitle: Text(

                    user?.uid ?? "-",

                    maxLines: 2,

                    overflow:
                        TextOverflow.ellipsis,

                  ),

                ),

                const Divider(height: 1),

                const ListTile(

                  leading: Icon(
                    Icons.security,
                    color: Colors.orange,
                  ),

                  title: Text(
                    "Role",
                  ),

                  subtitle: Text(
                    "Super Admin",
                  ),

                ),

                const Divider(height: 1),

                ListTile(

                  leading: const Icon(
                    Icons.phone_android,
                    color: Colors.orange,
                  ),

                  title: const Text(
                    "Phone",
                  ),

                  subtitle: Text(

                    (user?.phoneNumber?.isNotEmpty ??
                            false)

                        ? user!.phoneNumber!

                        : "Not Added",

                  ),

                ),

              ],

            ),

          ),

          const SizedBox(
            height: 24,
          ),
          SizedBox(

            width: double.infinity,

            child: OutlinedButton.icon(

              icon: const Icon(
                Icons.edit,
              ),

              label: const Text(
                "Edit Profile",
              ),

              style: OutlinedButton.styleFrom(

                minimumSize:
                    const Size.fromHeight(50),

                shape:
                    RoundedRectangleBorder(

                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),

                ),

              ),

              onPressed: () async {

  await Navigator.push(

    context,

    MaterialPageRoute(

      builder: (_) =>
          const EditProfileScreen(),

    ),

  );

  if (!mounted) return;

  setState(() {});

},

            ),

          ),

          const SizedBox(
            height: 12,
          ),

          SizedBox(

            width: double.infinity,

            child: ElevatedButton.icon(

              icon: const Icon(
                Icons.lock_reset,
              ),

              label: const Text(
                "Change Password",
              ),

              style:
                  ElevatedButton.styleFrom(

                minimumSize:
                    const Size.fromHeight(50),

                backgroundColor:
                    Colors.orange,

                foregroundColor:
                    Colors.white,

                shape:
                    RoundedRectangleBorder(

                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),

                ),

              ),

              onPressed: () async {

                if (user?.email == null) {
                  return;
                }

                await FirebaseAuth.instance
                    .sendPasswordResetEmail(

                  email: user!.email!,

                );

                if (!mounted) return;

                ScaffoldMessenger.of(context)
                    .showSnackBar(

                  const SnackBar(

                    content: Text(
                      "Password reset email sent successfully.",
                    ),

                  ),

                );

              },

            ),

          ),

          const SizedBox(
            height: 12,
          ),

          SizedBox(

            width: double.infinity,

            child: ElevatedButton.icon(

              icon: const Icon(
                Icons.logout,
              ),

              label: const Text(
                "Logout",
              ),

              style:
                  ElevatedButton.styleFrom(

                minimumSize:
                    const Size.fromHeight(50),

                backgroundColor:
                    Colors.red,

                foregroundColor:
                    Colors.white,

                shape:
                    RoundedRectangleBorder(

                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),

                ),

              ),

              onPressed: () async {

                final confirm =
                    await showDialog<bool>(

                  context: context,

                  builder: (_) => AlertDialog(

                    title: const Text(
                      "Logout",
                    ),

                    content: const Text(
                      "Are you sure you want to logout?",
                    ),

                    actions: [

                      TextButton(

                        onPressed: () {

                          Navigator.pop(
                            context,
                            false,
                          );

                        },

                        child: const Text(
                          "Cancel",
                        ),

                      ),

                      ElevatedButton(

                        onPressed: () {

                          Navigator.pop(
                            context,
                            true,
                          );

                        },

                        child: const Text(
                          "Logout",
                        ),

                      ),

                    ],

                  ),

                );

                if (confirm != true) {
                  return;
                }

                await FirebaseAuth.instance
                    .signOut();

                if (!mounted) return;

                Navigator.of(context)
                    .popUntil(
                  (route) => route.isFirst,
                );

              },

            ),

          ),

          const SizedBox(
            height: 30,
          ),
        ],

      ),

    );

  }

}