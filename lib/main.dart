import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'core/services/bhajan_cache_service.dart';
import 'core/services/favorite_service.dart';
import 'core/services/recent_service.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'providers/category_provider.dart';
import 'screens/home/home_screen.dart';
import 'core/services/playlist_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive
  await Hive.initFlutter();

  // Local Storage
  await FavoriteService.init();
  await BhajanCacheService.init();
  await RecentService.init();
  await PlaylistService.init();
  
  // Firebase
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

      themeMode: ThemeMode.system,

      home: const HomeScreen(),

      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(1.0),
          ),
          child: child!,
        );
      },
    );
  }
}