import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PruebaLoginScreen extends StatelessWidget {
  static const name = 'prueba-login-screen';
  const PruebaLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () => context.push('/'),
          child: const Text('Ir a Peliculas'),
        ),
      ),
    );
  }
}
