// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final Color background;
  final Color colorLabel;
  final String label;
  final Icon icon;
  final double height;
  final double width;
  final void Function()? callback;

  const CustomIconButton({
    super.key,
    required this.background,
    required this.colorLabel,
    required this.label,
    required this.icon,
    this.height = 60,
    this.width = 120,
    this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      splashColor: background,
      borderRadius: BorderRadius.circular(40),

      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color:
              (callback != null)
                  ? background.withValues(alpha: 0.9)
                  : background.withValues(alpha: 0.7),
        ),
        height: height,
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [icon, Text(label, style: TextStyle(color: colorLabel))],
        ),
      ),
    );
  }
}
