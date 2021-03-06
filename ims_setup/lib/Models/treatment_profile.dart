/// File: treatment_profile.dart
/// Author: Logan Dabney (@Logan-Dabney)
/// Version: 0.1
/// Date: 2021-10-06
/// Copyright: Copyright (c) 2021
///
import 'muscle_profile.dart';
import 'package:starter_project/Database/sqlite.dart';


class TreatmentProfile{
  int? id;
  late String name;
  late List<MuscleProfile> muscleProfiles;

  TreatmentProfile(this.name, this.muscleProfiles);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      SqliteDB.columnName: name,
    };

    if(id != null){
      map[SqliteDB.columnId] = id;
    }

    return map;
  }

  TreatmentProfile.fromMap(Map<String, dynamic> map) {
    id = map[SqliteDB.columnId];
    name = map[SqliteDB.columnName];
  }
}
