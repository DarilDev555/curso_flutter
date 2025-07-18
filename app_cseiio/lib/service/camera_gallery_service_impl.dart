import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:tinycolor2/tinycolor2.dart';

import 'camera_gallery_service.dart';
import 'package:image_picker/image_picker.dart';

class CameraGalleryServiceImpl extends CameraGalleryService {
  final ImagePicker picker = ImagePicker();

  @override
  Future<String?> selectPhoto() async {
    final XFile? photo = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (photo == null) return null;

    return photo.path;
  }

  @override
  Future<String?> takePhoto() async {
    final XFile? photo = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 60,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (photo == null) return null;

    return photo.path;
  }

  @override
  Future<String?> cropSelectedImage(String filePath) async {
    final CroppedFile? photo = await ImageCropper().cropImage(
      sourcePath: filePath,
      maxHeight: 500,
      maxWidth: 500,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),

      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Recorte la imagen',
          toolbarColor: Colors.white,
          toolbarWidgetColor: TinyColor.fromString('#971840').color,
          statusBarColor: TinyColor.fromString('#971840').color,
        ),
        IOSUiSettings(title: 'Recorte la imagen'),
      ],
    );

    if (photo == null) return null;

    return photo.path;
  }
}
