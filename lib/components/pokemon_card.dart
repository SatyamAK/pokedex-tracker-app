import 'package:flutter/material.dart';
import 'package:pokedex_tracker/constants/color.dart';
import 'package:pokedex_tracker/database/database_helper.dart';
import 'package:pokedex_tracker/model/pokemon.dart';
import 'package:pokedex_tracker/provider/caught_pokemon_provider.dart';
import 'package:pokedex_tracker/provider/profile_provider.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class PokemonCard extends StatelessWidget {

  Pokemon pokemon;

  PokemonCard({required this.pokemon, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        key: key,
        surfaceTintColor: typesColor[pokemon.types.first],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pokemon.id, style: Theme.of(context).textTheme.titleMedium),
                  Text(pokemon.name, style: Theme.of(context).textTheme.bodySmall),
                  SizedBox(
                    height: 24,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: pokemon.types.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Text(pokemon.types.elementAt(index), style: Theme.of(context).textTheme.titleMedium),
                      )
                    )
                  )
                ],
              ),
              // IconButton(onPressed: null, icon: const Icon(Icons.catching_pokemon_rounded, color: Colors.red,))
              Consumer<CaughtPokemonProvider>(
                builder: (context, caughtPokemonIdProvider, child) {
                  int activeProfileId = Provider.of<ProfileProvider>(context, listen: false).activeProfile.id!;
                  return FutureBuilder(
                    future: caughtPokemonIdProvider.getCaughtPokemons(activeProfileId),
                    builder: (context, snapshot) {
                      bool isCaught = caughtPokemonIdProvider.caughtPokemonIds.contains(pokemon.name);
                      return IconButton(
                        onPressed: () async {
                          if(isCaught) {
                            await DataBaseHelper.instance.removeCaughtPokemon(activeProfileId);
                            caughtPokemonIdProvider.removeCaughtPokemon(pokemon.name);
                            return;
                          }
                          await DataBaseHelper.instance.addCaughtPokemon(activeProfileId, pokemon.name);
                          caughtPokemonIdProvider.addCaughtPokemon(pokemon.name);
                        },
                        icon: (isCaught)?const Icon(Icons.catching_pokemon_rounded, color: Color(0xFF740800),)
                        : const Icon(Icons.catching_pokemon_sharp)
                      );
                    }
                  );
                }
              )
            ],
          ),
        )
      ),
    );
  }
}