import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokedex_tracker/constants/pokemon_games.dart';
import 'package:pokedex_tracker/model/pokemon_game.dart';
import 'package:pokedex_tracker/pages/national_dex.dart';
import 'package:pokedex_tracker/pages/pokedex.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<List<Map<String, dynamic>>?> _loadGames() async {
    List<Map<String, dynamic>> pokemonGamesWithPokemons = [];
    String generation = 'Generation 9';
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
    _loadGames();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Pokedex Tracker'),
      ),
      body: FutureBuilder(
        future: _loadGames(),
        builder: (context, snapshot) {
          return (snapshot.hasData)?Column(
            children: [
              ListTile(
                title: const Text('National'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NationalDex(selectedGeneration: 'Generation 9'))
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
      )
    );
  }
}