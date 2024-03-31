import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokedex_tracker/constants/pokemon_games.dart';
import 'package:pokedex_tracker/database/database_helper.dart';
import 'package:pokedex_tracker/model/profile.dart';
import 'package:pokedex_tracker/model/pokemon_game.dart';
import 'package:pokedex_tracker/pages/add_profile.dart';
import 'package:pokedex_tracker/pages/national_dex.dart';
import 'package:pokedex_tracker/pages/pokedex.dart';
import 'package:pokedex_tracker/pages/profiles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<List<Map<String, dynamic>>?> _loadGames(Profile profile) async {
    List<Map<String, dynamic>> pokemonGamesWithPokemons = [];
    String generation = profile.generation;
    pokemonGamesJson[generation]?.forEach((element) async {
      final String data = await rootBundle.loadString(element);
      final Map<String, dynamic> pokemonGameJson = await jsonDecode(data);
      pokemonGamesWithPokemons.add(pokemonGameJson);
    });
    await Future.delayed(const Duration(seconds: 1));

    return pokemonGamesWithPokemons;
  }

  Future<Profile?> _loadProfile() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int? activeProfileId = sharedPreferences.getInt("activeProfileId");

    if(activeProfileId!.isNaN) return null;

    Profile activeProfile = await DataBaseHelper.instance.getActiveProfile(activeProfileId);
    return activeProfile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Pokedex Tracker'),
      ),
      body: FutureBuilder(
        future: _loadProfile(),
        builder: (context, snapshot) {
          switch(snapshot.connectionState) {
            case ConnectionState.waiting: return const Center(child: CircularProgressIndicator(),);
            default: return (snapshot.hasData)?gamesView(snapshot.data!):Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddProfile())
                    ),
                    icon: const Icon(Icons.add)
                  ),
                  const Text('Add a profile to continue')
                ],
              ),
            );
          }
        }
      ),
      floatingActionButton: IconButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Profiles())
        ),
        icon: const Icon(Icons.person)
      ),
    );
  }

  Widget gamesView(Profile profile) {
    return FutureBuilder(
      future: _loadGames(profile),
      builder: (context, snapshot) {
        return (snapshot.hasData)?Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12.0, top: 8.0),
              child: Text('Welcome ${profile.name}'),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text('These are the games in ${profile.generation}'),
            ),
            ListTile(
              title: const Text('National'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NationalDex(selectedGeneration: profile.generation))
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                List<Map<String, dynamic>>? gameWithPokemons = snapshot.data;
                return ListTile(
                  title: Text(gameWithPokemons!.elementAt(index)['game']),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Pokedex(pokemonGame: PokemonGame.fromMap(gameWithPokemons.elementAt(index)),))
                  )
                );
              }
            )
          ]
        ):const Center( child: CircularProgressIndicator());
      }
    );
  }
}