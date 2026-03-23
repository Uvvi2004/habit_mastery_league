import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard_screen.dart';

// This is the first screen shown when the app starts
// It allows the user to enter their name and stores it locally
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final TextEditingController nameController = TextEditingController();

  String name = ""; // Stores user name
  bool hasName = false; // Checks if name already exists

  @override
  void initState() {
    super.initState();
    loadName(); // Load saved name on app start
  }

  // Loads saved username from SharedPreferences
  Future<void> loadName() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedName = prefs.getString('username');

    if (savedName != null && savedName.isNotEmpty) {
      setState(() {
        name = savedName;
        hasName = true;
      });
    }
  }

  // Saves username to local storage
  Future<void> saveName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', nameController.text);

    setState(() {
      name = nameController.text;
      hasName = true;
    });
  }

  // Navigates to dashboard screen
  // pushReplacement removes splash from navigation stack
  void goToDashboard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const DashboardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center( // Centers all content on screen
        child: SingleChildScrollView(
          // Prevents overflow when keyboard appears
          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // App logo
                Image.asset('assets/images/logo.png', height: 400),

                const SizedBox(height: 20),

                // If name exists, show welcome message
                hasName
                    ? Text(
                        "Welcome back, $name!",
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      )
                    // Otherwise ask user to enter name
                    : const Text(
                        "Enter your name",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),

                const SizedBox(height: 20),

                // Show input only if name is not saved
                if (!hasName)
                  TextField(
                    controller: nameController,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      labelText: 'Your Name',
                      border: OutlineInputBorder(),
                    ),
                  ),

                const SizedBox(height: 20),

                // Button to proceed to dashboard
                ElevatedButton(
                  onPressed: () {
                    // If name not saved yet, validate and save
                    if (!hasName) {
                      if (nameController.text.isEmpty) return;
                      saveName();
                    }

                    // Navigate to dashboard
                    goToDashboard();
                  },
                  child: const Text("Get Started"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}