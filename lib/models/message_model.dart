class MessageModel {
  String? messageId;
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime createdAt;

  MessageModel({
    this.messageId,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.createdAt,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      messageId: map['messageId'],
      senderId: map['senderId'],
      receiverId: map['receiverId'],
      message: map['message'],
      createdAt: map['createdAt'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'createdAt': DateTime.now(),
    };
  }
}
