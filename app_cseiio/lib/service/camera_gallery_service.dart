abstract class CameraGalleryService {
  Future<String?> takePhoto();
  Future<String?> selectPhoto();
  Future<String?> cropSelectedImage(String filePath);
}
