import 'package:flutter/material.dart';

class FaqScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preguntas Frecuentes'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          ExpansionTile(
            title: Text('¿Cómo añadir una nueva nota?'),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Para añadir una nueva nota, presiona el botón "+" en la parte inferior.'),
              ),
            ],
          ),
          ExpansionTile(
            title: Text('¿Cómo cambio el tema de la aplicación?'),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Puedes cambiar el tema yendo a Configuraciones > Tema.'),
              ),
            ],
          ),
          // Puedes agregar más preguntas frecuentes aquí
        ],
      ),
    );
  }
}
