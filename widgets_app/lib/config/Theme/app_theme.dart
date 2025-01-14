import 'package:flutter/material.dart';

const colorList = <Color>[
  Colors.blue,
  Colors.teal,
  Colors.green,
  Colors.green,
  Colors.purple,
  Colors.deepPurple,
  Colors.orange,
];


class AppTheme {

  final int selectedColor;


  AppTheme({ 
    this.selectedColor = 0  
  }): assert( selectedColor >= 0, 'Selected color must be greater then 0'),
  assert( selectedColor < colorList.length, 'Selected color must be less that ${ colorList.length - 1 }');



  ThemeData getTheme() => ThemeData(
    colorSchemeSeed: colorList[selectedColor],
    appBarTheme: const AppBarTheme(
      centerTitle: false
    )
  );

}