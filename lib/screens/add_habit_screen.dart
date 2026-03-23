import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/habit.dart';

// This screen allows the user to add a new habit
class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  // Controllers to capture user input from text fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // This function saves a new habit to the database
  void saveHabit() async {
    // Validation: ensure habit name is not empty
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Habit name required')),
      );
      return;
    }

    // Create a Habit object using user input
    Habit habit = Habit(
      name: nameController.text,
      description: descriptionController.text,
    );

    // Insert habit into SQLite database
    await DBHelper.instance.insertHabit(habit);

    // Navigate back to dashboard and trigger refresh
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Habit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          // Allows screen to scroll if keyboard is open
          child: Column(
            children: [
              // Input for habit name
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Habit Name'),
              ),

              // Input for habit description
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),

              const SizedBox(height: 20),

              // Button to save habit
              ElevatedButton(
                onPressed: saveHabit,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}