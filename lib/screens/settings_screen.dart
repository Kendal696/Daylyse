import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Configuraciones'),
      ),
      body: Center(
        child: SwitchListTile(
          title: Text('Modo Oscuro'),
          value: themeProvider.themeMode == ThemeMode.dark,  // Verifica si está en modo oscuro
          onChanged: (bool value) {
            themeProvider.toggleTheme(value);  // Cambia el tema
          },
        ),
      ),
    );
  }
}
