import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokedex_tracker/components/pokemon_card.dart';

class NationalDex extends StatelessWidget {
  final String selectedGeneration;
  const NationalDex(this.selectedGeneration, {super.key});


  Future<Map<String, dynamic>> _loadPokemons() async {
    final String data = await rootBundle.loadString('data/pokedex.json');
    final Map<String, dynamic> pokemonsGenerationWise = await jsonDecode(data);
    final Map<String, dynamic> requiredPokemonsGenerationWise = <String, dynamic>{};
    await Future.delayed(const Duration(seconds: 1));
    for(var generation in pokemonsGenerationWise.keys) {
      if(generation == selectedGeneration) {
        requiredPokemonsGenerationWise[generation] = pokemonsGenerationWise[generation];
        break;
      }
      requiredPokemonsGenerationWise[generation] = pokemonsGenerationWise[generation];
    }
    return requiredPokemonsGenerationWise;
  } 

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('National Dex'),
      ),
      body: nationalDex(context),
    );
  }

  Widget nationalDex(BuildContext context) {
    return FutureBuilder(
      future: _loadPokemons(),
      builder: (context, snapshot) => snapshot.hasData?SingleChildScrollView(
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: snapshot.data?.keys.length,
          itemBuilder: (context, index) {
            String generation = snapshot.data!.keys.elementAt(index);
            dynamic pokemons = snapshot.data![generation];
            return Column(
              children: [
                Text(generation),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: pokemons.length,
                  itemBuilder: (context, index) {
                    return PokemonCard(pokemons.elementAt(index));
                  }
                )
              ],
            );
          },
        )
      ):const Center( child: CircularProgressIndicator())
    );
  }
}