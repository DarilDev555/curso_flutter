import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ButtonsScreen extends StatelessWidget {
  const ButtonsScreen({super.key});

  static const name = 'buttons_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buttons Sreen'),
      ),
      body: const _ButtonsView(),
      floatingActionButton: FloatingActionButton(
        child: const Icon( Icons.arrow_back_ios_new_rounded),
        onPressed: () {
          context.pop();
        }),
    );
  }
}

class _ButtonsView extends StatelessWidget {
  const _ButtonsView();

  
  @override
  Widget build(BuildContext context) {
  
  final colors = Theme.of(context).colorScheme;

  
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Wrap(
          spacing: 10,
          alignment: WrapAlignment.center,
          children: [
            ElevatedButton(onPressed: () {}, child: const Text('Elevatedn')),

            const ElevatedButton(onPressed: null, child: Text('Elevated Disable')),

            ElevatedButton.icon(onPressed: () {}, 
            icon: const Icon(Icons.account_box_rounded),
            label: const Text('ElevatedButton')),

            FilledButton(onPressed: () {}, child: const Text('Filled')),

            FilledButton.icon(
              onPressed: null,
              icon: const Icon(Icons.accessibility_new),
              label: const Text('Filled icon')
            ),

            OutlinedButton(onPressed: () {}, child: const Text('Outlne')),
            
            OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.account_balance_wallet_rounded) ,  label: const Text('Outlne')),
            
            TextButton(onPressed: () {}, child: const Text('Text')),
            
            TextButton.icon(onPressed: () {}, icon: const Icon(Icons.air_sharp),label: const Text('Text')),
            
            IconButton(onPressed: (){}, icon: const Icon(Icons.add_circle_sharp)),
                        
            IconButton(onPressed: (){}, 
            icon: const Icon(Icons.add_circle_sharp),
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(colors.primary)
            ),),

            const _CustomButton()
            
          ],
        ),
      ),
    );
  }
}


class _CustomButton extends StatelessWidget {
  const _CustomButton();
  

  @override
  Widget build(BuildContext context) {
  final colors = Theme.of(context).colorScheme;
  
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Material(
        color: colors.primary,
        child: InkWell(
          onTap: () {},
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Text('Custom Button', style: TextStyle( color: Colors.white)),
            
            ),
        ),
      ),
    );
  }
}