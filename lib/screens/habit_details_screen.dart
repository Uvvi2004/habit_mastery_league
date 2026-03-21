import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../database/db_helper.dart';

class HabitDetailsScreen extends StatelessWidget {
  final Habit habit;

  const HabitDetailsScreen({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              habit.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(habit.description),

            const SizedBox(height: 20),

            Row(
              children: [
                const Text("Completed: "),
                Icon(
                  habit.isCompleted == 1
                      ? Icons.check_circle
                      : Icons.circle_outlined,
                  color: habit.isCompleted == 1
                      ? Colors.green
                      : Colors.grey,
                ),
              ],
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () async {
                await DBHelper.instance.deleteHabit(habit.id!);
                Navigator.pop(context, true);
              },
              child: const Text('Delete Habit'),
            ),
          ],
        ),
      ),
    );
  }
}