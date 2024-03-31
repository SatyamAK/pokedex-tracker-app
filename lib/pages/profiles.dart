// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pokedex_tracker/database/database_helper.dart';
import 'package:pokedex_tracker/pages/add_profile.dart';
import 'package:pokedex_tracker/provider/profile_provider.dart';
import 'package:provider/provider.dart';

class Profiles extends StatelessWidget {
  const Profiles({super.key});

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
                return ListTile(
                  onTap: () => {

                  },
                  title: Text(profileProvider.profiles.elementAt(index).name),
                  subtitle: Text(profileProvider.profiles.elementAt(index).generation),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await DataBaseHelper.instance.deleteProfile(profileProvider.profiles.elementAt(index).id!);
                      profileProvider.removeProfile(profileProvider.profiles.elementAt(index));
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