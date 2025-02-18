import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigaton extends StatelessWidget {
  final StatefulNavigationShell currentChild;
  const CustomBottomNavigaton({
    super.key,
    required this.currentChild,
  });

  // void onItemTapped(BuildContext context, int index) {
  //   switch (index) {
  //     case 0:
  //       context.go('/');
  //       break;
  //     case 1:
  //       context.go('/');
  //       break;
  //     case 2:
  //       context.go('/favorites');
  //       break;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentChild.currentIndex,
      onTap: (index) => currentChild.goBranch(index),
      elevation: 0,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_max),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.label_outline),
          label: 'Categorias',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_outline),
          label: 'Favoritos',
        ),
      ],
    );
  }
}
