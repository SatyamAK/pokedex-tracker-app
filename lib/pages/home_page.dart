import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokedex_tracker/constants/pokemon_games.dart';
import 'package:pokedex_tracker/model/profile.dart';
import 'package:pokedex_tracker/model/pokemon_game.dart';
import 'package:pokedex_tracker/pages/add_profile.dart';
import 'package:pokedex_tracker/pages/national_dex.dart';
import 'package:pokedex_tracker/pages/pokedex.dart';
import 'package:pokedex_tracker/pages/profiles.dart';
import 'package:pokedex_tracker/provider/profile_provider.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokedex Tracker'),
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          return FutureBuilder(
            future: profileProvider.getActiveProfile(),
            builder: (context, snapshot) {
              switch(snapshot.connectionState) {
                case ConnectionState.waiting: return const Center(child: CircularProgressIndicator(),);
                default: return (profileProvider.activeProfile.id != null)?gamesView(profileProvider.activeProfile):Center(
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
          );
        }
      ),
      floatingActionButton: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) => 
        (profileProvider.activeProfile.id != null)?
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Profiles())
            ),
            icon: const Icon(Icons.person)
          )
        :const SizedBox(),
      )
    );
  }

  Widget gamesView(Profile profile) {
    return FutureBuilder(
      future: _loadGames(profile),
      builder: (context, snapshot) {
        bool isFirstGeneration = (profile.generation == "Generation 1");
        return (snapshot.hasData)?Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12.0, top: 8.0),
              child: Text('Welcome ${profile.name}'),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text('These are the games in ${profile.generation}', style: Theme.of(context).textTheme.bodySmall,),
            ),
            (isFirstGeneration)?const SizedBox():ListTile(
              title: const Text('National'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
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
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16,),
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