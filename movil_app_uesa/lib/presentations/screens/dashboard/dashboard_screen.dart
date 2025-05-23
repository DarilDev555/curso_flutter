import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movil_app_uesa/config/menu/menu_items.dart';
import 'package:movil_app_uesa/presentations/widgets/widgets.dart';

class DashboardScreen extends StatelessWidget {
  static const name = 'dashboard_screen.dart';
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(4.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(
                'https://media.licdn.com/dms/image/v2/D4E03AQG9vivTumsTUQ/profile-displayphoto-shrink_200_200/profile-displayphoto-shrink_200_200/0/1729615646699?e=1741824000&v=beta&t=AmdFYtf9vHHVlFQg9hB0Q--c2zUxvvTMpAdjb7gxUSs'),
          ),
        ),
        title: const Text(
          'Dashboard',
          textAlign: TextAlign.center,
        ),
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
                  decoration: BoxDecoration(
                    color: colors.primary,
                  ),
                  child: Center(
                    child: TextFrave(
                      text: 'Bienvnido',
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
            child: Wrap(
              direction: Axis.horizontal,
              children: appMenuItemss
                  .map(
                    (e) => itemMenu(
                      icon: e.icon,
                      title: e.title,
                      subTitle: e.subTitle,
                      link: e.link,
                      colors: colors,
                      textStyle: textStyle,
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class itemMenu extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subTitle;
  final String link;
  final ColorScheme colors;
  final TextTheme textStyle;
  const itemMenu({
    super.key,
    required this.icon,
    required this.title,
    required this.subTitle,
    required this.link,
    required this.colors,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
              color: Colors.black45, blurRadius: 10, offset: Offset(0, 15)),
        ]);

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
              width: 170,
              height: 120,
              decoration: BoxDecoration(
                color: colors.surfaceContainer,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  direction: Axis.vertical,
                  alignment: WrapAlignment.center,
                  children: [
                    Icon(
                      icon,
                      size: 45.0,
                      color: colors.primary,
                    ),
                    Text(
                      title,
                      style: textStyle.titleLarge,
                    ),
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
