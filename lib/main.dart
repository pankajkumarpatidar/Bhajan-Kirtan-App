import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'core/services/favorite_service.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'providers/category_provider.dart';
import 'screens/home/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive Initialize
  await Hive.initFlutter();

  // Favorite Box Initialize
  await FavoriteService.init();

  // Firebase Initialize
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CategoryProvider(),
        ),
      ],
      child: const KirtanApp(),
    ),
  );
}

class KirtanApp extends StatelessWidget {
  const KirtanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kirtan App',

      theme: AppTheme.lightTheme,

      home: const HomeScreen(),
    );
  }
}