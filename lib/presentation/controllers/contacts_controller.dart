import 'package:emergency_app/data/repositories/contact_repository.dart';

import '../../core/messages.dart';
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

  Future handleRejectContactRequest({required int index}) async {
    try {
      final isSuccess =
          await contactRepository.rejectContactRequest(index: index);
      if (isSuccess) {
        toastWidget(isError: false, message: _messages.requestRejectedMessage);
      }
    } catch (error) {
      toastWidget(isError: true, message: error.toString());
    }
  }

  Future handleAcceptRequestContactRequest(
      {required int index,
      required String userId,
      required String userName,
      required String photoUrl,
      required String phoneNumber,
      required String uUserName,
      required String uPhotoUrl,
      required String uPhotoNumber}) async {
    try {
      await contactRepository.rejectContactRequest(index: index);
      final isSuccess = await contactRepository.acceptContact(
          userId: userId,
          userName: userName,
          photoUrl: photoUrl,
          phoneNumber: phoneNumber,
          uPhotoNumber: uPhotoNumber,
          uPhotoUrl: uPhotoUrl,
          uUserName: uUserName);
      if (isSuccess) {
        toastWidget(isError: false, message: _messages.acceptedRequestMessage);
      }
    } catch (error) {
      toastWidget(isError: true, message: error.toString());
    }
  }
}
