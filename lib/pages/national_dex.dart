import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokedex_tracker/components/app_bar_with_search.dart';
import 'package:pokedex_tracker/components/pokemon_card.dart';
import 'package:pokedex_tracker/model/pokemon.dart';
import 'package:pokedex_tracker/provider/pokemon_provider.dart';
import 'package:provider/provider.dart';

class NationalDex extends StatelessWidget {
  final String selectedGeneration;
  const NationalDex({required this.selectedGeneration, super.key});

  Future<List<Pokemon>> _loadPokemons(BuildContext context) async {
    late List<Pokemon> pokemons = [];
    final String data = await rootBundle.loadString('data/pokedex.json');
    final Map<String, dynamic> requiredPokemonGenerationWise = await jsonDecode(data);
    for(var generation in requiredPokemonGenerationWise.keys) {
      requiredPokemonGenerationWise[generation].forEach((pokemon) => pokemons.add(Pokemon.fromMap(pokemon)));
    }

    if(!context.mounted) {
      return pokemons;
    }
    
    Provider.of<PokemonProvider>(context, listen: false).updatePokemons(pokemons);
    return pokemons;
  }

  @override 
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadPokemons(context),
      builder: (context, snapshot) {
        List<Pokemon> pokemonsFromSnapshot(){
          if(snapshot.hasData) return snapshot.data!;
          return [];
        }
        void filterPokemons(String value, BuildContext context) {
          if(value == "") {
            Provider.of<PokemonProvider>(context, listen: false).updatePokemons(pokemonsFromSnapshot());
          }
          Provider.of<PokemonProvider>(context, listen: false).updatePokemons(
            pokemonsFromSnapshot().where(
              (pokemon) => pokemon.name.toLowerCase().contains(value.toLowerCase())
            ).toList()
          );
        }
        return Scaffold(
          appBar: AppBarWithsearch(
            title: const Text('National Dex'),
            search: filterPokemons,
          ),
          body: (!snapshot.hasData)?const Center(child: CircularProgressIndicator(),):Consumer<PokemonProvider>(
            builder: (context, pokemonProvider, child) {
              return ListView.builder(
                itemCount: pokemonProvider.pokemons.length,
                itemBuilder: (context, index) => PokemonCard(pokemon: pokemonProvider.pokemons.elementAt(index))
              );
            }
          )
        );
      }
    );
  }
}