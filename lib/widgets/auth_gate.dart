import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../screens/home/home_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() =>
      _AuthGateState();
}

class _AuthGateState
    extends State<AuthGate> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {

      context
          .read<AuthProvider>()
          .initialize();

    });

  }

  @override
  Widget build(BuildContext context) {

    return Consumer<AuthProvider>(

      builder: (
        context,
        auth,
        child,
      ) {

        return const HomeScreen();

      },

    );

  }

}