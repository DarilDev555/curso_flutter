import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth/auth_provider.dart';
import '../../providers/storage/local_teachers_provider.dart';
import '../../providers/teachers/teachers_provider.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../domain/entities/teacher.dart';
import 'package:flutter/material.dart';

import '../../widgets/attendance_record/teacher_card.dart';
import '../../widgets/attendance_record/teacher_slideshow.dart';

/// Implementation of Mobile Scanner example with simple configuration
class AttendanceScannerQr extends ConsumerStatefulWidget {
  final int idAttendance;

  /// Constructor for simple Mobile Scanner example
  const AttendanceScannerQr({super.key, required this.idAttendance});

  @override
  AttendanceScannerQrState createState() => AttendanceScannerQrState();
}

class AttendanceScannerQrState extends ConsumerState<AttendanceScannerQr> {
  Barcode? _barcodePrevius;
  Barcode? _barcode;
  bool isLoading = false;

  Future<Widget> _barcodePreview(
    Barcode? value,
    idAttendance,
    accessToken,
  ) async {
    if (_barcodePrevius != null &&
        value != null &&
        _barcodePrevius!.displayValue == value.displayValue) {}
    if (value == null) {
      return const Text(
        'Escanea Qr para registrar asistencia',
        overflow: TextOverflow.fade,
        style: TextStyle(color: Colors.white),
      );
    }

    Teacher tempTeacher = await ref
        .read(getTeachersProvider.notifier)
        .getTeacher(id: value.displayValue!);

    tempTeacher.idAttendance = idAttendance;

    return TeacherCard(
      teacher: tempTeacher,
      accessToken: accessToken,
      height: 70,
      width: 70,
      isJustAvatar: false,
      backGroundColor: '#4c0c20',
      callBackAddTEacher: (idTeacher) {
        setState(() {
          _barcode = null;
        });
        ref
            .read(localTeachersProvider.notifier)
            .toggleSaveOrRemove(tempTeacher);
      },
      callBackCancelTEacher: () {
        setState(() {
          _barcode = null;
        });
      },
    );
  }

  void _handleBarcode(BarcodeCapture barcodes) {
    if (mounted) {
      setState(() {
        _barcode = barcodes.barcodes.firstOrNull;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final colors = Theme.of(context).colorScheme;
    final accessToken = ref.watch(authProvider).user!.token;

    return Scaffold(
      appBar: AppBar(title: const Text('Evento ... dia ... ')),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(onDetect: _handleBarcode),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              alignment: Alignment.topRight,
              height: 165,
              width: 125,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Center(
                      child: TeacherSlideshow(
                        idAttendance: widget.idAttendance,
                        width: 80,
                        height: 80,
                        cardIsJustAvatar: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 170,
              width: 350,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Center(
                      child: FutureBuilder(
                        future: _barcodePreview(
                          _barcode,
                          widget.idAttendance,
                          accessToken,
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator(); // mientras espera
                          } else if (snapshot.hasError) {
                            return Text(
                              'Error: ${snapshot.error}',
                            ); // si ocurre un error
                          } else if (snapshot.hasData) {
                            return snapshot.data!;
                            // si hay datos
                          } else {
                            return const Text('No hay datos');
                          }
                        },
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
