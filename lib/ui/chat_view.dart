import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key, required this.receiver});
  final UserModel receiver;

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  TextEditingController messageController = .new();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiver.email.split('@')[0]),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: ChatService.getMessages(
                senderId: FirebaseAuth.instance.currentUser!.uid,
                receiverId: widget.receiver.uid,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(
                    child: Text("No messages found"),
                  );
                } else {
                  final messages = snapshot.data!;
                  messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return Align(
                        alignment:
                            messages[index].senderId ==
                                FirebaseAuth.instance.currentUser!.uid
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                messages[index].senderId ==
                                    FirebaseAuth.instance.currentUser!.uid
                                ? kPrimaryColor
                                : kSecondaryColor,
                            borderRadius: .only(
                              topLeft: const .circular(16),
                              topRight: const .circular(16),
                              bottomLeft:
                                  messages[index].senderId ==
                                      FirebaseAuth.instance.currentUser!.uid
                                  ? const .circular(16)
                                  : const .circular(0),
                              bottomRight:
                                  messages[index].senderId ==
                                      FirebaseAuth.instance.currentUser!.uid
                                  ? const .circular(0)
                                  : const .circular(16),
                            ),
                          ),
                          padding: const .symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          margin: const .symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Text(
                            messages[index].message,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),

          Container(
            padding: const .symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: messageController,
                    decoration: InputDecoration(
                      labelText: "Type a message",
                      border: OutlineInputBorder(
                        borderRadius: .circular(16),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter your message";
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => _onFieldSubmitted(),
                  ),
                ),
                IconButton(
                  onPressed: _onFieldSubmitted,
                  icon: const Icon(
                    Icons.send,
                    size: 32,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onFieldSubmitted() {
    final text = messageController.text.trim();
    if (text.isEmpty) {
      return;
    }
    ChatService.sendMessage(
      MessageModel(
        senderId: FirebaseAuth.instance.currentUser!.uid,
        receiverId: widget.receiver.uid,
        message: text,
        createdAt: DateTime.now(),
      ),
    );
    messageController.clear();
  }
}
