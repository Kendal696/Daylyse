// theme_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class ThemeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Tema'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Modo Oscuro'),
            value: themeProvider.themeMode == ThemeMode.dark,
            onChanged: (bool value) {
              themeProvider.toggleTheme(value);
            },
          ),
          // Aquí puedes agregar más opciones de tema si lo deseas
        ],
      ),
    );
  }
}
