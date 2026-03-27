import 'package:chat_app/constants.dart';
import 'package:chat_app/ui/signup_view.dart';
import 'package:chat_app/ui/widgets/custom_button.dart';
import 'package:chat_app/ui/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Sign In",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 40),

                      /// Email
                      CustomTextFormField(
                        controller: emailController,
                        labelText: "Email Address",
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter your email";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      /// Password
                      CustomTextFormField(
                        controller: passwordController,
                        labelText: "Password",
                        isPassword: true,
                        validator: (value) {
                          if (value!.length < 6) {
                            return "Password must be at least 6 chars";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 30),

                      /// Sign In Button
                      CustomButton(
                        label: "Sign In",
                        onPressed: () {
                          bool isValid =
                              _formKey.currentState?.validate() ?? false;
                          if (!isValid) {
                            return;
                          }
                          _formKey.currentState?.save();
                        },
                      ),

                      const SizedBox(height: 20),

                      /// Navigate to Signup
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account? "),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignupView(),
                                ),
                              );
                            },
                            child: const Text(
                              "Sign up here",
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
