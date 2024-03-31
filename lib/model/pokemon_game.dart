import 'package:pokedex_tracker/model/pokemon.dart';

class PokemonGame {
  late String name;
  late List<Pokemon> pokemons;

  PokemonGame.fromMap(Map<String, dynamic> map) {
    name = map['game'];
    List<dynamic> pokemons = map['pokemon'];
    this.pokemons = pokemons.map((e) => Pokemon.fromMap(e)).toList();
  }
}