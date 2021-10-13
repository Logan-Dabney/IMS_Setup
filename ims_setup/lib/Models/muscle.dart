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