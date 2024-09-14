import 'package:flutter/material.dart';
import 'package:daylyse/screens/settings/settings_screen.dart';
import 'package:daylyse/themes/theme_screen.dart'; 
import 'package:daylyse/screens/settings/faq_screen.dart';

class DrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.book, // Icono de diario
                  size: 80,
                  color: Colors.white,
                ),
                SizedBox(height: 12),
                Text(
                  'daylyuse',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Configuraciones'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.brightness_6),
            title: Text('Tema'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ThemeScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.question_answer),
            title: Text('Preguntas Frecuentes'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FaqScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}