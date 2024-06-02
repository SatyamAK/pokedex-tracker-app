import 'package:flutter/material.dart';
import 'package:pokedex_tracker/components/app_bar_with_search.dart';
import 'package:pokedex_tracker/components/pokemon_card.dart';
import 'package:pokedex_tracker/model/pokemon_game.dart';
import 'package:pokedex_tracker/provider/pokemon_provider.dart';
import 'package:provider/provider.dart';

class Pokedex extends StatelessWidget {
  final PokemonGame pokemonGame;
  const Pokedex({required this.pokemonGame, super.key});

  void filterPokemons(String value, BuildContext context) {
    if(value == "") {
      Provider.of<PokemonProvider>(context, listen: false).updatePokemons(pokemonGame.pokemons);
    }
    Provider.of<PokemonProvider>(context, listen: false).updatePokemons(
      pokemonGame.pokemons.where(
        (pokemon) => pokemon.name.toLowerCase().contains(value.toLowerCase())
      ).toList()
    );
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithsearch(
        title: Text(pokemonGame.name),
        search: filterPokemons,
      ),
      body: Consumer<PokemonProvider>(
        builder: (context, pokemonProvider, child) {
          return  ListView.builder(
            itemCount: pokemonProvider.pokemons.length,
            itemBuilder: (context, index) => PokemonCard(pokemon: pokemonProvider.pokemons.elementAt(index))
          );
        }
      )
    );
  }
}