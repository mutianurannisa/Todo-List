import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/screens/profile_screen.dart';
import '../theme/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings',
         style: TextStyle(
          fontFamily: 'baloo', 
          fontSize: 30, 
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: 
        <Widget>[
          ListTile(
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: themeProvider.isDarkMode,
              onChanged: (value) {
                themeProvider.toggleTheme();
              },
            ),
          ),

          ListTile(
            title: const Text('Profile'),
            leading: const Icon(Icons.person),
            onTap: () {
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}