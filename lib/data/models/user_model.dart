class UserModel {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String photoUrl;
  final String userName;
  final String uid;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.photoUrl,
    required this.userName,
    required this.uid,
  });

  // From JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      photoUrl: json['photoUrl'] ?? '',
      userName: json['userName'] ?? '',
      uid: json['uid'] ?? '',
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'userName': userName,
      'uid': uid,
    };
  }
}
