import 'package:flutter/material.dart';
import 'package:tinycolor2/tinycolor2.dart';

import '../../../domain/entities/teacher.dart';
import '../shared/text_frave.dart';

class TeacherCard extends StatelessWidget {
  final Teacher teacher;
  final String accessToken;
  final double height;
  final double width;
  final bool isJustAvatar;
  final Color backGroundColor;
  final void Function()? callBackAddTEacher;
  final void Function()? callBackCancelTEacher;

  TeacherCard({
    super.key,
    required this.teacher,
    required this.accessToken,
    required this.height,
    required this.width,
    required this.isJustAvatar,
    this.callBackAddTEacher,
    this.callBackCancelTEacher,
    backGroundColor = '#88163a',
  }) : backGroundColor = TinyColor.fromString(backGroundColor).color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: Container(
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
          child:
              (isJustAvatar)
                  ? Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        teacher.avatar ?? '',
                        height: height,
                        width: width,
                        fit: BoxFit.cover,
                        headers: {"Authorization": "Bearer $accessToken"},
                      ),
                    ),
                  )
                  : Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              teacher.avatar ?? '',
                              height: height,
                              width: width,
                              fit: BoxFit.cover,
                              headers: {"Authorization": "Bearer $accessToken"},
                            ),
                          ),
                          (isJustAvatar)
                              ? const SizedBox.shrink()
                              : const SizedBox(width: 35),

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
                                ),
                                const SizedBox(height: 5),
                                TextFrave(
                                  text: teacher.email,
                                  fontSize: 15,
                                  color: TinyColor.fromString('#cb8ca0').color,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Divider(),
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
                                          color:
                                              TinyColor.fromString(
                                                '#46ac8c',
                                              ).color,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),

                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.task_alt_rounded,
                                                size: 40,
                                                color:
                                                    TinyColor.fromString(
                                                      '#137959',
                                                    ).color,
                                              ),
                                              const SizedBox(width: 15),
                                              Text(
                                                'Summit',
                                                style: TextStyle(
                                                  color:
                                                      TinyColor.fromString(
                                                        '#f5e8ec',
                                                      ).color,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              const SizedBox(width: 15),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),

                                    color:
                                        TinyColor.fromString('#2fa17d').color,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      callBackCancelTEacher!();
                                    },
                                    icon: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color:
                                              TinyColor.fromString(
                                                '#a12f53',
                                              ).color,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),

                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.cancel_outlined,
                                                size: 40,
                                                color:
                                                    TinyColor.fromString(
                                                      '#791333',
                                                    ).color,
                                              ),
                                              const SizedBox(width: 15),
                                              Text(
                                                'Cancel',
                                                style: TextStyle(
                                                  color:
                                                      TinyColor.fromString(
                                                        '#f5e8ec',
                                                      ).color,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              const SizedBox(width: 15),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),

                                    color:
                                        TinyColor.fromString('#2fa17d').color,
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.all(8.0),
                                  //   child: GestureDetector(
                                  //     onTap: () {
                                  //       callBackCancelTEacher!();
                                  //     },
                                  //     child: Icon(
                                  //       Icons.cancel_outlined,
                                  //       size: 40,
                                  //       color:
                                  //           TinyColor.fromString(
                                  //             '#a12f53',
                                  //           ).color,
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          )
                          : const SizedBox.shrink(),
                    ],
                  ),
        ),
      ),
    );
  }
}
