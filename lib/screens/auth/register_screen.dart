import 'package:daylyse/repositories/auth-firebase_repository.dart';
import 'package:daylyse/services/auth_service.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService(auth: AuthFirebaseRepository());

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String _passwordErrorMessage = "";
  String _confirmPasswordErrorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.lightBlue.shade300],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 60.0,
                  backgroundColor: Colors.white.withOpacity(0.8),
                  child: Icon(
                    Icons.person_add_alt_1_outlined,
                    size: 80.0,
                    color: Colors.lightBlue.shade700,
                  ),
                ),
                SizedBox(height: 40.0),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined,
                        color: Colors.lightBlue.shade700),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.9),
                    contentPadding: EdgeInsets.symmetric(vertical: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'Contraseña',
                    prefixIcon: Icon(Icons.lock_outline,
                        color: Colors.lightBlue.shade700),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.lightBlue.shade700,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.9),
                    contentPadding: EdgeInsets.symmetric(vertical: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  style: TextStyle(color: Colors.black),
                  onChanged: (value) {
                    setState(() {
                      _passwordErrorMessage = _getPasswordErrorMessage(value);
                    });
                  },
                ),
                SizedBox(height: 8.0),
                if (_passwordErrorMessage.isNotEmpty)
                  Text(
                    _passwordErrorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    hintText: 'Confirmar Contraseña',
                    prefixIcon: Icon(Icons.lock_outline,
                        color: Colors.lightBlue.shade700),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.lightBlue.shade700,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.9),
                    contentPadding: EdgeInsets.symmetric(vertical: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  style: TextStyle(color: Colors.black),
                  onChanged: (value) {
                    setState(() {
                      _confirmPasswordErrorMessage =
                          _getConfirmPasswordErrorMessage(value);
                    });
                  },
                ),
                SizedBox(height: 8.0),
                if (_confirmPasswordErrorMessage.isNotEmpty)
                  Text(
                    _confirmPasswordErrorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: handleSubmit,
                  style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 80.0, vertical: 20.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    backgroundColor: Colors.lightBlue.shade700,
                    elevation: 5,
                    shadowColor: Colors.lightBlueAccent,
                  ),
                  child: Text(
                    'Registrarse',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                ),
                SizedBox(height: 16.0),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Text(
                    '¿Ya tienes una cuenta? Inicia sesión',
                    style: TextStyle(color: Colors.lightBlue.shade700),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> handleSubmit() async {
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Las contraseñas no coinciden')),
      );
      return;
    }

    if (!_isPasswordSecure(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'La contraseña no cumple con todos los requisitos de seguridad.')),
      );
      return;
    }

    final response = await _authService.createAccount(
        "Test", _emailController.text, password);
    if (mounted) {
      if (response.isSuccess) {
        Navigator.pushNamed(context, '/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.errorMessage!)),
        );
      }
    }
  }

  // Validación de seguridad de la contraseña
  bool _isPasswordSecure(String password) {
    final hasMinLength = password.length >= 8;
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasNumber = password.contains(RegExp(r'[0-9]'));
    final hasSpecialChar =
        password.contains(RegExp(r'[!@#\$&*~.]')); // Incluye .

    return hasMinLength &&
        hasUppercase &&
        hasLowercase &&
        hasNumber &&
        hasSpecialChar;
  }

  // Obtener mensaje de error de los requisitos que faltan
  String _getPasswordErrorMessage(String password) {
    List<String> errors = [];
    if (password.length < 8) {
      errors.add("Debe tener al menos 8 caracteres.");
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      errors.add("Debe incluir una letra mayúscula.");
    }
    if (!password.contains(RegExp(r'[a-z]'))) {
      errors.add("Debe incluir una letra minúscula.");
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      errors.add("Debe incluir un número.");
    }
    if (!password.contains(RegExp(r'[!@#\$&*~.]'))) {
      errors.add("Debe incluir un carácter especial.");
    }

    return errors.isNotEmpty ? errors.join(" ") : "";
  }

  // Validar confirmación de contraseña
  String _getConfirmPasswordErrorMessage(String confirmPassword) {
    if (confirmPassword != _passwordController.text) {
      return "Las contraseñas no coinciden";
    }
    return "";
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
