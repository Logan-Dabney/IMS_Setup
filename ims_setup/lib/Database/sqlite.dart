import "dart:io" as io;
import "package:path/path.dart";
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:starter_project/Models/all_models.dart';

class SqliteDB {
  // Treatment Table Setup
  static const treatmentProfileTable = 'Treatment';
  static const columnId = 'id';
  static const columnName = 'name';

  // Muscle Profile Table setup
  static const muscleProfileTable = 'Muscle';
  static const columnTreatmentId = 'treatment_id';
  static const columnOrder = 'muscle_order';
  static const columnMuscleId = 'muscle_id';
  static const columnIntensity = 'intensity';
  static const columnPulse = 'pulse';
  static const columnTime = 'time';

  SqliteDB._();
  static final SqliteDB db = SqliteDB._();
  static var _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDb();
    return _database;
  }

  /// Initialize DB
  initDb() async {
    String path = await getDatabasesPath();
    return await openDatabase(
        join(path, "IMS_Setup.db"),
        version: 1,
        onCreate: _onCreate
    );
  }

  Future _onCreate(Database database, int version) async {
    await database.execute('''
          CREATE TABLE $treatmentProfileTable (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnName TEXT NOT NULL
          )
          ''');

    await database.execute('''
          CREATE TABLE $muscleProfileTable (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnMuscleId INTEGER NOT NULL,
            $columnTreatmentId INTEGER NOT NULL,
            $columnOrder INTEGER NOT NULL,
            $columnIntensity REAL NOT NULL,
            $columnPulse REAL NOT NULL,
            $columnTime REAL NOT NULL
          )
          ''');
  }

  Future<List<TreatmentProfile>> getTreatmentProfiles() async {
    final db = await database;

    var treatments = await db.query(
      treatmentProfileTable,
      columns: [columnId, columnName]
    );

    List<TreatmentProfile> treatmentProfiles = [];

    for (int i = 0; i < treatments.length; i++){
      TreatmentProfile treatmentProfile = TreatmentProfile.fromMap(treatments[i]);
      treatmentProfile.muscleProfiles = await SqliteDB.db.getMuscleProfiles(treatmentProfile.id!);
      treatmentProfiles.add(treatmentProfile);
    }

    return treatmentProfiles;
  }

  Future<TreatmentProfile> insertTreatmentProfile(TreatmentProfile treatmentProfile) async {
    final datab = await database;
    // defining the treatment profile id after inserting it
    treatmentProfile.id = await datab.insert(treatmentProfileTable, treatmentProfile.toMap());

    //inserting the muscle profiles that are connected to the treatment
    for(int i = 0; i < treatmentProfile.muscleProfiles.length; i++){
      db.insertMuscleProfile(treatmentProfile.muscleProfiles[i], treatmentProfile.id!, i);
    }

    return treatmentProfile;
  }

  Future<int> deleteTreatmentProfile(TreatmentProfile treatmentProfile) async{
    final datab = await database;

    // Delete each muscle profile connected to treatment
    treatmentProfile.muscleProfiles.forEach((currentMuscleProfile) {
      db.deleteMuscleProfile(currentMuscleProfile.id!);
    });

    return await datab.delete(
        treatmentProfileTable,
        where:"id = ?",
        whereArgs: [treatmentProfile.id]
    );
  }

  Future<int> updateTreatmentProfile(TreatmentProfile treatmentProfile) async{
    final datab = await database;

    // update each muscle profile connected to treatment
    for(int i = 0; i < treatmentProfile.muscleProfiles.length; i++){
      db.updateMuscleProfile(treatmentProfile.muscleProfiles[0], treatmentProfile.id!, i);
    }

    return await datab.update(
        treatmentProfileTable,
        treatmentProfile.toMap(),
        where:"id = ?",
        whereArgs: [treatmentProfile.id]
    );
  }

  Future<List<MuscleProfile>> getMuscleProfiles(int treatmentId) async {
    final db = await database;

    // return a list of the muscle profiles connected to the treatmentId
    // Put them in asc order using the order column
    var muscleProfiles = await db.query(
      muscleProfileTable,
      columns: [columnId, columnMuscleId, columnIntensity, columnPulse,
        columnTime, columnOrder, columnTreatmentId],
      orderBy: "$columnOrder ASC",
      where: "$columnTreatmentId = ?",
      whereArgs: [treatmentId]
    );

    List<MuscleProfile> muscleProfileList = [];

    muscleProfiles.forEach((currentMuscleProfile) {
      MuscleProfile muscleProfile = MuscleProfile.fromMap(currentMuscleProfile);
      muscleProfileList.add(muscleProfile);
    });

    return muscleProfileList;
  }

  // need to pass the treatmentId and order to this muscle group when creating it
  // it wont be attached to the muscleProfile object
  Future<MuscleProfile> insertMuscleProfile (MuscleProfile muscleProfile, int treatmentId, int order) async {
    final db = await database;
    // defining the muscle profile id after inserting it
    muscleProfile.id = await db.insert(muscleProfileTable, muscleProfile.toMap(treatmentId, order));
    return muscleProfile;
  }

  Future<int> deleteMuscleProfile(int id) async {
    final db = await database;

    return await db.delete(
      muscleProfileTable,
      where: "$columnId = ?",
      whereArgs: [id]
    );
  }

  Future<int> updateMuscleProfile(MuscleProfile muscleProfile, int treatmentId, int order) async{
    final db = await database;

    return await db.update(
      muscleProfileTable,
      muscleProfile.toMap(treatmentId, order),
      where: "id = ?",
      whereArgs: [muscleProfile.id]);
  }
}