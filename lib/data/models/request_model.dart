class RequestModel {
  final String docId;
  final String senderId;
  final String senderPhoneNumber;
  final String senderPhotoUrl;
  final String senderUserName;

  RequestModel({
    required this.docId,
    required this.senderId,
    required this.senderPhoneNumber,
    required this.senderPhotoUrl,
    required this.senderUserName,
  });

  factory RequestModel.fromMap(Map<String, dynamic> map, String newDocId) {
    return RequestModel(
      docId: newDocId,
      senderId: map['senderId'] ?? "",
      senderPhoneNumber: map['senderPhoneNumber'] ?? "",
      senderPhotoUrl: map['senderPhotoUrl'] ?? "",
      senderUserName: map['senderUserName'] ?? "",
    );
  }
}
