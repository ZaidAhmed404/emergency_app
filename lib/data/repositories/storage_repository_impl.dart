import 'dart:developer';
import 'dart:io';

import 'package:emergency_app/domain/repositories/storage_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../presentation/widgets/toast.dart';

class StorageRepositoryImpl extends StorageRepository {
  @override
  Future<String?> saveImage(String filePath) async {
    // TODO: implement saveImage

    try {
      final file = File(filePath);
      String fileName = filePath.split('/').last;
      // final metadata = SettableMetadata(contentType: "image/jpeg");

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
      toastWidget(isError: true, message: "Something went wrong");
      return null;
    }
  }

  @override
  Future<bool> deleteImage() async {
    try {
      // Create a reference from the image URL
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference storageReference =
          storage.refFromURL(FirebaseAuth.instance.currentUser!.photoURL!);

      // Delete the file
      await storageReference.delete();

      toastWidget(isError: false, message: "Image successfully deleted");

      return true;
    } catch (e) {
      toastWidget(
          isError: true, message: "Error occurred while deleting image");
      return false;
    }
  }
}
