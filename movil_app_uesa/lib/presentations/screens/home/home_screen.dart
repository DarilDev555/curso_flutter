import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:movil_app_uesa/config/router/app_router.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:movil_app_uesa/presentations/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  static const String name = 'home_screen';
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                const HeaderLogin(),
                Positioned(
                  top: 60,
                  right: 80,
                  child: Icon(
                    Icons.trip_origin,
                    color: colors.inversePrimary.withAlpha(50),
                    size: 35,
                  ),
                ),
                Positioned(
                  top: 120,
                  left: 90,
                  child: Icon(
                    Icons.trip_origin,
                    color: colors.inversePrimary.withAlpha(100),
                    size: 35,
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 130,
                  child: TextFrave(
                    text: 'Bienvenido',
                    color: colors.onPrimaryContainer,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.center,
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 170,
                  child: TextFrave(
                    text: 'Ingrese sus credenciales para continuar',
                    color: colors.onPrimaryContainer,
                    fontSize: 17,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            _TextFieldCustom(
              controller: _usernameController,
              hint: 'Nombre de Usuario',
              isPassword: false,
              colors: colors,
            ),
            const SizedBox(height: 40),
            _TextFieldCustom(
              controller: _passwordController,
              hint: 'Contraseña',
              isPassword: true,
              colors: colors,
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: InkWell(
                onTap: () {
                  print(
                      'usuario: ${_usernameController.text} contraseña: ${_passwordController.text}');
                  context.push('/attendance-record-screen');
                },
                borderRadius: BorderRadius.circular(7.0),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  child: Center(
                    child: TextFrave(
                      text: 'Ingresa',
                      color: colors.onPrimaryContainer,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TextFieldCustom extends StatelessWidget {
  final String hint;
  final bool isPassword;
  final ColorScheme colors;
  final TextEditingController controller;

  const _TextFieldCustom(
      {required this.hint,
      required this.isPassword,
      required this.colors,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        obscureText: isPassword,
        style: TextStyle(color: colors.onSurface, fontSize: 18),
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(color: colors.onSurface)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: colors.onSurface)),
          labelStyle: TextStyle(color: colors.onSurface),
          hintText: hint,
          hintStyle: TextStyle(
            color: colors.onSurface.withAlpha(70),
          ),
        ),
      ),
    );
  }
}
