import 'package:flutter/material.dart';
import 'package:pokedex_tracker/components/pokemon_card.dart';

class Pokedex extends StatelessWidget {
  final List<dynamic> pokemons;
  final String game;
  const Pokedex(this.pokemons, this.game, {super.key});

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(game),
      ),
      body: ListView.builder(
        itemCount: pokemons.length,
        itemBuilder: (context, index) => PokemonCard(pokemons.elementAt(index))
      ),
    );
  }
}