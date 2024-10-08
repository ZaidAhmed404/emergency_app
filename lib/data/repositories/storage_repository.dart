abstract class StorageRepository {
  Future<String?> saveImage(String filePath);

  Future<bool> deleteImage({required String imageUrl});
}
