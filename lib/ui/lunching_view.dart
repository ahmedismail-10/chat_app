import 'package:chat_app/ui/home_view.dart';
import 'package:chat_app/ui/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LunchingView extends StatelessWidget {
  const LunchingView({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          return HomeView(user: snapshot.data!);
        } else {
          return const LoginView();
        }
      },
    );
  }
}
