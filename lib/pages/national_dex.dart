import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokedex_tracker/components/pokemon_card.dart';
import 'package:pokedex_tracker/model/pokemon.dart';

class NationalDex extends StatefulWidget {
  final String selectedGeneration;
  const NationalDex({required this.selectedGeneration, super.key});

  @override
  State<NationalDex> createState() => _NationalDexState();
}

class _NationalDexState extends State<NationalDex> with SingleTickerProviderStateMixin {
  late TabController _tabController = _tabController = TabController(vsync: this, length: 0);
  late Map<String, dynamic> pokemonsGenerationWiseToBeRendered = <String, dynamic>{};

  void _loadPokemons() async {
    final String data = await rootBundle.loadString('data/pokedex.json');
    final Map<String, dynamic> pokemonsGenerationWise = await jsonDecode(data);
    final Map<String, dynamic> requiredPokemonsGenerationWise = <String, dynamic>{};
    await Future.delayed(const Duration(seconds: 1));
    for(var generation in pokemonsGenerationWise.keys) {
      if(generation == widget.selectedGeneration) {
        requiredPokemonsGenerationWise[generation] = pokemonsGenerationWise[generation];
        break;
      }
      requiredPokemonsGenerationWise[generation] = pokemonsGenerationWise[generation];
    }
    setState(() {
      pokemonsGenerationWiseToBeRendered = requiredPokemonsGenerationWise;
      _tabController = TabController(vsync: this, length: requiredPokemonsGenerationWise.length);
    });
  }

  @override 
  void initState() {
    _loadPokemons();
    super.initState();
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('National Dex'),
        bottom: tabBar(),
      ),
      body: body(),
    );
  }

  PreferredSizeWidget tabBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(32),
      child: (pokemonsGenerationWiseToBeRendered.isEmpty)?const SizedBox():TabBar(
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        controller: _tabController,
        tabs: pokemonsGenerationWiseToBeRendered.keys.map((generation) => Tab(child: Text(generation),)).toList()
      )
    );
  }

  Widget body() {
    return (pokemonsGenerationWiseToBeRendered.isEmpty)?const Center( child: CircularProgressIndicator()):TabBarView(
      controller: _tabController,
      children: pokemonsGenerationWiseToBeRendered.keys.map(
        (generation) => pokemonsView(pokemonsGenerationWiseToBeRendered[generation])
      ).toList()
    );
  }

  Widget pokemonsView(List<dynamic> pokemons) {
    return ListView.builder(
      itemCount: pokemons.length,
      itemBuilder: (context, index) => PokemonCard(pokemon: Pokemon.fromMap(pokemons.elementAt(index)))
    );
  }
}