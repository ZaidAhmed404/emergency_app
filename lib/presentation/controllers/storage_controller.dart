import 'package:emergency_app/domain/repositories/storage_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/screen_provider.dart';
import '../widgets/toast.dart';

class StorageController {
  final StorageRepository storageRepository;

  StorageController(this.storageRepository);

  final screenNotifier =
      ProviderContainer().read(screenNotifierProvider.notifier);

  Future<String?> handleImageUploading(String filePath) async {
    screenNotifier.updateLoading(isLoading: true);
    String? url;
    try {
      url = await storageRepository.saveImage(filePath);
    } catch (error) {
      toastWidget(isError: false, message: "Image Uploading Failed");
    }
    screenNotifier.updateLoading(isLoading: false);
    return url;
  }
}
