import 'package:emergency_app/data/models/request_model.dart';

import '../models/contact_model.dart';

abstract class ContactRepository {
  Future requestContact({
    required String senderPhotoUrl,
    required String senderUserName,
    required String senderPhoneNumber,
    required String receiverId,
  });

  Future<bool> rejectContactRequest({required String docId});

  Stream<List<RequestModel>> getRequests(String docId);

  Stream<List<ContactModel>> getContacts(String docId);

  Future<bool> updateEmergencyContact(
      {required String docId, required bool isEmergency});

  Future<List<ContactModel>> getEmergencyContacts();

  Future<bool> acceptContact(
      {required String userId,
      required String userName,
      required String photoUrl,
      required String phoneNumber,
      required String uUserName,
      required String uPhotoUrl,
      required String uPhotoNumber});
}
