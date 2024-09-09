import '../../data/repositories/storage_repository.dart';
import '../widgets/toast.dart';

class StorageController {
  final StorageRepository storageRepository;

  StorageController(this.storageRepository);

  Future<String?> handleImageUploading(String filePath) async {
    String? url;
    try {
      url = await storageRepository.saveImage(filePath);
    } catch (error) {
      toastWidget(isError: true, message: "$error");
    }
    return url;
  }

  Future<bool> handleDeletingImage({required String imageUrl}) async {
    try {
      final isSuccess = await storageRepository.deleteImage(imageUrl: imageUrl);
      if (isSuccess) {
        toastWidget(isError: false, message: "");
      }
      return isSuccess;
    } catch (error) {
      toastWidget(isError: true, message: "$error");
      return false;
    }
  }
}
