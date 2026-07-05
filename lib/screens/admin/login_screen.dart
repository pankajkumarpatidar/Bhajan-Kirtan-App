import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/app_scaffold.dart';
import 'admin_panel_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {

  final formKey =
      GlobalKey<FormState>();

  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  bool obscure = true;

  bool loading = false;

  final auth =
      FirebaseAuth.instance;

  Future<void> login() async {

    if (!formKey.currentState!
        .validate()) {
      return;
    }

    try {

      setState(() {
        loading = true;
      });

      await auth
          .signInWithEmailAndPassword(

        email:
            emailController.text
                .trim(),

        password:
            passwordController.text
                .trim(),

      );

      if (!mounted) return;

      Navigator.pushReplacement(

        context,

        MaterialPageRoute(

          builder: (_) =>
              const AdminPanelScreen(),

        ),

      );

    } on FirebaseAuthException catch (e) {

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          content: Text(
            e.message ??
                "Login Failed",
          ),

        ),

      );

    } finally {

      if (mounted) {

        setState(() {
          loading = false;
        });

      }

    }

  }

  @override
  Widget build(BuildContext context) {

    return AppScaffold(

      backgroundColor:
          const Color(0xffF8F8F8),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Admin Login",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(

              key: formKey,

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment.stretch,

                children: [

                  Center(
                    child: Image.asset(
                      "assets/images/logo.png",
                      height: 120,
                    ),
                  ),

                  const SizedBox(height: 25),

                  Text(
                    "Welcome Admin",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Login to continue",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 35),

                  TextFormField(

                    controller:
                        emailController,

                    keyboardType:
                        TextInputType
                            .emailAddress,

                    decoration:
                        const InputDecoration(

                      labelText:
                          "Email",

                      prefixIcon:
                          Icon(Icons.email),

                    ),

                    validator: (value) {

                      if (value == null ||
                          value
                              .trim()
                              .isEmpty) {

                        return "Enter Email";

                      }

                      return null;

                    },

                  ),

                  const SizedBox(height: 20),

                  TextFormField(

                    controller:
                        passwordController,

                    obscureText:
                        obscure,
                    decoration: InputDecoration(

                      labelText: "Password",

                      prefixIcon: const Icon(
                        Icons.lock,
                      ),

                      suffixIcon: IconButton(

                        onPressed: () {

                          setState(() {

                            obscure = !obscure;

                          });

                        },

                        icon: Icon(

                          obscure
                              ? Icons.visibility
                              : Icons.visibility_off,

                        ),

                      ),

                    ),

                    validator: (value) {

                      if (value == null ||
                          value.isEmpty) {

                        return "Enter Password";

                      }

                      if (value.length < 6) {

                        return "Minimum 6 Characters";

                      }

                      return null;

                    },

                  ),

                  const SizedBox(height: 35),

                  SizedBox(

                    height: 55,

                    child: FilledButton(

                      onPressed:
                          loading
                              ? null
                              : login,

                      child: loading

                          ? const SizedBox(

                              height: 24,

                              width: 24,

                              child:
                                  CircularProgressIndicator(

                                strokeWidth: 2.5,

                                color: Colors.white,

                              ),

                            )

                          : Text(

                              "LOGIN",

                              style:
                                  GoogleFonts.poppins(

                                fontSize: 16,

                                fontWeight:
                                    FontWeight.bold,

                              ),

                            ),

                    ),

                  ),

                  const SizedBox(height: 20),

                  TextButton(

                    onPressed: () {

                      // Forgot Password
                    },

                    child: const Text(
                      "Forgot Password ?",
                    ),

                  ),
                  const SizedBox(height: 30),

                  Center(
                    child: Text(
                      "Kirtan App v1.0.0",
                      style: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ),

                ],

              ),

            ),

          ),

        ),

      ),

    );

  }

  @override
  void dispose() {

    emailController.dispose();

    passwordController.dispose();

    super.dispose();

  }

}