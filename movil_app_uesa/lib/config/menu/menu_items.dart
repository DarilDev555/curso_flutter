import 'package:flutter/material.dart';

class MenuItems {
  final String title;
  final String subTitle;
  final String link;
  final IconData icon;

  const MenuItems({
    required this.title,
    this.subTitle = '',
    required this.link,
    required this.icon,
  });
}

const appMenuItemss = <MenuItems>[
  MenuItems(
    title: 'Eventos',
    subTitle: 'Gestion de eventos',
    link: '/',
    icon: Icons.calendar_month_outlined,
  ),
  MenuItems(
    title: 'Asistentes',
    subTitle: 'Control de asistencia',
    link: '/',
    icon: Icons.people_outline_sharp,
  ),
  MenuItems(
    title: 'Operadores',
    subTitle: 'Usuarios registradores',
    link: '/',
    icon: Icons.how_to_reg_outlined,
  ),
  MenuItems(
    title: 'Instituciones',
    subTitle: 'Entidades educativas',
    link: '/',
    icon: Icons.school_outlined,
  ),
];
