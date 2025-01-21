import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class SnackbarScreen extends StatelessWidget {
  
  static const name = 'snackbar_screen';

  const SnackbarScreen({super.key});

  void showCustomSnackBar(BuildContext context){

    ScaffoldMessenger.of(context).clearSnackBars();

    const snackBar = SnackBar(content: Text('Este es una snackbar'));

    ScaffoldMessenger.of(context).showSnackBar(snackBar);


  }

  void openDialog(BuildContext context){
    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Estas Seguro?'),
        content:  const Text('Ex labore deserunt sit velit irure cupidatat officia laborum sit. Laboris elit est cillum proident et cillum duis et. Aliquip cillum irure nisi anim tempor. Officia amet do magna mollit ipsum et esse dolore nostrud aute consequat ea ad.'),
        actions: [
          TextButton(onPressed: () => context.pop(), child: const Text('Cancelar')),

          TextButton(onPressed: () => context.pop() , child: const Text('Aceptar')),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Snackbars y Dialogos'),
      ),


      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            FilledButton.tonal(
              onPressed: () {
                showAboutDialog(context: context,
                children: [
                  const Text(
                    'Lorem nostrud commodo fugiat ad id occaecat cupidatat enim pariatur laboris. Minim nostrud sit culpa reprehenderit ullamco ut aliquip. Aliqua duis nisi magna sit minim nulla id id nisi cillum deserunt excepteur exercitation.'
                  )
                ]);
              }, 
              child: const Text('Licencas usadas')
            ),

            FilledButton.tonal(
              onPressed: () {
                openDialog(context);
              }, 
              child: const Text('Mostra dialogo')
            ),

          ],
        ),
      ),



      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Mostrat SnackBar'),
        icon: const Icon( Icons.record_voice_over_outlined ),
        onPressed: () => showCustomSnackBar(context), ),
    );
  }
}