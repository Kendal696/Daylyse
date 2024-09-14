import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/settings/feedback_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/auth/register_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Diario con IA',
      theme: themeProvider.getLightTheme,
      darkTheme: themeProvider.getDarkTheme,
      themeMode: themeProvider.themeMode,
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/feedback': (context) => FeedbackScreen(),
        '/settings': (context) => SettingsScreen(),
        '/register': (context) => RegisterScreen(),
      },
    );
  }
}
