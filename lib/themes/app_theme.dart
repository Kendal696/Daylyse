import 'package:flutter/material.dart';

class AppTheme {
  // Color principal celeste unificado para ambos temas
  static const Color primaryCeleste = Color(0xFF03A9F4);  // Mismo celeste para ambos temas

  // Tema claro: blanco y celeste
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryCeleste,  // Color principal celeste
    scaffoldBackgroundColor: Colors.white,  // Fondo blanco
    appBarTheme: AppBarTheme(
      color: primaryCeleste,  // AppBar celeste
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: Colors.white,  // Fondo blanco en el Drawer
    ),
    textTheme: TextTheme(
      bodyText1: TextStyle(color: Colors.black),  // Texto negro
      bodyText2: TextStyle(color: Colors.black),
      headline6: TextStyle(color: Colors.white),  // Texto blanco en AppBar
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryCeleste,  // Botones celestes
        foregroundColor: Colors.white,  // Texto blanco en botones
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: primaryCeleste,  // Botones celestes
      textTheme: ButtonTextTheme.primary,
    ),
    iconTheme: IconThemeData(color: Colors.white),  // Iconos blancos
  );

  // Tema oscuro: azul marino, botones celestes, letras blancas
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryCeleste,  // Color celeste unificado para ambos temas
    scaffoldBackgroundColor: Color(0xFF001F3F),  // Fondo azul marino oscuro
    appBarTheme: AppBarTheme(
      color: Color(0xFF001B33),  // AppBar aún más oscuro que el fondo
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: Color(0xFF001B33),  // Fondo azul marino en el Drawer
    ),
    textTheme: TextTheme(
      bodyText1: TextStyle(color: Colors.white),  // Texto blanco
      bodyText2: TextStyle(color: Colors.white),
      headline6: TextStyle(color: Colors.white),  // Texto blanco en AppBar
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryCeleste,  // Botones celestes
        foregroundColor: Colors.white,  // Texto blanco en botones
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: primaryCeleste,  // Botones celestes
      textTheme: ButtonTextTheme.primary,
    ),
    iconTheme: IconThemeData(color: Colors.white),  // Iconos en blanco
  );
}
