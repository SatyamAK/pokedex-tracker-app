import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokedex_tracker/components/pokemon_card.dart';

class NationalDex extends StatelessWidget {
  const NationalDex({super.key});


  Future<Map<String, dynamic>> _loadPokemons() async {
    final String data = await rootBundle.loadString('data/pokedex.json');
    final Map<String, dynamic> pokemonsGenerationWise = await jsonDecode(data);
    return pokemonsGenerationWise;
  } 

  @override 
  Widget build(BuildContext context) {
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
              //mainAxisAlignment: MainAxisAlignment.start,
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
      ):const Center(child: Text('oops'),)
    );
  }
}