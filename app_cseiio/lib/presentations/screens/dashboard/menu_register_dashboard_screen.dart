import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MenuRegisterDashboardScreen extends StatelessWidget {
  const MenuRegisterDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(color: Colors.black45, blurRadius: 10, offset: Offset(0, 15)),
      ],
    );
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;
    return Wrap(
      direction: Axis.horizontal,
      children:
      // appMenuItemss
      //     .map(
      //       (e) => ItemMenu(
      //         icon: e.icon,
      //         title: e.title,
      //         subTitle: e.subTitle,
      //         link: e.link,
      //         colors: colors,
      //         textStyle: textStyle,
      //       ),
      //     )
      //     .toList(),
      [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DecoratedBox(
            decoration: decoration,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: GestureDetector(
                onTap: () {
                  context.push('/events-screen');
                },
                child: Container(
                  width: 2500,
                  height: 150,
                  decoration: BoxDecoration(color: colors.surfaceContainer),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      direction: Axis.vertical,
                      alignment: WrapAlignment.center,
                      children: [
                        Icon(
                          Icons.assignment_ind_rounded,
                          size: 45.0,
                          color: colors.primary,
                        ),
                        Text(
                          'Registrar Asistencia',
                          style: textStyle.titleLarge,
                        ),
                        Text(
                          'Mostrar eventos para asignar una asistencia',
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
        ),
      ],
    );
  }
}
