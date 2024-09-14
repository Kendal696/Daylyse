import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  bool _notificationsEnabled = true; // Debería ser manejado por un estado o proveedor
  bool _diaryLocked = false; // Debería ser manejado por un estado o proveedor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuraciones'),
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
          // Puedes agregar más opciones según lo consideres necesario
        ],
      ),
    );
  }
}