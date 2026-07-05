import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/app_scaffold.dart';

class EditProfileScreen extends StatefulWidget {

  const EditProfileScreen({
    super.key,
  });

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();

}

class _EditProfileScreenState
    extends State<EditProfileScreen> {

  final _formKey =
      GlobalKey<FormState>();

  final User? _user =
      FirebaseAuth.instance.currentUser;

  final _nameController =
      TextEditingController();

  final _mobileController =
      TextEditingController();

  String _role = "Admin";

  bool _loading = true;

  @override
  void initState() {

    super.initState();

    loadProfile();

  }

  Future<void> loadProfile() async {

    if (_user == null) {

      setState(() {
        _loading = false;
      });

      return;

    }

    try {

      final doc =
          await FirebaseFirestore.instance
              .collection("admins")
              .doc(_user.uid)
              .get();

      if (doc.exists) {

        final data = doc.data()!;

        _nameController.text =
            data["name"] ?? "";

        _mobileController.text =
            data["mobile"] ?? "";

        _role =
            data["role"] == "superadmin"
                ? "Super Admin"
                : "Admin";

      }

    } catch (_) {}

    if (mounted) {

      setState(() {

        _loading = false;

      });

    }

  }

  @override
  Widget build(BuildContext context) {

    if (_loading) {

      return const Scaffold(

        body: Center(

          child:
              CircularProgressIndicator(),

        ),

      );

    }

    return AppScaffold(

      backgroundColor:
          const Color(0xffF8F8F8),

      appBar: AppBar(

        centerTitle: true,

        title: Text(

          "Edit Profile",

          style: GoogleFonts.poppins(

            fontWeight:
                FontWeight.w600,

          ),

        ),

      ),

      body: Form(

        key: _formKey,

        child: ListView(

          padding:
              const EdgeInsets.all(20),

          children: [
            TextFormField(

              controller: _nameController,

              decoration: const InputDecoration(

                labelText: "Full Name",

                prefixIcon: Icon(
                  Icons.person,
                ),

                border: OutlineInputBorder(),

              ),

              validator: (value) {

                if (value == null ||
                    value.trim().isEmpty) {

                  return "Please enter your name";

                }

                return null;

              },

            ),

            const SizedBox(height: 16),

            TextFormField(

              controller: _mobileController,

              keyboardType:
                  TextInputType.phone,

              decoration: const InputDecoration(

                labelText: "Mobile Number",

                prefixIcon: Icon(
                  Icons.phone,
                ),

                border: OutlineInputBorder(),

              ),

              validator: (value) {

                if (value != null &&
                    value.isNotEmpty &&
                    value.length != 10) {

                  return "Enter valid mobile number";

                }

                return null;

              },

            ),

            const SizedBox(height: 16),

            TextFormField(

              initialValue:
                  _user?.email ?? "",

              enabled: false,

              decoration: const InputDecoration(

                labelText: "Email",

                prefixIcon: Icon(
                  Icons.email,
                ),

                border: OutlineInputBorder(),

              ),

            ),

            const SizedBox(height: 16),

            TextFormField(

              initialValue: _role,

              enabled: false,

              decoration: const InputDecoration(

                labelText: "Role",

                prefixIcon: Icon(
                  Icons.admin_panel_settings,
                ),

                border: OutlineInputBorder(),

              ),

            ),

            const SizedBox(height: 30),

            SizedBox(

              width: double.infinity,

              height: 55,

              child: ElevatedButton.icon(

                onPressed:
                    _loading
                        ? null
                        : saveProfile,

                style:
                    ElevatedButton.styleFrom(

                  backgroundColor:
                      Colors.orange,

                  foregroundColor:
                      Colors.white,

                  shape:
                      RoundedRectangleBorder(

                    borderRadius:
                        BorderRadius.circular(
                      14,
                    ),

                  ),

                ),

                icon:
                    _loading

                        ? const SizedBox(

                            width: 22,

                            height: 22,

                            child:
                                CircularProgressIndicator(

                              strokeWidth: 2,

                              color: Colors.white,

                            ),

                          )

                        : const Icon(
                            Icons.save,
                          ),

                label: Text(

                  "Save Changes",

                  style:
                      GoogleFonts.poppins(

                    fontSize: 16,

                    fontWeight:
                        FontWeight.w600,

                  ),

                ),

              ),

            ),

            const SizedBox(
              height: 30,
            ),
          ],

        ),

      ),

    );

  }

  Future<void> saveProfile() async {

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_user == null) {
      return;
    }

    setState(() {
      _loading = true;
    });

    try {

      await FirebaseFirestore.instance
          .collection("admins")
          .doc(_user.uid)
          .update({

        "name":
            _nameController.text.trim(),

        "mobile":
            _mobileController.text.trim(),

      });

      await _user.updateDisplayName(
        _nameController.text.trim(),
      );

      await _user.reload();

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content: Text(
            "Profile updated successfully.",
          ),

        ),

      );

      Navigator.pop(context);

    } catch (e) {

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          content: Text(
            e.toString(),
          ),

        ),

      );

    } finally {

      if (mounted) {

        setState(() {

          _loading = false;

        });

      }

    }

  }

  @override
  void dispose() {

    _nameController.dispose();

    _mobileController.dispose();

    super.dispose();

  }

}