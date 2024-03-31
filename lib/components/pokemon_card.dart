import 'package:flutter/material.dart';
import 'package:pokedex_tracker/model/pokemon.dart';

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
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pokemon.id),
                  Text(pokemon.name),
                  SizedBox(
                    height: 24,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: pokemon.types.length,
                      itemBuilder: (context, index) => Padding(padding: const EdgeInsets.only(right: 4), child: Text(pokemon.types.elementAt(index)),)
                    )
                  )
                ],
              ),
              const IconButton(onPressed: null, icon: Icon(Icons.catching_pokemon_rounded))
            ],
          ),
        )
      ),
    );
  }
}