import 'package:flutter/material.dart';

class AppBarCustom extends StatelessWidget {
  final Widget title;

  const AppBarCustom({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 10),
          title,
        ],
      ),
    );
  }
}
