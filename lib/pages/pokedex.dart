import 'package:flutter/material.dart';
import 'package:pokedex_tracker/components/pokemon_card.dart';
import 'package:pokedex_tracker/model/pokemon_game.dart';

class Pokedex extends StatelessWidget {
  final PokemonGame pokemonGame;
  const Pokedex({required this.pokemonGame, super.key});

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(pokemonGame.name),
      ),
      body: ListView.builder(
        itemCount: pokemonGame.pokemons.length,
        itemBuilder: (context, index) => PokemonCard(pokemon: pokemonGame.pokemons.elementAt(index))
      ),
    );
  }
}