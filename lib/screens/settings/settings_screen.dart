import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsScreen extends StatelessWidget {
  final bool _notificationsEnabled =
      true; // Debería ser manejado por un estado o proveedor
  final bool _diaryLocked =
      false; // Debería ser manejado por un estado o proveedor

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed(
        '/login'); // Redirige al usuario a la pantalla de inicio de sesión
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuraciones'),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Notificaciones'),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              // Lógica para habilitar/deshabilitar notificaciones
            },
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Bloquear Diario'),
            onTap: () {
              // Lógica para bloquear el diario (por ejemplo, establecer una contraseña)
            },
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Idioma'),
            onTap: () {
              // Lógica para cambiar el idioma de la aplicación
            },
          ),
          ListTile(
            leading: Icon(Icons.security),
            title: Text('Privacidad y Seguridad'),
            onTap: () {
              // Lógica para configurar opciones de privacidad
            },
          ),
          ListTile(
            leading: Icon(Icons.cloud_upload),
            title: Text('Copia de Seguridad y Sincronización'),
            onTap: () {
              // Lógica para respaldar y sincronizar datos
            },
          ),
          Divider(), // Línea divisoria para separar el botón de cerrar sesión
          ListTile(
            leading: Icon(Icons.logout, color: Colors.blueAccent),
            title: Text(
              'Cerrar Sesión',
              style: TextStyle(
                  color: Colors.blueAccent, fontWeight: FontWeight.bold),
            ),
            onTap: () async {
              await _signOut(context);
            },
          ),
        ],
      ),
    );
  }
}
