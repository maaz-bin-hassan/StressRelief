import 'package:flutter/material.dart';
import 'package:stress_relief_app/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:stress_relief_app/providers/theme_provider.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stress Relief',
      theme: themeProvider.isDarkMode
          ? themeProvider.darkTheme
          : themeProvider.lightTheme,
      home: HomeScreen(),
    );
  }
}
