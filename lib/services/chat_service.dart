import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  static Future<void> sendMessage(MessageModel message) async {
    final messageRef = FirebaseFirestore.instance
        .collection(kMessagesCollections)
        .doc();
    message.messageId = messageRef.id;
    await messageRef.set(message.toMap());
  }

  static Stream<List<MessageModel>> getMessages({
    required String senderId,
    required String receiverId,
  }) {
    final messagesSnapshot = FirebaseFirestore.instance
        .collection(kMessagesCollections)
        .where("senderId", whereIn: [senderId, receiverId])
        .where("receiverId", whereIn: [senderId, receiverId])
        .snapshots();

    return messagesSnapshot.map((snapshot) {
      return snapshot.docs
          .map((doc) => MessageModel.fromMap(doc.data()))
          .toList();
    });
  }
}
