import 'package:flutter/material.dart';
import 'package:tinycolor2/tinycolor2.dart';

import '../../../config/helpers/human_formats.dart';
import '../../../domain/entities/teacher.dart';
import '../shared/text_frave.dart';

class TeacherCard extends StatelessWidget {
  final Teacher teacher;
  final String accessToken;
  final double heightAvatar;
  final double widthAvatar;
  final EdgeInsetsGeometry? margin;
  final Color backGroundColor;
  final void Function()? callBackAddTEacher;
  final void Function()? callBackCancelTEacher;
  final bool viewHourRegister;

  TeacherCard({
    super.key,
    required this.teacher,
    required this.accessToken,
    required this.heightAvatar,
    required this.widthAvatar,
    this.callBackAddTEacher,
    this.callBackCancelTEacher,
    this.viewHourRegister = false,
    this.margin,
    backGroundColor = '#88163a',
  }) : backGroundColor = TinyColor.fromString(backGroundColor).color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: backGroundColor,
        boxShadow: [
          const BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 25, left: 30, right: 30),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    filterQuality: FilterQuality.none,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.image_not_supported_rounded,
                        size: heightAvatar - (heightAvatar * 0.2),
                        color: TinyColor.fromString('#b65d79').color,
                      );
                    },
                    teacher.avatar ?? '',
                    height: heightAvatar,
                    width: widthAvatar,
                    fit: BoxFit.cover,
                    headers: {"Authorization": "Bearer $accessToken"},
                  ),
                ),

                const SizedBox(width: 25),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFrave(
                        text:
                            '${teacher.firstName} ${teacher.paternalLastName} ${teacher.maternalLastName}',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: TinyColor.fromString('#f5e8ec').color,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 5),
                      (teacher.attendanceRegister != null && viewHourRegister)
                          ? TextFrave(
                            text:
                                'Registro: \n${HumanFormats.hourFormatToDatetime(teacher.attendanceRegister!)}',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: TinyColor.fromString('#d5a3b3').color,
                            maxLines: 3,
                          )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ],
            ),

            const Divider(),
            TextFrave(
              text: teacher.email,
              fontSize: 12,
              color: TinyColor.fromString('#cb8ca0').color,
            ),
            (callBackAddTEacher != null)
                ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            callBackAddTEacher!();
                          },
                          icon: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: TinyColor.fromString('#46ac8c').color,
                                borderRadius: BorderRadius.circular(12),
                              ),

                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.task_alt_rounded,
                                      size: 30,
                                      color:
                                          TinyColor.fromString('#137959').color,
                                    ),
                                    const SizedBox(width: 15),
                                    Text(
                                      'Summit',
                                      style: TextStyle(
                                        color:
                                            TinyColor.fromString(
                                              '#f5e8ec',
                                            ).color,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          color: TinyColor.fromString('#2fa17d').color,
                        ),
                        IconButton(
                          onPressed: () {
                            callBackCancelTEacher!();
                          },
                          icon: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: TinyColor.fromString('#a12f53').color,
                                borderRadius: BorderRadius.circular(12),
                              ),

                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.cancel_outlined,
                                      size: 30,
                                      color:
                                          TinyColor.fromString('#791333').color,
                                    ),
                                    const SizedBox(width: 15),
                                    Text(
                                      'Cancel',
                                      style: TextStyle(
                                        color:
                                            TinyColor.fromString(
                                              '#f5e8ec',
                                            ).color,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          color: TinyColor.fromString('#2fa17d').color,
                        ),
                      ],
                    ),
                  ),
                )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
