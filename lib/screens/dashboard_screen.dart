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

  double getCompletionPercent() {
    if (habits.isEmpty) return 0;
    double total = habits.fold(0, (sum, h) => sum + h.progress);
    return total / (habits.length * 100);
  }

  @override
  Widget build(BuildContext context) {
    double percent = getCompletionPercent();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(
                    onThemeChanged: (value) {
                      MyApp.of(context)?.setTheme(value);
                    },
                  ),
                ),
              );

              loadHabits(); 
            },
          ),
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                LinearProgressIndicator(value: percent),
                const SizedBox(height: 5),
                Text("Overall Progress: ${(percent * 100).toInt()}%"),
              ],
            ),
          ),

          Expanded(
            child: habits.isEmpty
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
                              decoration: habit.progress == 100
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(habit.description),
                              const SizedBox(height: 5),
                              LinearProgressIndicator(
                                value: habit.progress / 100,
                              ),
                            ],
                          ),

                          // 🔥 LEFT BUTTON (complete toggle)
                          leading: IconButton(
                            icon: Icon(
                              habit.progress == 100
                                  ? Icons.check_circle
                                  : Icons.circle_outlined,
                              color: habit.progress == 100
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                            onPressed: () async {
                              habit.progress = habit.progress == 100 ? 0 : 100;
                              await DBHelper.instance.updateHabit(habit);
                              loadHabits();
                            },
                          ),

                          trailing: Text("${habit.progress}%"),

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
                        )
                      );
                    },
                  ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
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