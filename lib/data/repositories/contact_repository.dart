abstract class ContactRepository {
  Future requestContact({
    required String senderPhotoUrl,
    required String senderUserName,
    required String senderPhoneNumber,
    required String receiverId,
  });

  Future<bool> rejectContactRequest({required int index});

  Future<bool> acceptContact(
      {required String userId,
      required String userName,
      required String photoUrl,
      required String phoneNumber,
      required String uUserName,
      required String uPhotoUrl,
      required String uPhotoNumber});
}
