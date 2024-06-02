// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pokedex_tracker/constants/pokemon_games.dart';
import 'package:pokedex_tracker/database/database_helper.dart';
import 'package:pokedex_tracker/model/profile.dart';
import 'package:pokedex_tracker/provider/pokemon_provider.dart';
import 'package:pokedex_tracker/provider/profile_provider.dart';
import 'package:provider/provider.dart';

class AddProfile extends StatefulWidget {
  const AddProfile({super.key});
  
  @override 
  State<AddProfile> createState() => _AddProfileState();
}

class _AddProfileState extends State<AddProfile> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  late List<String> dropDownValues;
  late String selectedDropDownValue;

  String? _formValidtor(String? value) {
    return (value == "")? "The name cannot be blank" : null;
  }

  String? _dropDownValidation(String? value) {
    return (value == null)?"Please select the generation you are playing": null;
  }

  @override
  void initState() {
    dropDownValues = pokemonGamesJson.keys.toList();
    selectedDropDownValue = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Profile'),
      ),
      body: Center(
        child: Form(
          key: _key,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'Name'
                  ),
                  validator: _formValidtor,
                ),
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                    hintText: 'Select generation you are playing'
                  ),
                  items: dropDownValues.map((generation) => DropdownMenuItem(value: generation,child: Text(generation),)).toList(),
                  onChanged: (value) => setState(() {
                    selectedDropDownValue = value!;
                  }),
                  validator: _dropDownValidation,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (!_key.currentState!.validate()) return;
                      Profile profile = Profile(name: _nameController.text, generation: selectedDropDownValue);
                      profile.id = await DataBaseHelper.instance.addProfile(profile);
                      Provider.of<ProfileProvider>(context, listen: false).updateSelectedProfile(profile);
                      Provider.of<ProfileProvider>(context, listen: false).updateProfiles(profile);
                      await Provider.of<PokemonProvider>(context, listen: false).refreshCaughtPokemons(profile.id!);
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    child: const Text('Register')
                  ),
                )
              ],
            ),
          )
        ),
      ),
    );
  }
}