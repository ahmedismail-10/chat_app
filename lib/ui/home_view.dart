import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/home_service.dart';
import 'package:chat_app/ui/chat_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key, required this.user});
  final User user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chats - ${user.email!.split('@')[0]}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              AuthService.signOut();
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: HomeService.getUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text("No users found"),
            );
          } else {
            final users = snapshot.data!;
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChatView(receiver: user),
                        ),
                      );
                    },
                    leading: CircleAvatar(
                      child: Text(user.email.split('@')[0][0].toUpperCase()),
                    ),
                    title: Text(user.email),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
