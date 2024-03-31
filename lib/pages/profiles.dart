import 'package:flutter/material.dart';
import 'package:pokedex_tracker/database/database_helper.dart';
import 'package:pokedex_tracker/pages/add_profile.dart';

class Profiles extends StatelessWidget {
  Profiles({super.key});

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Profiles'),
      ),
      body: FutureBuilder(
        future: DataBaseHelper.instance.getProfiles(),
        builder: (context, snapshot) {
          return (snapshot.hasData)?ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () => {

                },
                title: Text(snapshot.data!.elementAt(index).name),
                subtitle: Text(snapshot.data!.elementAt(index).generation),
              );
            }
          ):const CircularProgressIndicator();
        }
      ),
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