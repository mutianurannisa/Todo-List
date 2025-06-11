import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:todolist/screens/start_screen.dart';
import 'package:todolist/screens/login_screen.dart';
import 'package:todolist/screens/register_screen.dart';
import 'package:todolist/screens/home_screen.dart';
import 'package:todolist/screens/calendar_screen.dart';
import 'package:todolist/screens/settings_screen.dart';
import 'package:todolist/screens/profile_screen.dart';
import 'package:todolist/screens/edit_profile_screen.dart';
import 'firebase_options.dart';
import 'package:todolist/theme/theme_provider.dart';
import 'package:todolist/providers/task_provider.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final themeProvider = await ThemeProvider.create();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: themeProvider,
        ),
        ChangeNotifierProvider(
          create: (context) => TaskProvider(), 
        ),
      ],
      child: const WApp(),
    ),
  );
}

class WApp extends StatelessWidget {
  const WApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        if (!themeProvider.isInitialized) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false, 
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        return MaterialApp(
          title: 'Todo-List App',
          theme: themeProvider.currentTheme,
          debugShowCheckedModeBanner: false,
          home: const StartScreen(), 
          routes: {
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/home': (context) => const HomeScreen(),
            '/calendar': (context) => const CalendarScreen(),
            '/settings': (context) => const SettingsScreen(),
            '/profile': (context) => const ProfileScreen(),
            '/edit-profile': (context) => const EditProfileScreen(),
          },
        );
      },
    );
  }
}