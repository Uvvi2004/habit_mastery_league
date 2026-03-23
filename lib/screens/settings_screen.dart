import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/db_helper.dart';

// This screen allows users to manage app settings
// Includes dark mode toggle, name update, and delete all habits
class SettingsScreen extends StatefulWidget {
  final Function(bool) onThemeChanged; // Callback to update app theme

  const SettingsScreen({super.key, required this.onThemeChanged});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false; // Stores current theme state
  String name = ""; // Stores current username
  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadSettings(); // Load saved settings when screen starts
  }

  // Load saved data from SharedPreferences
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      isDarkMode = prefs.getBool('darkMode') ?? false;
      name = prefs.getString('username') ?? "";
      nameController.text = name;
    });
  }

  // Toggle dark mode and save preference
  Future<void> toggleTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);

    setState(() {
      isDarkMode = value;
    });

    // Notify main app to update theme
    widget.onThemeChanged(value);
  }

  // Save updated username
  Future<void> saveName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', nameController.text);

    setState(() {
      name = nameController.text;
    });

    // Show confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Name updated')),
    );
  }

  // Delete all habits from database
  Future<void> deleteAllHabits() async {
    await DBHelper.instance.deleteAllHabits();

    // Show confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All habits deleted')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            // Dark mode toggle switch
            ListTile(
              title: const Text('Dark Mode'),
              trailing: Switch(
                value: isDarkMode,
                onChanged: toggleTheme,
              ),
            ),

            const SizedBox(height: 20),

            // Input field to change username
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Change Name',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            // Button to save new name
            ElevatedButton(
              onPressed: saveName,
              child: const Text("Save Name"),
            ),

            const SizedBox(height: 30),

            // Button to delete all habits
            ElevatedButton(
              onPressed: deleteAllHabits,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text("Delete All Habits"),
            ),
          ],
        ),
      ),
    );
  }
}