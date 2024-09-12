class RequestModel {
  final String senderId;
  final String senderPhoneNumber;
  final String senderPhotoUrl;
  final String senderUserName;
  final int index;

  RequestModel({
    required this.senderId,
    required this.senderPhoneNumber,
    required this.senderPhotoUrl,
    required this.senderUserName,
    required this.index,
  });

  factory RequestModel.fromMap(Map<String, dynamic> map, int newIndex) {
    return RequestModel(
      senderId: map['senderId'] as String,
      senderPhoneNumber: map['senderPhoneNumber'] as String,
      senderPhotoUrl: map['senderPhotoUrl'] as String,
      senderUserName: map['senderUserName'] as String,
      index: newIndex,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderPhoneNumber': senderPhoneNumber,
      'senderPhotoUrl': senderPhotoUrl,
      'senderUserName': senderUserName,
      'indexNumber': index,
    };
  }
}
