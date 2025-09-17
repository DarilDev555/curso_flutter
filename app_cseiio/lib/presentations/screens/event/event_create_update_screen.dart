import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:tinycolor2/tinycolor2.dart';
import '../../providers/events/event_create_from_provider.dart';
import '../../widgets/shared/custom_filled_button.dart';
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
                        context.go('/events-screen');
                      },
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Crear evento',
                      style: textStyles.titleLarge?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: size.height * 0.01),

                Container(
                  // 80 los dos sizebox y 100 el ícono
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(100),
                    ),
                  ),
                  child: const _CreateUpdateEventRegister(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CreateUpdateEventRegister extends ConsumerWidget {
  const _CreateUpdateEventRegister();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(eventCreateFromProvider, (previous, next) {
      if (previous == null) return;
      if (!previous.isValidEvent && next.isValidEvent) {
        if (context.mounted) {
          context.go('/event-days-create-update-screen');
        }
      }
    });

    final createEventFormProvider = ref.watch(eventCreateFromProvider);
    final textStyles = Theme.of(context).textTheme;
    final ColorScheme colors = Theme.of(context).colorScheme;
    final errorDate = errorMessageToCheckEventApi(
      errorMessage: createEventFormProvider.daysEvent.errorMessage,
      errorApi: createEventFormProvider.errors?['event_dates'],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text('Datos del evento', style: textStyles.titleMedium),
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

          CustomTextFormField(
            label: 'Nombre',
            keyboardType: TextInputType.text,
            inicialValue: createEventFormProvider.name.value,
            onChanged: (value) {
              ref.read(eventCreateFromProvider.notifier).onNameChange(value);
            },
            errorMessage:
                createEventFormProvider.isFormPosted
                    ? errorMessageToCheckEventApi(
                      errorApi: createEventFormProvider.errors?['name'],
                      errorMessage: createEventFormProvider.name.errorMessage,
                    )
                    : null,
          ),
          const SizedBox(height: 30),
          CustomTextFormField(
            label: 'Descripcion',
            keyboardType: TextInputType.text,
            heigth: 95,
            maxLines: 3,
            inicialValue: createEventFormProvider.description.value,
            onChanged: (value) {
              ref
                  .read(eventCreateFromProvider.notifier)
                  .onDescriptionChange(value);
            },
            errorMessage:
                createEventFormProvider.isFormPosted
                    ? errorMessageToCheckEventApi(
                      errorApi: createEventFormProvider.errors?['description'],
                      errorMessage:
                          createEventFormProvider.description.errorMessage,
                    )
                    : null,
          ),

          const SizedBox(height: 30),
          SfDateRangePicker(
            initialDisplayDate:
                (createEventFormProvider.daysEvent.value.isNotEmpty)
                    ? createEventFormProvider.daysEvent.value.first
                    : null,
            enablePastDates: false,
            selectionMode: DateRangePickerSelectionMode.multiple,
            initialSelectedDates:
                createEventFormProvider.daysEvent.value.isEmpty
                    ? null
                    : createEventFormProvider.daysEvent.value,
            initialSelectedRange:
                createEventFormProvider.daysEvent.isPure ||
                        createEventFormProvider.daysEvent.value.isEmpty
                    ? null
                    : PickerDateRange(
                      createEventFormProvider.daysEvent.value.first,
                      createEventFormProvider.daysEvent.value.last,
                    ),
            onSelectionChanged: (dateRangePickerSelectionChangedArgs) {
              final value =
                  dateRangePickerSelectionChangedArgs.value as List<DateTime>;

              value.sort((a, b) => a.compareTo(b));
              ref
                  .read(eventCreateFromProvider.notifier)
                  .onDaysEventChange(value);
            },
          ),

          Container(
            height:
                createEventFormProvider.isFormPosted
                    ? errorDate != null
                        ? 25
                        : 0
                    : 0,
            width: double.infinity,
            color: TinyColor.fromString("#eee9f5").color,
            child:
                errorDate != null
                    ? Text(errorDate, style: TextStyle(color: colors.error))
                    : const SizedBox.shrink(),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 35,
            child: CustomFilledButton(
              text: 'Siguiente',
              buttonColor: Colors.black,
              onPressed: () {
                ref.read(eventCreateFromProvider.notifier).onFormSumit();
              },
            ),
          ),
        ],
      ),
    );
  }

  String? errorMessageToCheckEventApi({
    String? errorApi,
    String? secondErrorApi,
    String? errorMessage,
    String? donde,
  }) {
    return errorMessage ??
        (errorApi != null && secondErrorApi != null
            ? '$errorApi/n$secondErrorApi'
            : errorApi ?? secondErrorApi);
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
          height: 0,
        ),
      ],
    );
  }
}
