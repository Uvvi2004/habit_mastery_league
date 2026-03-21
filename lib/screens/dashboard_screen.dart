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
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(
                    onThemeChanged: (value) {
                      MyApp.of(context)?.setTheme(value);
                    },
                  ),
                ),
              );
              loadHabits(); // refresh after settings
            },
          ),
        ],
      ),

      body: Column(
        children: [
          // TOP PROGRESS SECTION
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Overall Progress",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: percent,
                    minHeight: 10,
                    color: const Color.fromARGB(255, 116, 221, 113),
                    backgroundColor: Colors.grey[300],
                  ),
                ),
                const SizedBox(height: 6),
                Text("${(percent * 100).toInt()}%"),
              ],
            ),
          ),

          // HABIT LIST
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

                      return GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  HabitDetailsScreen(habit: habit),
                            ),
                          );

                          if (result == true) {
                            loadHabits();
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // TOP ROW
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          habit.progress == 100
                                              ? Icons.check_circle
                                              : Icons.circle_outlined,
                                          color: habit.progress == 100
                                              ? const Color.fromARGB(255, 116, 221, 113)
                                              : Colors.grey,
                                        ),
                                        onPressed: () async {
                                          habit.progress =
                                              habit.progress == 100 ? 0 : 100;
                                          await DBHelper.instance
                                              .updateHabit(habit);
                                          loadHabits();
                                        },
                                      ),

                                      const SizedBox(width: 5),

                                      Expanded(
                                        child: Text(
                                          habit.name,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            decoration:
                                                habit.progress == 100
                                                    ? TextDecoration.lineThrough
                                                    : null,
                                          ),
                                        ),
                                      ),

                                      Text(
                                        "${habit.progress}%",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 6),

                                  Text(
                                    habit.description,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: LinearProgressIndicator(
                                      value: habit.progress / 100,
                                      minHeight: 8,
                                      color: const Color.fromARGB(255, 116, 221, 113),
                                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
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