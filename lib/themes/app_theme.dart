import 'package:flutter/material.dart';

class AppTheme {
  // Tema claro: blanco y celeste
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.lightBlue[700],  // Color principal celeste
    scaffoldBackgroundColor: Colors.white,  // Fondo blanco
    appBarTheme: AppBarTheme(
      color: Colors.lightBlue[700],  // AppBar celeste
    ),
    textTheme: TextTheme(
      bodyText1: TextStyle(color: Colors.black),  // Texto negro en el cuerpo
      bodyText2: TextStyle(color: Colors.black),  // Texto negro en el cuerpo
      headline6: TextStyle(color: Colors.white),  // Texto blanco en AppBar
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightBlue[700],  // Botones celestes
        foregroundColor: Colors.white,  // Texto blanco en botones
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.lightBlue[700],  // Botones celestes
      textTheme: ButtonTextTheme.primary,  // Texto blanco en botones
    ),
  );

  // Tema oscuro: fondo azul marino, botones celestes, letras blancas
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.lightBlue[700],  // Mantener botones celestes
    scaffoldBackgroundColor: Color(0xFF001F3F),  // Fondo azul marino oscuro
    appBarTheme: AppBarTheme(
      color: Color(0xFF001B33),  // AppBar aún más oscuro que el fondo
    ),
    textTheme: TextTheme(
      bodyText1: TextStyle(color: Colors.white),  // Texto blanco en el cuerpo
      bodyText2: TextStyle(color: Colors.white),  // Texto blanco en el cuerpo
      headline6: TextStyle(color: Colors.white),  // Texto blanco en AppBar
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightBlue[700],  // Botones celestes en tema oscuro también
        foregroundColor: Colors.white,  // Texto blanco en botones
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.lightBlue[700],  // Botones celestes en tema oscuro
      textTheme: ButtonTextTheme.primary,  // Texto blanco en botones
    ),
  );
}
