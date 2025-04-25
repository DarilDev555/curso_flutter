import '../../../providers/auth/auth_provider.dart';
import '../../../widgets/shared/custom_avatar_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/menu/menu_items.dart';
import '../../../widgets/widgets.dart';

class DashboardScreen extends ConsumerWidget {
  static const name = 'dashboard_screen.dart';
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user!.role.name;
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: const CustomAvatarAppbar(),
        title: const Text('Dashboard'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(color: colors.primary),
                  child: Center(
                    child: TextFrave(
                      text: 'Bienvenido',
                      textAlign: TextAlign.center,
                      color: colors.onPrimary,
                      fontSize: 30,
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 290,
                  child: Icon(
                    Icons.blur_on_outlined,
                    color: colors.inversePrimary.withAlpha(50),
                    size: 120,
                  ),
                ),
                Positioned(
                  top: -10,
                  left: -40,
                  child: Icon(
                    Icons.lens_blur_sharp,
                    color: colors.inversePrimary.withAlpha(50),
                    size: 120,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child:
                user == 'Manager'
                    ? Wrap(
                      direction: Axis.horizontal,
                      children:
                          appMenuItemss
                              .map(
                                (e) => ItemMenu(
                                  icon: e.icon,
                                  title: e.title,
                                  subTitle: e.subTitle,
                                  link: e.link,
                                  colors: colors,
                                  textStyle: textStyle,
                                ),
                              )
                              .toList(),
                    )
                    : ItemMenu(
                      icon: Icons.calendar_month_outlined,
                      title: 'Eventos Asignados',
                      subTitle: 'Retistrar Asistencias',
                      link: '/events-screen',
                      colors: colors,
                      textStyle: textStyle,
                      width: 200,
                    ),
          ),
        ],
      ),
    );
  }
}

class ItemMenu extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subTitle;
  final String link;
  final ColorScheme colors;
  final TextTheme textStyle;
  final double height;
  final double width;
  const ItemMenu({
    super.key,
    required this.icon,
    required this.title,
    required this.subTitle,
    required this.link,
    required this.colors,
    required this.textStyle,
    this.height = 120,
    this.width = 170,
  });

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(color: Colors.black45, blurRadius: 10, offset: Offset(0, 15)),
      ],
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
        decoration: decoration,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: GestureDetector(
            onTap: () {
              context.push(link);
            },
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(color: colors.surfaceContainer),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  direction: Axis.vertical,
                  alignment: WrapAlignment.center,
                  children: [
                    Icon(icon, size: 45.0, color: colors.primary),
                    Text(title, style: textStyle.titleLarge),
                    Text(
                      subTitle,
                      style: textStyle.labelMedium,
                      overflow: TextOverflow.visible,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
