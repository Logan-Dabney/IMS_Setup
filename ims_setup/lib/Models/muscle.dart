/// File: muscle.dart
/// Author: Logan Dabney (@Logan-Dabney)
/// Version: 0.1
/// Date: 2021-10-06
/// Copyright: Copyright (c) 2021

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