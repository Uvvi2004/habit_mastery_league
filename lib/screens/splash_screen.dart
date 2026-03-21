import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final TextEditingController nameController = TextEditingController();
  String name = "";
  bool hasName = false;

  @override
  void initState() {
    super.initState();
    loadName();
  }

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

  Future<void> saveName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', nameController.text);

    setState(() {
      name = nameController.text;
      hasName = true;
    });
  }

  void goToDashboard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const DashboardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center( // 🔥 THIS FIXES ALIGNMENT
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo.png', height: 400),

                const SizedBox(height: 20),

                hasName
                    ? Text(
                        "Welcome back, $name!",
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      )
                    : const Text(
                        "Enter your name",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),

                const SizedBox(height: 20),

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

                ElevatedButton(
                  onPressed: () {
                    if (!hasName) {
                      if (nameController.text.isEmpty) return;
                      saveName();
                    }
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