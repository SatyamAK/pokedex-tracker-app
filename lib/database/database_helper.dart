import 'package:pokedex_tracker/model/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBaseHelper {
  static final DataBaseHelper instance = DataBaseHelper._init();
  DataBaseHelper._init();
  static Database? _profilesDatabase;
  static const String _profileDbName = 'ProfilesDB';
  static const String _profilesTableName = 'Profiles';

  Future<Database> get  profilesDb async {
    if(_profilesDatabase != null) {
      return _profilesDatabase!;
    }

    _profilesDatabase = await initProfilesDb();
    return _profilesDatabase!;
  }

  initProfilesDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _profileDbName);

    return await openDatabase(path, version: 1, onCreate: _createProfileDB);
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
}