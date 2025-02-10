import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stress_relief_app/providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SwitchListTile(
              title: Text(
                'Dark Mode',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              value: themeProvider.isDarkMode,
              onChanged: (value) {
                themeProvider.toggleTheme();
              },
              activeColor: Theme.of(context).iconTheme.color,
              inactiveThumbColor: Theme.of(context).cardColor,
              inactiveTrackColor: Theme.of(context).cardColor?.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }
}
