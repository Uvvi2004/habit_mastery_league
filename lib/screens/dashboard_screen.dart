import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/habit.dart';
import 'add_habit_screen.dart';
import 'settings_screen.dart';
import 'habit_details_screen.dart';
import '../main.dart';

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
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(
                    onThemeChanged: (value) {
                      MyApp.of(context)?.setTheme(value);
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),

      body: habits.isEmpty
          ? const Center(
              child: Text(
                'No habits yet\nTap + to add one',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: habits.length,
              itemBuilder: (context, index) {
                final habit = habits[index];

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(
                      habit.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: habit.isCompleted == 1
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    subtitle: Text(habit.description),

                    leading: IconButton(
                      icon: Icon(
                        habit.isCompleted == 1
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color: habit.isCompleted == 1
                            ? Colors.green
                            : Colors.grey,
                      ),
                      onPressed: () async {
                        habit.isCompleted = habit.isCompleted == 1 ? 0 : 1;
                        await DBHelper.instance.updateHabit(habit);
                        loadHabits();
                      },
                    ),

                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await DBHelper.instance.deleteHabit(habit.id!);
                        loadHabits();
                      },
                    ),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HabitDetailsScreen(habit: habit),
                        ),
                      );

                      if (result == true) {
                        loadHabits();
                      }
                    },
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddHabitScreen(),
            ),
          );

          if (result == true) {
            loadHabits();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}