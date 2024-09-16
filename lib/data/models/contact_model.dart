class ContactModel {
  final String userId;
  final String phoneNumber;
  final String photoUrl;
  final String userName;
  final bool isEmergencyContact;
  final String docId;

  ContactModel({
    required this.userId,
    required this.phoneNumber,
    required this.photoUrl,
    required this.isEmergencyContact,
    required this.userName,
    required this.docId,
  });

  factory ContactModel.fromMap(Map<String, dynamic> map, String newDocId) {
    return ContactModel(
      userId: map['userId'] ?? "",
      phoneNumber: map['phoneNumber'] ?? "",
      photoUrl: map['photoUrl'] ?? "",
      userName: map['userName'] ?? "",
      isEmergencyContact: map['isEmergencyContact'] ?? false,
      docId: newDocId,
    );
  }
}
