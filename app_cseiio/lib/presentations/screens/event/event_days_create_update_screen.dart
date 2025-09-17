import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tinycolor2/tinycolor2.dart';

import '../../../config/helpers/human_formats.dart';
import '../../../domain/entities/entities.dart';
import '../../providers/attendance/attendance_create_form_provider.dart';
import '../../providers/events/event_create_from_provider.dart';
import '../../providers/events/event_days_create_from_provider.dart';
import '../../widgets/widgets.dart';

class EventDaysCreateUpdateScreen extends ConsumerWidget {
  static const name = 'event-days-create-update-screen';
  const EventDaysCreateUpdateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                SizedBox(height: size.height * 0.02),
                // Header mejorado
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          onPressed: () {
                            ref
                                .read(eventCreateFromProvider.notifier)
                                .returnToScreen();
                            context.go('/events-screen');
                          },
                          icon: const Icon(
                            Icons.arrow_back_rounded,
                            size: 28,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Text(
                        'Configurar Días del Evento',
                        style: textStyles.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          shadows: [
                            Shadow(
                              offset: const Offset(0, 2),
                              blurRadius: 4,
                              color: Colors.black.withValues(alpha: 0.3),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: size.height * 0.03),

                Container(
                  width: double.infinity,
                  height: size.height * 0.88,
                  decoration: BoxDecoration(
                    color: scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: const _CreateUpdateEventDays(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CreateUpdateEventDays extends ConsumerWidget {
  const _CreateUpdateEventDays();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(eventCreateFromProvider, (previous, next) {
      if (previous == null) return;
      if (previous.isValidEvent && !next.isValidEvent) {
        if (context.mounted) {
          context.go('/event-create-update-screen');
        }
      }
    });

    ref.listen(eventDaysFrom, (previous, next) {
      if (next.eventCreated) {
        if (context.mounted) {
          context.go('/events-screen');
        }
      }
    });

    final size = MediaQuery.of(context).size;
    final eventCreatedProvider = ref.watch(eventCreateFromProvider);
    final eventCreated = eventCreatedProvider.event;
    final eventDays = ref.watch(eventDaysFrom);

    if (eventCreated == null) {
      return SizedBox(
        height: size.height * 0.7,
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFa12f53)),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
      child: Column(
        children: [
          // Indicador de progreso
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: TinyColor.fromString('#a12f53').color,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: TinyColor.fromString(
                        '#a12f53',
                      ).color.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      eventCreatedProvider.event!.name.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${eventCreatedProvider.event!.eventdays!.length} días configurados',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton.filled(
                onPressed: () {
                  final event = ref.watch(eventDaysFrom).event;
                  if (event == null) {
                    return;
                  }
                  ref.read(eventCreateFromProvider.notifier).editEvent(event);
                },
                icon: const Icon(Icons.edit_outlined),
                style: IconButton.styleFrom(
                  backgroundColor: TinyColor.fromString('#a12f53').color,
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          SizedBox(
            height: size.height * 0.60,
            child: Swiper(
              itemCount:
                  (eventCreatedProvider.event!.eventdays != null)
                      ? eventCreatedProvider.event!.eventdays!.length
                      : 0,
              viewportFraction: 0.88,
              scale: 0.92,
              autoplay: false,
              loop: false,
              pagination: SwiperPagination(
                margin: const EdgeInsets.only(bottom: 15),
                builder: DotSwiperPaginationBuilder(
                  activeColor: TinyColor.fromString('#a12f53').color,
                  color: TinyColor.fromString(
                    '#cb8ca0',
                  ).color.withValues(alpha: 0.5),
                  size: 10,
                  activeSize: 12,
                  space: 6,
                ),
              ),
              itemBuilder: (context, index) {
                return _CardEventDay(indexEventDay: index);
              },
            ),
          ),

          // Botón para crear el evento
          Container(
            width: double.infinity,
            height: 56,
            margin: const EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  TinyColor.fromString('#18976f').color,
                  TinyColor.fromString('#d1eae2').color,
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: TinyColor.fromString(
                    '#a12f53',
                  ).color.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) {
                      return Dialog(
                        backgroundColor: Colors.transparent,
                        child: Container(
                          width: size.width * 0.85,
                          height: size.height * 0.4,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white,
                                  TinyColor.fromString(
                                    '#fff0f6',
                                  ).color.withValues(alpha: 0.3),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),

                            child: Column(
                              children: [
                                // Header con icono y texto mejorado
                                Container(
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    children: [
                                      // Icono principal
                                      Container(
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          color: TinyColor.fromString(
                                            '#a12f53',
                                          ).color.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(
                                            50,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.save_outlined,
                                          size: 48,
                                          color:
                                              TinyColor.fromString(
                                                '#a12f53',
                                              ).color,
                                        ),
                                      ),

                                      const SizedBox(height: 20),

                                      // Título principal
                                      Text(
                                        'Confirmar Guardado',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              TinyColor.fromString(
                                                '#a12f53',
                                              ).color,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),

                                      const SizedBox(height: 12),

                                      // Mensaje descriptivo
                                      Text(
                                        '¿Está seguro que desea guardar el evento?',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600],
                                          height: 1.4,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),

                                      const SizedBox(height: 8),

                                      // Mensaje adicional
                                      Text(
                                        'Esta acción creará el evento con todos los días y asistencias configuradas.',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[500],
                                          height: 1.3,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),

                                // Espacio flexible para empujar los botones hacia abajo
                                const Spacer(),

                                // Botones de acción
                                Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Row(
                                    children: [
                                      // Botón cerrar
                                      Expanded(
                                        child: Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              color: Colors.grey[300]!,
                                            ),
                                          ),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              onTap:
                                                  () => Navigator.pop(context),
                                              child: const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.close,
                                                    color: Colors.grey,
                                                    size: 20,
                                                  ),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    'Cerrar',
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(width: 12),

                                      // Botón guardar
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color:
                                                TinyColor.fromString(
                                                  '#a12f53',
                                                ).color,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: TinyColor.fromString(
                                                  '#a12f53',
                                                ).color.withValues(alpha: 0.3),
                                                blurRadius: 8,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              onTap: () {
                                                ref
                                                    .read(
                                                      eventDaysFrom.notifier,
                                                    )
                                                    .onFormSumit();
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  if (eventDays.isSumit)
                                                    const SizedBox(
                                                      width: 20,
                                                      height: 20,
                                                      child: CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                              Color
                                                            >(Colors.white),
                                                      ),
                                                    )
                                                  else
                                                    const Icon(
                                                      Icons.save,
                                                      color: Colors.white,
                                                      size: 20,
                                                    ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    eventDays.isSumit
                                                        ? 'Guardando...'
                                                        : 'Guardar Evento',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.rocket_launch_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Guardar Evento',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardEventDay extends ConsumerStatefulWidget {
  final int indexEventDay;
  const _CardEventDay({required this.indexEventDay});

  @override
  _CardEventDayState createState() => _CardEventDayState();
}

class _CardEventDayState extends ConsumerState<_CardEventDay> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(eventDaysFrom.notifier).createinicialState();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final eventDaysCreateFrom = ref.watch(eventDaysFrom);

    if (eventDaysCreateFrom.event?.eventdays == null ||
        eventDaysCreateFrom.event!.eventdays!.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFa12f53)),
        ),
      );
    }

    final eventDay =
        eventDaysCreateFrom.event!.eventdays![widget.indexEventDay];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            TinyColor.fromString('#f5e8ec').color.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header del día mejorado
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              width: double.infinity,
              decoration: BoxDecoration(
                color: TinyColor.fromString('#a12f53').color,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: TinyColor.fromString(
                      '#a12f53',
                    ).color.withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Día ${eventDay.numDay}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          maxLines: 2,
                          HumanFormats.formatDateWithNameDay(
                            eventDay.dateDayEvent,
                          ),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Lista de asistencias mejorada
            Expanded(
              child:
                  (eventDay.attendances == null ||
                          eventDay.attendances!.isEmpty)
                      ? _EmptyAttendancesWidget()
                      : ListView.builder(
                        itemCount: eventDay.attendances!.length,
                        itemBuilder: (context, index) {
                          final attendance = eventDay.attendances![index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: _ViewAttendance(
                              attendance: attendance,
                              onTap:
                                  () => _showAttendanceDialog(
                                    context,
                                    size,
                                    eventDay,
                                    attendance,
                                  ),
                            ),
                          );
                        },
                      ),
            ),

            const SizedBox(height: 16),

            // Botón agregar mejorado
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                color: TinyColor.fromString('#a12f53').color,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: TinyColor.fromString(
                      '#a12f53',
                    ).color.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap:
                      () => _showNewAttendanceDialog(context, size, eventDay),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_circle_outline,
                        color: Colors.white,
                        size: 24,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Agregar Asistencia',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAttendanceDialog(
    BuildContext context,
    Size size,
    EventDay eventDay,
    Attendance attendance,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              width: size.width * 0.85,
              height: size.height * 0.7,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: _AttendanceEditForm(
                times:
                    eventDay.attendances
                        ?.map((e) => TimeOfDay.fromDateTime(e.attendanceTime))
                        .toList(),
                attendance: attendance,
                idDayEvent: eventDay.id.toString(),
                dateDayEvent: eventDay.dateDayEvent,
              ),
            ),
          ),
    );
  }

  void _showNewAttendanceDialog(
    BuildContext context,
    Size size,
    EventDay eventDay,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              width: size.width * 0.85,
              height: size.height * 0.7,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: _AttendanceEditForm(
                times:
                    eventDay.attendances
                        ?.map((e) => TimeOfDay.fromDateTime(e.attendanceTime))
                        .toList(),
                attendance: Attendance(
                  name: '',
                  descripcion: '',
                  attendanceTime: DateTime(999, 1, 1, 15, 0),
                ),
                idDayEvent: eventDay.id.toString(),
                dateDayEvent: eventDay.dateDayEvent,
                isNewAttendance: true,
              ),
            ),
          ),
    );
  }
}

class _EmptyAttendancesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: TinyColor.fromString('#f5e8ec').color.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: TinyColor.fromString('#cb8ca0').color.withValues(alpha: 0.3),
          style: BorderStyle.solid,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: TinyColor.fromString(
                '#cb8ca0',
              ).color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.schedule_outlined,
              size: 48,
              color: TinyColor.fromString(
                '#a12f53',
              ).color.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Sin asistencias',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: TinyColor.fromString('#a12f53').color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Agrega la primera asistencia\npara este día',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: TinyColor.fromString(
                '#a12f53',
              ).color.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _ViewAttendance extends StatelessWidget {
  const _ViewAttendance({required this.attendance, required this.onTap});

  final Attendance attendance;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.white,
            TinyColor.fromString('#fff0f6').color.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: TinyColor.fromString('#cb8ca0').color.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: TinyColor.fromString(
              '#a12f53',
            ).color.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: TinyColor.fromString(
                      '#a12f53',
                    ).color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.access_time,
                    color: TinyColor.fromString('#a12f53').color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        attendance.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: TinyColor.fromString('#a12f53').color,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        attendance.descripcion,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        TinyColor.fromString(
                          '#a12f53',
                        ).color.withValues(alpha: 0.1),
                        TinyColor.fromString(
                          '#cb8ca0',
                        ).color.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: TinyColor.fromString(
                        '#cb8ca0',
                      ).color.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    HumanFormats.formatTimeForSumitApi(
                      attendance.attendanceTime,
                    ),
                    style: TextStyle(
                      color: TinyColor.fromString('#a12f53').color,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: TinyColor.fromString('#cb8ca0').color,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AttendanceEditForm extends ConsumerWidget {
  final String idDayEvent;
  final DateTime dateDayEvent;
  final Attendance attendance;
  final bool isNewAttendance;
  final List<TimeOfDay>? times;

  const _AttendanceEditForm({
    required this.idDayEvent,
    required this.dateDayEvent,
    required this.attendance,
    this.isNewAttendance = false,
    required this.times,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final textStyles = Theme.of(context).textTheme;
    final attendanceCreate = ref.watch(
      attendanceCreateFormProvider(attendance),
    );

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            TinyColor.fromString('#fff0f6').color.withValues(alpha: 0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          // Header del formulario
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: TinyColor.fromString('#a12f53').color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isNewAttendance
                        ? Icons.add_circle_outline
                        : Icons.edit_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    isNewAttendance ? 'Nueva Asistencia' : 'Editar Asistencia',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Contenido del formulario
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Campo Nombre
                  _buildFieldLabel('Nombre', Icons.label_outline),
                  const SizedBox(height: 8),
                  _buildTextFormField(
                    context,
                    initialValue: attendance.name,
                    onChanged:
                        (value) => ref
                            .read(
                              attendanceCreateFormProvider(attendance).notifier,
                            )
                            .onNameChange(value),
                    errorMessage:
                        attendanceCreate.isFormPosted
                            ? errorMessageToCheckUserApi(
                              errorMessage: attendanceCreate.name.errorMessage,
                              errors: attendanceCreate.errors?['name'],
                            )
                            : null,
                  ),

                  const SizedBox(height: 20),

                  // Campo Descripción
                  _buildFieldLabel('Descripción', Icons.description_outlined),
                  const SizedBox(height: 8),
                  _buildTextFormField(
                    context,
                    initialValue: attendance.descripcion,
                    onChanged:
                        (value) => ref
                            .read(
                              attendanceCreateFormProvider(attendance).notifier,
                            )
                            .onDescriptionChange(value),
                    errorMessage:
                        attendanceCreate.isFormPosted
                            ? errorMessageToCheckUserApi(
                              errorMessage:
                                  attendanceCreate.description.errorMessage,
                              errors: attendanceCreate.errors?['description'],
                            )
                            : null,
                    maxLines: 3,
                  ),

                  const SizedBox(height: 20),

                  // Campo Hora
                  _buildFieldLabel('Hora', Icons.access_time_outlined),
                  const SizedBox(height: 8),
                  _buildTimeSelector(
                    context,
                    ref,
                    attendanceCreate,
                    colors,
                    textStyles,
                    attendanceCreate.isFormPosted,
                    errorMessageToCheckUserApi(
                      errorMessage:
                          attendanceCreate.timeAttendance.errorMessage,
                      errors: attendanceCreate.errors?['attendance_time'],
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),

          // Botones de acción
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: _buildActionButtons(context, ref, attendanceCreate),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: TinyColor.fromString('#a12f53').color),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: TinyColor.fromString('#a12f53').color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildTextFormField(
    BuildContext context, {
    required String initialValue,
    required ValueChanged<String> onChanged,
    String? errorMessage,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextFormField(
            inicialValue: initialValue,
            onChanged: onChanged,
            maxLines: maxLines,
          ),
          if (errorMessage != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Text(
                errorMessage,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTimeSelector(
    BuildContext context,
    WidgetRef ref,
    dynamic attendanceCreate,
    ColorScheme colors,
    TextTheme textStyles,
    bool isFormPosted,
    String? error,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: TinyColor.fromString('#cb8ca0').color.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () async {
            TimeOfDay? selectedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(attendance.attendanceTime),
              builder: (context, child) {
                final Widget mediaQueryWrapper = MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(alwaysUse24HourFormat: false),
                  child: child!,
                );
                // A hack to use the es_US dateTimeFormat value.
                if (Localizations.localeOf(context).languageCode == 'es') {
                  return Localizations.override(
                    context: context,
                    locale: const Locale('es', 'US'),
                    child: mediaQueryWrapper,
                  );
                }
                return mediaQueryWrapper;
              },
            );
            if (selectedTime != null) {
              ref
                  .read(attendanceCreateFormProvider(attendance).notifier)
                  .onTimeAttendanceChange(selectedTime, times: times);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: TinyColor.fromString(
                          '#a12f53',
                        ).color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.access_time,
                        color: TinyColor.fromString('#a12f53').color,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        (attendanceCreate.timeAttendance.isPure)
                            ? (isNewAttendance)
                                ? 'Selecciona hora de asistencia'
                                : HumanFormats.formateHourToTimeOfDay(
                                  attendanceCreate.timeAttendance.value!,
                                )
                            : (attendanceCreate.timeAttendance.value != null)
                            ? HumanFormats.formateHourToTimeOfDay(
                              attendanceCreate.timeAttendance.value!,
                            )
                            : 'Selecciona hora de asistencia',
                        style: TextStyle(
                          fontSize: 16,
                          color:
                              attendanceCreate.timeAttendance.value != null
                                  ? colors.onSurface
                                  : Colors.grey[500],
                        ),
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: TinyColor.fromString('#cb8ca0').color,
                    ),
                  ],
                ),
                (isFormPosted && error != null)
                    ? SizedBox(
                      width: double.infinity,
                      child: Text(
                        error,
                        textAlign: TextAlign.left,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    WidgetRef ref,
    dynamic attendanceCreate,
  ) {
    return Row(
      children: [
        // Botón eliminar (solo para asistencias existentes)
        if (!isNewAttendance) ...[
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red[300]!),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => _showDeleteConfirmation(context, ref),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete_outline, color: Colors.red, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Eliminar',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],

        // Botón cerrar
        Expanded(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => Navigator.pop(context),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.close, color: Colors.grey, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Cerrar',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        // Botón guardar
        Expanded(
          flex: 2,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: TinyColor.fromString('#a12f53').color,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: TinyColor.fromString(
                    '#a12f53',
                  ).color.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap:
                    attendanceCreate.isSumit
                        ? null
                        : () => _saveAttendance(context, ref),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (attendanceCreate.isSumit)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    else
                      const Icon(Icons.save, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      attendanceCreate.isSumit ? 'Guardando...' : 'Guardar',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.warning_amber_outlined,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(width: 12),
                const Text('Confirmar eliminación'),
              ],
            ),
            content: const Text(
              '¿Estás seguro de que deseas eliminar esta asistencia?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  ref
                      .read(eventDaysFrom.notifier)
                      .removeAttendance(attendance.id, idDayEvent);
                  Navigator.pop(context); // Cerrar confirmación
                  Navigator.pop(context); // Cerrar formulario
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Eliminar'),
              ),
            ],
          ),
    );
  }

  Future<void> _saveAttendance(BuildContext context, WidgetRef ref) async {
    final navigator = Navigator.of(context);
    final newAttendance = await ref
        .read(attendanceCreateFormProvider(attendance).notifier)
        .onFormSumit(dateDayEvent, times: times);

    if (newAttendance == null) return;

    if (isNewAttendance) {
      ref.read(eventDaysFrom.notifier).addAttendance(newAttendance, idDayEvent);
      if (context.mounted) navigator.pop();
      return;
    }

    ref
        .read(eventDaysFrom.notifier)
        .updateAttendance(newAttendance, idDayEvent);
    if (context.mounted) navigator.pop();
  }

  String? errorMessageToCheckUserApi({String? errorMessage, String? errors}) {
    return errorMessage ??
        (errors != null && errors.isNotEmpty ? errors : null);
  }
}
