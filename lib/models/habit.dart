class Habit {
  int? id;
  String name;
  String description;
  int isCompleted; // 0 = false, 1 = true

  Habit({
    this.id,
    required this.name,
    required this.description,
    this.isCompleted = 0,
  });

  // Convert Habit object to Map (for SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'isCompleted': isCompleted,
    };
  }

  // Convert Map to Habit object
  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      isCompleted: map['isCompleted'],
    );
  }
}