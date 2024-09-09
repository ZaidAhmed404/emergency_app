import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import '../../core/messages.dart';
import '../repositories/storage_repository.dart';

class StorageRepositoryImpl extends StorageRepository {
  final Messages _messages = Messages();

  @override
  Future<String?> saveImage(String filePath) async {
    // TODO: implement saveImage

    try {
      final file = File(filePath);
      String fileName = filePath.split('/').last;

      final storageRef = FirebaseStorage.instance.ref();
      final uploadTask =
          storageRef.child("user/profileImages/$fileName").putFile(
                file,
              );
      final snapshot = await uploadTask.whenComplete(() => null);

      String url = await snapshot.ref.getDownloadURL();

      return url;
    } catch (error) {
      log("$error", name: "error");
      throw (_messages.tryAgainMessage);
    }
  }

  @override
  Future<bool> deleteImage({required String imageUrl}) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference storageReference = storage.refFromURL(imageUrl);
      await storageReference.delete();
      return true;
    } catch (error) {
      log("$error", name: "error");
      throw (_messages.tryAgainMessage);
    }
  }
}
