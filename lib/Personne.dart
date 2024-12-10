import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const String tablePersonne = 'personne';
const String colonneId = 'id';
const String colonneNom = 'nom';
const String colonnePrenom = 'prenom';
const String colonneAge = 'age';

const String databaseName = 'PersonneDB.db';
const int databaseVersion = 1;

class Personne {
  int? id;
  String? nom;
  String? prenom;
  String? age;

  Personne();

  Personne.fromMap(Map<dynamic, dynamic> map) {
    id = map[colonneId];
    nom = map[colonneNom];
    prenom = map[colonnePrenom];
    age = map[colonneAge];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      colonneNom: nom,
      colonnePrenom: prenom,
      colonneAge: age
    };
    if (id != null) {
      map[colonneId] = id;
    }
    return map;
  }
}

class PersonneProvider {

  PersonneProvider._privateConstructor();

  static final PersonneProvider instance = 
  PersonneProvider._privateConstructor();

  Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await _initDatabase();
      return _db;
    }
  }

  Future<Database> _initDatabase() async {
    // Get the default database path
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, databaseName); // Combine path with database name
    print('Database path: $path');

    // Open or create the database at this path
    return await openDatabase(path, version: databaseVersion, onCreate: _open);
  }

  Future _open(Database db, int version) async {
    await db.execute(''' 
     create table $tablePersonne ( 
     $colonneId integer primary key autoincrement, 
     $colonneNom text, 
     $colonnePrenom text, 
     $colonneAge text) 
     ''');
  }

  Future<int?> insert(Personne personne) async {
    Database? db = await instance.db;
    int? id = await db?.insert(tablePersonne, personne.toMap());
    return id;
  }

  Future<Personne> getPersonne(int id) async {
    Database? db = await instance.db;
    List<Map>? maps = (await db?.query(tablePersonne,
        columns: [colonneId, colonneNom, colonnePrenom, colonneAge],
        where: '$colonneId = ?',
        whereArgs: [id]))?.cast<Map>();
    //if (maps.isNotEmpty) {
      return Personne.fromMap(maps!.first);
   // }
    //return null;
  }

  Future<int?> delete(int id) async {
    Database? db = await instance.db;
    return await db
        ?.delete(tablePersonne, where: '$colonneId = ?', whereArgs: [id]);
  }

  Future close() async => _db?.close();
}