import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';


import 'core/services/audio_service.dart';
import 'core/services/bhajan_cache_service.dart';
import 'core/services/favorite_service.dart';
import 'core/services/playlist_service.dart';
import 'core/services/recent_service.dart';
import 'core/theme/app_theme.dart';

import 'firebase_options.dart';

import 'providers/auth_provider.dart';
import 'providers/bhajan_provider.dart';
import 'providers/category_provider.dart';
import 'providers/notification_provider.dart';


import 'widgets/auth_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);



await FavoriteService.init();
await BhajanCacheService.init();
await RecentService.init();
await PlaylistService.init();

  runApp(
    MultiProvider(
      providers: [

        ChangeNotifierProvider(
          create: (_) => AuthProvider()..initialize(),
        ),

        ChangeNotifierProvider(
          create: (_) => CategoryProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => BhajanProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => NotificationProvider(),
        ),
        
        ChangeNotifierProvider<AudioService>(
          create: (_) {
            final service = AudioService.instance;
            service.initialize();
            return service;
          },
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
      title: "Kirtan App",
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.system,
      home: const AuthGate(),
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