// 2415051088 - Made Wilasih
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'providers/movie_provider.dart';
import 'screens/main_navigation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Supabase Database
  await Supabase.initialize(
    url: 'https://ubjzycqclzatlgwirnbf.supabase.co',
    anonKey: 'sb_publishable_96XZvaIgKcMCLUCK6OM-jQ_af4a0bJA',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => MovieProvider())],
      child: MaterialApp(
        title: 'MovieExplorer UTS',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF121212),
          primaryColor: const Color(0xFFFFC107),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFFFC107),
            secondary: Color(0xFFFFC107),
          ),
          useMaterial3: true,
        ),
        home: const MainNavigation(),
      ),
    );
  }
}
