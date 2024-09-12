class ContactModel {
  final String userId;
  final String phoneNumber;
  final String photoUrl;
  final String userName;
  final bool isEmergencyContact;
  final int index;

  ContactModel({
    required this.userId,
    required this.phoneNumber,
    required this.photoUrl,
    required this.isEmergencyContact,
    required this.userName,
    required this.index,
  });

  factory ContactModel.fromMap(Map<String, dynamic> map, int newIndex) {
    return ContactModel(
      userId: map['userId'] as String,
      phoneNumber: map['phoneNumber'] as String,
      photoUrl: map['photoUrl'] as String,
      userName: map['userName'] as String,
      isEmergencyContact: map['isEmergencyContact'] as bool,
      index: newIndex,
    );
  }
}
