import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFrave extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final int maxLines;
  final TextOverflow overflow;
  final TextAlign textAlign;
  final double? letterSpacing;

  const TextFrave({
    super.key,
    required this.text,
    this.fontSize = 18,
    this.fontWeight = FontWeight.normal,
    this.color = Colors.black,
    this.maxLines = 1,
    this.overflow = TextOverflow.visible,
    this.textAlign = TextAlign.left,
    this.letterSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.getFont('Roboto',
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          letterSpacing: letterSpacing),
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
    );
  }
}
