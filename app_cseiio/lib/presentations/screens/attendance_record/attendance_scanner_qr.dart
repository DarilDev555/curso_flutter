import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tinycolor2/tinycolor2.dart';

import '../../providers/attendance/qr_teacher_provider.dart';
import '../../providers/auth/auth_provider.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/material.dart';

import '../../widgets/attendance_record/teacher_card.dart';
import '../../widgets/attendance_record/teacher_slideshow.dart';

/// Implementation of Mobile Scanner example with simple configuration
class AttendanceScannerQr extends ConsumerWidget {
  final int idAttendance;

  /// Constructor for simple Mobile Scanner example
  const AttendanceScannerQr({super.key, required this.idAttendance});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accessToken = ref.watch(authProvider).user!.token;
    final qrTeacher = ref.watch(qrTeachaerProvider);
    final layoutSize = MediaQuery.of(context).size;
    final double scanWindowWidth = layoutSize.width;
    final double scanWindowHeight = layoutSize.height;

    return Scaffold(
      appBar: AppBar(title: const Text('Evento ... dia ... ')),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            scanWindow: Rect.fromLTWH(
              scanWindowWidth * 0.25,
              scanWindowHeight * 0.25,
              scanWindowWidth * 0.5,
              scanWindowWidth * 0.5,
            ),
            overlayBuilder: (context, _) {
              final width = layoutSize.width;
              final height = layoutSize.height;

              final left = width * 0.25;
              final top = height * 0.25;
              final size = width * 0.5;

              return Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      height: height * 0.25,
                      width: height,
                      color: Colors.black45,
                    ),
                  ),
                  Positioned(
                    top: height * 0.25,
                    left: width * 0.75,
                    child: Container(
                      height: size,
                      width: width * 0.25,
                      color: Colors.black45,
                    ),
                  ),
                  Positioned(
                    top: height * 0.25 + size,
                    left: 0,
                    child: Container(
                      height: height - (height * 0.25 + width * 0.5),
                      width: height,
                      color: Colors.black45,
                    ),
                  ),
                  Positioned(
                    top: height * 0.25,
                    left: 0,
                    child: Container(
                      height: size,
                      width: width * 0.25,
                      color: Colors.black45,
                    ),
                  ),

                  // Cuadrado de escaneo
                  Positioned(
                    left: left,
                    top: top,
                    width: size,
                    height: size,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: TinyColor.fromString('#a12f53').color,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },

            placeholderBuilder:
                (context) => const Center(child: CircularProgressIndicator()),

            onDetect: (barcodes) {
              final value = barcodes.barcodes.firstOrNull;
              if (value == null) return;
              ref
                  .read(qrTeachaerProvider.notifier)
                  .changeQr(value.displayValue.toString(), idAttendance);
            },
          ),

          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.topLeft,
                height: layoutSize.height * 0.15,
                width: layoutSize.width * 0.65,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Center(
                        child: TeacherSlideshow(
                          idAttendance: idAttendance,
                          widthAvatar: layoutSize.height * 0.055,
                          heightAvatar: layoutSize.height * 0.055,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: layoutSize.height * 0.24,
              width: layoutSize.width * 0.65,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Center(
                      child: _QrTeacher(
                        qrTeacherState: qrTeacher,
                        accessToken: accessToken,
                        summit: ref.read(qrTeachaerProvider.notifier).summit,
                        cancelSummit:
                            ref.read(qrTeachaerProvider.notifier).cancelSummit,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QrTeacher extends StatelessWidget {
  final QrTeacherState qrTeacherState;
  final String accessToken;
  final Future<void> Function() summit;
  final Future<void> Function() cancelSummit;

  const _QrTeacher({
    required this.qrTeacherState,
    required this.accessToken,
    required this.summit,
    required this.cancelSummit,
  });

  @override
  Widget build(BuildContext context) {
    if (qrTeacherState.teacher == null) {
      return const Text(
        'Escanea Qr para registrar asistencia',
        overflow: TextOverflow.fade,
        style: TextStyle(color: Colors.white),
      );
    }

    if (qrTeacherState.isLoading) {
      return const CircularProgressIndicator();
    }

    return Stack(
      children: [
        TeacherCard(
          teacher: qrTeacherState.teacher!,
          accessToken: accessToken,
          heightAvatar: 85,
          widthAvatar: 85,
          backGroundColor: '#88163a',
          callBackAddTEacher: (qrTeacherState.isSummit) ? () {} : summit,
          callBackCancelTEacher:
              (qrTeacherState.isSummit) ? () {} : cancelSummit,
        ),

        (qrTeacherState.isSummit)
            ? Container(
              color: Colors.black54,
              child: const Center(child: CircularProgressIndicator()),
            )
            : const SizedBox.shrink(),
      ],
    );
  }
}
