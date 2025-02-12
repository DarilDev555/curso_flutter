import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home-screen';

  final StatefulNavigationShell currentChild;

  const HomeScreen({
    super.key,
    required this.currentChild,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentChild,
      bottomNavigationBar: CustomBottomNavigaton(
        currentChild: currentChild,
      ),
    );
  }
} 
