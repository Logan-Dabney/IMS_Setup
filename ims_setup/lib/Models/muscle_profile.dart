import 'package:starter_project/Database/sqlite.dart';
import 'muscle.dart';

class MuscleProfile{
  int? id;
  late double intensity;
  late double pulse;
  late double timeDuration;
  late Muscle muscle;

  MuscleProfile(this.muscle, this.intensity, this.timeDuration, this.pulse);

  // need to pass the treatmeantId and order to this muscle group when creating it
  // it wont be attached to the muscleProfile object
  Map<String, dynamic> toMap(int treatmentId, int order) {
    var map = <String, dynamic>{
      SqliteDB.columnIntensity: intensity,
      SqliteDB.columnPulse: pulse,
      SqliteDB.columnTime: timeDuration,
      SqliteDB.columnMuscleId: muscle.id,
      SqliteDB.columnTreatmentId: treatmentId,
      SqliteDB.columnOrder: order,
    };

    if(id != null){
      map[SqliteDB.columnId] = id;
    }

    return map;
  }

  MuscleProfile.fromMap(Map<String, dynamic> map) {
    id = map[SqliteDB.columnId];
    intensity = map[SqliteDB.columnIntensity];
    pulse = map[SqliteDB.columnPulse];
    timeDuration = map[SqliteDB.columnTime];
    muscle = muscles[map[SqliteDB.columnMuscleId] - 1];
  }
}