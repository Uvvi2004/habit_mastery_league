import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static dynamic of(BuildContext context) {
    return context.findAncestorStateOfType<_MyAppState>();
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    loadTheme();
  }

  void loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('darkMode') ?? false;
    });
  }

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
      theme: ThemeData(
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        
        scaffoldBackgroundColor:
            isDarkMode ? null : Colors.white,

        appBarTheme: AppBarTheme(
          backgroundColor:
              isDarkMode ? null : Colors.white,
          foregroundColor:
              isDarkMode ? null : Colors.black,
          elevation: 0,
        ),

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
      home: const SplashScreen(),
    );
  }
}