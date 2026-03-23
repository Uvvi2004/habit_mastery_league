import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../database/db_helper.dart';

// This screen shows details for a selected habit
// It allows the user to update progress or delete the habit
class HabitDetailsScreen extends StatefulWidget {
  final Habit habit; // The selected habit passed from dashboard

  const HabitDetailsScreen({super.key, required this.habit});

  @override
  State<HabitDetailsScreen> createState() => _HabitDetailsScreenState();
}

class _HabitDetailsScreenState extends State<HabitDetailsScreen> {
  late double progress; // Stores progress as double for slider

  @override
  void initState() {
    super.initState();
    // Initialize progress from the habit data
    progress = widget.habit.progress.toDouble();
  }

  // Updates progress when user moves the slider
  void updateProgress(double value) async {
    setState(() {
      progress = value; // Update UI immediately
    });

    // Update habit object
    widget.habit.progress = value.toInt();

    // Save updated progress to database
    await DBHelper.instance.updateHabit(widget.habit);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Details'),

        // Custom back button to ensure dashboard refreshes
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true); // sends signal to refresh dashboard
          },
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Display habit name
            Text(
              widget.habit.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            // Display habit description
            Text(widget.habit.description),

            const SizedBox(height: 30),

            // Show current progress value
            Text("Progress: ${progress.toInt()}%"),

            // Slider to update progress (0 to 100)
            Slider(
              value: progress,
              min: 0,
              max: 100,
              divisions: 100,
              onChanged: updateProgress,
            ),

            const SizedBox(height: 20),

            // Button to delete habit
            ElevatedButton(
              onPressed: () async {
                await DBHelper.instance.deleteHabit(widget.habit.id!);
                Navigator.pop(context, true); // return and refresh dashboard
              },
              child: const Text('Delete Habit'),
            ),
          ],
        ),
      ),
    );
  }
}