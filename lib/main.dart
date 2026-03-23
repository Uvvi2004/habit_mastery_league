import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/splash_screen.dart';

// Entry point of the app
void main() {
  runApp(const MyApp());
}

// Root widget of the application
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // This method allows other screens (like Settings) to access and update theme
  static dynamic of(BuildContext context) {
    return context.findAncestorStateOfType<_MyAppState>();
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false; // Stores current theme mode

  @override
  void initState() {
    super.initState();
    loadTheme(); // Load saved theme when app starts
  }

  // Load theme preference from SharedPreferences
  void loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('darkMode') ?? false;
    });
  }

  // Update theme and save preference
  void setTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);

    setState(() {
      isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Mastery League',

      // Theme configuration
      theme: ThemeData(
        brightness: isDarkMode ? Brightness.dark : Brightness.light,

        // Light mode background
        scaffoldBackgroundColor:
            isDarkMode ? null : Colors.white,

        // AppBar styling
        appBarTheme: AppBarTheme(
          backgroundColor:
              isDarkMode ? null : Colors.white,
          foregroundColor:
              isDarkMode ? null : Colors.black,
          elevation: 0,
        ),

        // Color scheme setup
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness:
              isDarkMode ? Brightness.dark : Brightness.light,
        ).copyWith(
          primary: isDarkMode ? null : Colors.black,
          onPrimary: isDarkMode ? null : Colors.white,
        ),

        useMaterial3: true,
      ),

      // First screen shown when app starts
      home: const SplashScreen(),
    );
  }
}