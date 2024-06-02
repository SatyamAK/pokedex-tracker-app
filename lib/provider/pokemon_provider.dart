import 'package:flutter/material.dart';
import 'package:pokedex_tracker/database/database_helper.dart';
import 'package:pokedex_tracker/model/pokemon.dart';

class PokemonProvider extends ChangeNotifier {
  Set<String> _caughtPokemons = <String>{};
  List<Pokemon> _pokemons = [];

  Future<void> getCaughtPokemons(int activeProfileId) async {
    if(_caughtPokemons.isNotEmpty) {
      return;
    }

    _caughtPokemons = await DataBaseHelper.instance.getCaughtPokemon(activeProfileId);
    notifyListeners();
  }

  Future<void> refreshCaughtPokemons(int activeProfileId) async {
    _caughtPokemons = {};
    await getCaughtPokemons(activeProfileId);
  }

  void addCaughtPokemon(pokemonName) {
    _caughtPokemons.add(pokemonName);
    notifyListeners();
  }

  void removeCaughtPokemon(pokemonName) {
    _caughtPokemons.remove(pokemonName);
    notifyListeners();
  }

  void updatePokemons(List<Pokemon> pokemons) {
    _pokemons = pokemons;
    notifyListeners();
  }

  Set<String> get caughtPokemonIds => _caughtPokemons;
  List<Pokemon> get pokemons => _pokemons;
}