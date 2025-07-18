import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tinycolor2/tinycolor2.dart';

import '../../widgets/shared/custom_text_form_field.dart';
import '../../widgets/shared/geometrical_background.dart';
import '../../widgets/shared/text_frave.dart';

class EventCreateUpdateScreen extends StatelessWidget {
  static const name = 'event-create-update-screen';
  const EventCreateUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textStyles = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: GeometricalBackground(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.05),
                // Icon Banner
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        // context.go('/register');
                      },
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Crear cuenta',
                      style: textStyles.titleLarge?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: size.height * 0.01),

                Container(
                  height: size.height, // 80 los dos sizebox y 100 el ícono
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(100),
                    ),
                  ),
                  child: _CreateUpdateEventRegister(),
                ),
              ],
            ),
          ),
        ),
        // appBar: AppBar(
        //   title: const TextFrave(
        //     text: 'Creacion de Evento',
        //     fontSize: 32,
        //     color: Colors.white,
        //   ),
        //   iconTheme: const IconThemeData(color: Colors.white, size: 32),
        //   backgroundColor: TinyColor.fromString('#18976f').color,
        // ),
        // body: const Column(
        //   children: [
        //     Padding(
        //       padding: EdgeInsets.only(left: 32.0, top: 16, bottom: 8),
        //       child: TextFrave(text: 'Nuevo Evento', fontSize: 30),
        //     ),
        //     SizedBox(height: 20),
        //     Padding(
        //       padding: EdgeInsets.all(32.0),
        //       child: CustomTextFormField(label: 'Nombre'),
        //     ),
        //     Padding(
        //       padding: EdgeInsets.all(32.0),
        //       child: CustomTextFormField(label: 'Descripcion'),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}

class _CreateUpdateEventRegister extends StatelessWidget {
  const _CreateUpdateEventRegister({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text('Datos Personales', style: textStyles.titleMedium),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: Text(
              'Evento',
              style: textStyles.titleLarge,
              textAlign: TextAlign.start,
            ),
          ),
          const SizedBox(height: 20),

          CustomTextFormField(label: 'Nombre'),
          const SizedBox(height: 30),
          CustomTextFormField(
            label: 'Descripcion',
            keyboardType: TextInputType.text,
            heigth: 95,
            maxLines: 3,
          ),

          const SizedBox(height: 30),
          CustomTextFormField(label: 'Fecha'),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Text(
                  'Dias del evento',
                  style: textStyles.titleLarge,
                  textAlign: TextAlign.start,
                ),
                SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: TinyColor.fromString('#46ac8c').color,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    iconSize: 30,
                    onPressed: () {},
                    icon: const Icon(Icons.add_outlined),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // const SizedBox(height: 30),
          Column(spacing: 10, children: [DayView(), DayView()]),
        ],
      ),
    );
  }
}

class DayView extends StatelessWidget {
  const DayView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: TinyColor.fromString('#46ac8c').color,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(8),
                height: 50,
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: TextFrave(text: 'Dia 1'),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: TinyColor.fromString('#46ac8c').color,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.edit_note_outlined),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: TinyColor.fromString('#46ac8c').color,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.delete_forever_rounded),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          decoration: BoxDecoration(
            color: TinyColor.fromString('#46ac8c').color,
            borderRadius: BorderRadius.circular(20),
          ),
          curve: Curves.bounceOut,
          padding: const EdgeInsets.all(8),
          height: 100,
        ),
      ],
    );
  }
}
