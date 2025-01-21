import 'package:flutter/material.dart';
import 'dart:math' show Random;


class AnimatedScreen extends StatefulWidget {
  
  static const name = 'animated_screen';

  const AnimatedScreen({super.key});

  @override
  State<AnimatedScreen> createState() => _AnimatedScreenState();
}

class _AnimatedScreenState extends State<AnimatedScreen> {

  double width = 50;
  double height = 50;
  Color color = Colors.indigo;
  double borderRadius = 10.0;


  void changeShape(){


    print(
      '${height}/n${width}/n${color}/n${borderRadius}'
    );

    final random = Random();

    width = random.nextInt(300) + 120;
    height = random.nextInt(300) + 120;
    color = Color.fromRGBO(random.nextInt(255), random.nextInt(255), random.nextInt(255), 1);
    borderRadius = random.nextInt(100) + 10;


    setState(() { });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Animated Container"),
      ),

      body: Center(
        child: AnimatedContainer(
          duration: const Duration( milliseconds: 800),
          curve: Curves.elasticOut,
          width: width > 0 ? width :  10 ,
          height: height > 0 ? height :  10 ,
          decoration: BoxDecoration(
            color:  color,
            borderRadius: BorderRadius.circular(borderRadius > 0 ? borderRadius :  10 )
          ),
        ),
      ),


      floatingActionButton: FloatingActionButton(
        onPressed: changeShape,
        child: const Icon( Icons.play_arrow_rounded),  
      ),
    );
  }
}