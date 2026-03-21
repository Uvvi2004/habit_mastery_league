import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/habit.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Habit> habits = [];

  @override
  void initState() {
    super.initState();
    loadHabits();
  }

  Future<void> loadHabits() async {
    final data = await DBHelper.instance.getHabits();
    setState(() {
      habits = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: habits.isEmpty
          ? const Center(child: Text('No habits yet'))
          : ListView.builder(
              itemCount: habits.length,
              itemBuilder: (context, index) {
                final habit = habits[index];

                return ListTile(
                  title: Text(habit.name),
                  subtitle: Text(habit.description),
                  trailing: Icon(
                    habit.isCompleted == 1
                        ? Icons.check_circle
                        : Icons.circle_outlined,
                    color: habit.isCompleted == 1
                        ? Colors.green
                        : Colors.grey,
                  ),
                );
              },
            ),
    );
  }
}