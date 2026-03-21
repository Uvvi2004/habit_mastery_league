class Habit {
  int? id;
  String name;
  String description;
  int progress; // 0 - 100

  Habit({
    this.id,
    required this.name,
    required this.description,
    this.progress = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'progress': progress,
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      progress: map['progress'],
    );
  }
}