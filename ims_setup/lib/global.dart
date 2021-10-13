List<Muscle> muscles = [
  Muscle("Vastus Lateralis", 1),
  Muscle("Vastus Medialis", 2),
  Muscle("Quadricep", 3),
  Muscle("Gacilis", 4),
  Muscle("Hamstring", 5),
  Muscle("Calves", 6)
];

class Muscle{
  String name;
  int id;

  Muscle(this.name, this.id);
}

class MuscleProfile{
  double intensity;
  double pulse;
  double timeDuration;
  Muscle muscle;

  MuscleProfile(this.muscle, this.intensity, this.timeDuration, this.pulse);

  // Map<String, dynamic> toMap() {
  //   var map = <String, dynamic>{};
  //
  //
  // }
}

class TreatmentProfile{
  String name;
  List<MuscleProfile> muscleProfiles;

  TreatmentProfile(this.name, this.muscleProfiles);
}


