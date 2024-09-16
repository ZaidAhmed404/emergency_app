import 'package:emergency_app/data/repositories/contact_repository.dart';

import '../../core/messages.dart';
import '../../data/models/contact_model.dart';
import '../../data/models/request_model.dart';
import '../widgets/toast.dart';

class ContactsController {
  final ContactRepository contactRepository;

  ContactsController(this.contactRepository);

  final Messages _messages = Messages();

  Future handleSendingRequestContacts({
    required String senderPhotoUrl,
    required String senderUserName,
    required String senderPhoneNumber,
    required String receiverId,
  }) async {
    try {
      final isSuccess = await contactRepository.requestContact(
          senderPhotoUrl: senderPhotoUrl,
          senderUserName: senderUserName,
          senderPhoneNumber: senderPhoneNumber,
          receiverId: receiverId);
      if (isSuccess) {
        toastWidget(
            isError: false, message: _messages.successRequestSentMessage);
      }
    } catch (error) {
      toastWidget(isError: true, message: error.toString());
    }
  }

  Stream<List<RequestModel>> handleGetRequests(String docId) {
    return contactRepository.getRequests(docId);
  }

  Stream<List<ContactModel>> handleGetContacts(String docId) {
    return contactRepository.getContacts(docId);
  }

  Future handleRejectContactRequest({required String docId}) async {
    try {
      final isSuccess =
          await contactRepository.rejectContactRequest(docId: docId);
      if (isSuccess) {
        toastWidget(isError: false, message: _messages.requestRejectedMessage);
      }
    } catch (error) {
      toastWidget(isError: true, message: error.toString());
    }
  }

  Future handleAcceptRequestContactRequest(
      {required String docId,
      required String userId,
      required String userName,
      required String photoUrl,
      required String phoneNumber,
      required String uUserName,
      required String uPhotoUrl,
      required String uPhotoNumber}) async {
    try {
      bool isSuccess =
          await contactRepository.rejectContactRequest(docId: docId);
      if (isSuccess) {
        isSuccess = await contactRepository.acceptContact(
            userId: userId,
            userName: userName,
            photoUrl: photoUrl,
            phoneNumber: phoneNumber,
            uPhotoNumber: uPhotoNumber,
            uPhotoUrl: uPhotoUrl,
            uUserName: uUserName);
        if (isSuccess) {
          toastWidget(
              isError: false, message: _messages.acceptedRequestMessage);
        }
      }
    } catch (error) {
      toastWidget(isError: true, message: error.toString());
    }
  }

  Future handleChangingEmergencyContact(
      {required String docId, required bool isEmergency}) async {
    try {
      final isSuccess = await contactRepository.updateEmergencyContact(
          docId: docId, isEmergency: isEmergency);
      if (isSuccess) {
        toastWidget(
            isError: false,
            message: _messages.emergencyContactAddedSuccessMessage);
      }
    } catch (error) {
      toastWidget(isError: true, message: error.toString());
    }
  }
}
