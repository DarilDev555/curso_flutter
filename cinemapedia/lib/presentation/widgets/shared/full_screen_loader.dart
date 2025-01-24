import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  Stream<String> getLoadingMessages() {
    final messages = <String>[
      'Cargando peliculas',
      'Comprando palomitas de maiz',
      'Cargando populares',
      'Ya casi...',
      'Esto esta tardando mas de lo esperado',
    ];

    return Stream.periodic(const Duration(milliseconds: 1200), (step) {
      return messages[step];
    }).take(messages.length);
  }

  const FullScreenLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Espere por favor'),
          SizedBox(
            height: 10,
          ),
          const CircularProgressIndicator(
            strokeWidth: 2,
          ),
          SizedBox(
            height: 10,
          ),
          StreamBuilder(
            stream: getLoadingMessages(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Text('Cargando');
              }

              return Text(snapshot.data!);
            },
          ),
        ],
      ),
    );
  }
}
