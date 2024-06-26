// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pokedex_tracker/constants/color.dart';
import 'package:pokedex_tracker/database/database_helper.dart';
import 'package:pokedex_tracker/pages/add_profile.dart';
import 'package:pokedex_tracker/provider/pokemon_provider.dart';
import 'package:pokedex_tracker/provider/profile_provider.dart';
import 'package:provider/provider.dart';

class Profiles extends StatelessWidget {
  const Profiles({super.key});

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profiles'),
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
        return FutureBuilder(
          future: profileProvider.getProfiles(),
          builder: (context, snapshot) {
            return (profileProvider.profiles.isNotEmpty)?ListView.builder(
              itemCount: profileProvider.profiles.length,
              itemBuilder: (context, index) {
                var selectedProfile = profileProvider.profiles.elementAt(index);
                return ListTile(
                  onTap: () async {
                    profileProvider.updateSelectedProfile(selectedProfile);
                    await Provider.of<PokemonProvider>(context, listen: false).refreshCaughtPokemons(selectedProfile.id!);
                    Navigator.pop(context);
                  },
                  title: Text(selectedProfile.name),
                  subtitle: Text(selectedProfile.generation),
                  trailing: IconButton(
                    icon: (selectedProfile.id == profileProvider.activeProfile.id)?
                    const Icon(Icons.person, color: unselectedTabColor,):const Icon(Icons.delete),
                    onPressed: () async {
                      if(profileProvider.activeProfile.id == selectedProfile.id){
                        return;
                      }
                      await DataBaseHelper.instance.deleteProfile(selectedProfile.id!);
                      profileProvider.removeProfile(selectedProfile);
                      if(profileProvider.profiles.isEmpty) Navigator.pop(context);
                    },
                  ),
                );
              }
            ):const Center(child: CircularProgressIndicator());
          }
        );
      }),
      floatingActionButton: IconButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddProfile())
        ),
        icon: const Icon(Icons.add)
      ),
    );
  }
}