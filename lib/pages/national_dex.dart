import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokedex_tracker/components/app_bar_with_search.dart';
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
  late Map<String, dynamic> _pokemonsGenerationWiseToBeRendered = <String, dynamic>{};
  int _activeTabIndex = 0;
  List<dynamic> _pokemonsTobeRendered = [];

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
      _pokemonsGenerationWiseToBeRendered = requiredPokemonsGenerationWise;
      _tabController = TabController(vsync: this, length: requiredPokemonsGenerationWise.length);
      _pokemonsTobeRendered = _pokemonsGenerationWiseToBeRendered['Generation 1'];
    });
    _tabController.addListener(() {
      setState(() {
        _activeTabIndex = _tabController.index;
        var selectedGeneration = _pokemonsGenerationWiseToBeRendered.keys.elementAt(_activeTabIndex);
        _pokemonsTobeRendered = _pokemonsGenerationWiseToBeRendered[selectedGeneration];
      });
    });
  }

  @override 
  void initState() {
    _loadPokemons();
    super.initState();
  }

  void filterPokemons(String value, BuildContext context) {
    var selectedGeneration = _pokemonsGenerationWiseToBeRendered.keys.elementAt(_activeTabIndex);
    if(value == "") {
      setState(() {
        _pokemonsTobeRendered = _pokemonsGenerationWiseToBeRendered[selectedGeneration];
      });
    }
    setState(() {
      _pokemonsTobeRendered = _pokemonsGenerationWiseToBeRendered[selectedGeneration].where(
        (pokemon) => pokemon["name"].toString().toLowerCase().contains(value.toLowerCase())
      ).toList();
    });
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithsearch(
        title: const Text('National Dex'),
        bottom: tabBar(),
        search: filterPokemons,
      ),
      body: body(),
    );
  }

  PreferredSizeWidget tabBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(32),
      child: (_pokemonsGenerationWiseToBeRendered.isEmpty)?const SizedBox():TabBar(
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        controller: _tabController,
        tabs: _pokemonsGenerationWiseToBeRendered.keys.map((generation) => Tab(child: Text(generation),)).toList()
      )
    );
  }

  Widget body() {
    return (_pokemonsGenerationWiseToBeRendered.isEmpty)?const Center( child: CircularProgressIndicator()):TabBarView(
      controller: _tabController,
      children: _pokemonsGenerationWiseToBeRendered.keys.map(
        (generation) {
          return pokemonsView();
        }
      ).toList()
    );
  }

  Widget pokemonsView() {
    return ListView.builder(
      itemCount: _pokemonsTobeRendered.length,
      itemBuilder: (context, index) => PokemonCard(pokemon: Pokemon.fromMap(_pokemonsTobeRendered.elementAt(index)))
    );
  }
}