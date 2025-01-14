import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:widgets_app/config/menu/menu_items.dart';
//import 'package:widgets_app/config/presentation/screens/buttons/buttons_screen.dart';

class HomeScreen extends StatelessWidget {

  static const name = 'home_screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter + Material 3'),
      ),
      body: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: appMenuItemss.length,
      itemBuilder: (BuildContext context, int index) {
        final menuItem = appMenuItemss[index];

      return _CustomListTitle(menuItem: menuItem);
    },
      
    );
  }
}

class _CustomListTitle extends StatelessWidget {
  const _CustomListTitle({
    required this.menuItem,
  });

  final MenuItems menuItem;

  @override
  Widget build(BuildContext context) {
    
    final colors = Theme.of(context).colorScheme;

    return ListTile(
      leading: Icon(menuItem.icon, color: colors.primary,),
      trailing: const Icon(Icons.arrow_forward_ios_rounded),
      title: Text( menuItem.title ),
      subtitle: Text( menuItem.subTitle ),
      onTap: () {

//        Navigator.pushNamed(context, menuItem.link);
        context.push(menuItem.link); 
        
      },
    );
  }
} 

