import 'package:flutter/material.dart';
import 'package:pokedex_tracker/pages/home_page.dart';
import 'package:pokedex_tracker/provider/pokemon_provider.dart';
import 'package:pokedex_tracker/provider/profile_provider.dart';
import 'package:pokedex_tracker/theme/light_theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
        ChangeNotifierProvider(create: (context) => PokemonProvider()),
      ],
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokedex Tracker',
      debugShowCheckedModeBanner: false,
      theme: lightTheme(context),
      home: const HomePage(),
    );
  }
}
