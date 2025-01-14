import 'package:flutter/material.dart';

class MenuItems {
  final String title;
  final String subTitle;
  final String link;
  final IconData icon;


const MenuItems( {
  required this.title,
  required this.subTitle,
  required this.link,
  required this.icon,
});

}


const appMenuItemss = <MenuItems>[
  MenuItems(title: 'Botones', subTitle: 'Varios botones en flutter', link: '/buttons', icon: Icons.smart_button_outlined),
  MenuItems(title: 'Tarjetas', subTitle: 'Un contenedor estilizado', link: '/cards', icon: Icons.credit_card),
  
];

