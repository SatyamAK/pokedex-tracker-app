class CaughtPokemon {
  late String pokemonName;
  late int trainerId;

  CaughtPokemon({required this.pokemonName, required this.trainerId});

  CaughtPokemon.fromMap(Map<String, dynamic> map) {
    pokemonName = map["POKEMON_NAME"];
    trainerId = map["TRAINER_ID"];
  }

  toMap() {
    var map =  <String, dynamic>{
      'POKEMON_NAME': pokemonName,
      'TRAINER_ID': trainerId
    };
    
    return map;
  }
}