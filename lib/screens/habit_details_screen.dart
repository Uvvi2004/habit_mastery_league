import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../database/db_helper.dart';

class HabitDetailsScreen extends StatefulWidget {
  final Habit habit;

  const HabitDetailsScreen({super.key, required this.habit});

  @override
  State<HabitDetailsScreen> createState() => _HabitDetailsScreenState();
}

class _HabitDetailsScreenState extends State<HabitDetailsScreen> {
  late double progress;

  @override
  void initState() {
    super.initState();
    progress = widget.habit.progress.toDouble();
  }

  void updateProgress(double value) async {
    setState(() {
      progress = value;
    });

    widget.habit.progress = value.toInt();

    await DBHelper.instance.updateHabit(widget.habit);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true); // 🔥 THIS FIXES DASHBOARD UPDATE
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.habit.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(widget.habit.description),

            const SizedBox(height: 30),

            Text("Progress: ${progress.toInt()}%"),
            Slider(
              value: progress,
              min: 0,
              max: 100,
              divisions: 100,
              onChanged: updateProgress,
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                await DBHelper.instance.deleteHabit(widget.habit.id!);
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