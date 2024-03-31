import 'package:flutter/material.dart';
import 'package:pokedex_tracker/database/database_helper.dart';

class CaughtPokemonProvider extends ChangeNotifier {
  Set<String> _caughtPokemons = <String>{};

  Future<void> getCaughtPokemons(int activeProfileId) async {
    if(_caughtPokemons.isNotEmpty) {
      return;
    }

    _caughtPokemons = await DataBaseHelper.instance.getCaughtPokemon(activeProfileId);
    notifyListeners();
  }

  void addCaughtPokemon(pokemonName) {
    _caughtPokemons.add(pokemonName);
    notifyListeners();
  }

  void removeCaughtPokemon(pokemonName) {
    _caughtPokemons.remove(pokemonName);
    notifyListeners();
  }

  Set<String> get caughtPokemonIds => _caughtPokemons;
}