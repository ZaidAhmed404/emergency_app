import 'package:emergency_app/domain/repositories/storage_repository.dart';

import '../widgets/toast.dart';

class StorageController {
  final StorageRepository storageRepository;

  StorageController(this.storageRepository);

  Future<String?> handleImageUploading(String filePath) async {
    String? url;
    try {
      url = await storageRepository.saveImage(filePath);
    } catch (error) {
      toastWidget(isError: false, message: "Image Uploading Failed");
    }
    return url;
  }
}
