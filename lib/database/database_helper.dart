import 'package:pokedex_tracker/model/caught_pokemon.dart';
import 'package:pokedex_tracker/model/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBaseHelper {
  static final DataBaseHelper instance = DataBaseHelper._init();
  DataBaseHelper._init();
  static Database? _profilesDatabase;
  static Database? _pokemonDatabase;
  static const String _profileDbName = 'ProfilesDB';
  static const String _profilesTableName = 'Profiles';
  static const String _pokemonDbName = 'PokemonDB';
  static const String _pokemonTableName = 'Pokemons';

  Future<Database> get  profilesDb async {
    if(_profilesDatabase != null) {
      return _profilesDatabase!;
    }

    _profilesDatabase = await initProfilesDb();
    return _profilesDatabase!;
  }

  Future<Database> get pokemonDb async {
    if(_pokemonDatabase != null){
      return _pokemonDatabase!;
    }

    _pokemonDatabase = await initPokemonDb();
    return _pokemonDatabase!;
  }

  initProfilesDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _profileDbName);

    return await openDatabase(path, version: 1, onCreate: _createProfileDB);
  }

  initPokemonDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _pokemonDbName);

    return await openDatabase(path, version: 1, onCreate: _createPokemonsDB);
  }

  Future _createProfileDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_profilesTableName(
        ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        NAME TEXT NOT NULL,
        GENERATION TEXT NOT NULL
        )
    ''');
  }

  Future _createPokemonsDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_pokemonTableName(
        ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        POKEMON_NAME TEXT NOT NULL,
        TRAINER_ID INTEGER NOT NULL
        )
    ''');
  }

  Future<Profile> getActiveProfile(int id) async {
    final profilesDatabase = await profilesDb;
    final activeProfileMap = await profilesDatabase.query(_profilesTableName, where: "ID = ?", whereArgs: [id]);
    return Profile.fromMap(activeProfileMap.first);
  }

  Future<List<Profile>> getProfiles() async {
    final profilesDatabase = await profilesDb;
    final profilesMap = await profilesDatabase.query(_profilesTableName);
    return profilesMap.map((profileMap) => Profile.fromMap(profileMap)).toList();
  }

  Future<int> addProfile(Profile profile) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final profilesDatabase = await profilesDb;
    final newlyAddedId = await profilesDatabase.insert(_profilesTableName, profile.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    sharedPreferences.setInt("activeProfileId", newlyAddedId);
    return newlyAddedId;
  }

  Future<void> deleteProfile(int id) async {
    final profilesDatabase = await profilesDb;
    await profilesDatabase.delete(_profilesTableName, where: "ID = ?", whereArgs: [id]);
  }

  Future<Set<String>> getCaughtPokemon(int trainerId) async {
    final pokemonDatabase = await pokemonDb;
    final caughtPokemonsMap = await pokemonDatabase.query(_pokemonTableName, where: "TRAINER_ID = ?", whereArgs: [trainerId]);
    return caughtPokemonsMap.map((caughtPokemonMap) => CaughtPokemon.fromMap(caughtPokemonMap).pokemonName).toSet();
  }

  Future<void> addCaughtPokemon(int trainerId, String pokemonName) async{
    final pokemonDatabase = await pokemonDb;
    await pokemonDatabase.insert(_pokemonTableName, CaughtPokemon(pokemonName: pokemonName, trainerId: trainerId).toMap());
  }

  Future<void> removeCaughtPokemon(int trainerId) async {
    final pokemonDatabase = await pokemonDb;
    await pokemonDatabase.delete(_pokemonTableName, where: "TRAINER_ID = ?", whereArgs: [trainerId]);
  }
}