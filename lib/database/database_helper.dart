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
        ID 'NUMBER PRIMARY KEY,
        NAME 'TEXT NOT NULL PRIMARY KEY',
        GENERATION 'TEXTNOT NULL'
        )
    ''');
  }
}