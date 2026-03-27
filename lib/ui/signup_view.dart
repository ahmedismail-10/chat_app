import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/ui/widgets/custom_button.dart';
import 'package:chat_app/ui/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

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
                        "Sign Up",
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
                          if (value == null || value.isEmpty) {
                            return "Enter your email";
                          } else if (!value.contains('@')) {
                            return "Enter a valid email";
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

                      const SizedBox(height: 20),

                      /// Confirm Password
                      CustomTextFormField(
                        controller: confirmPasswordController,
                        labelText: "Confirm Password",
                        isPassword: true,
                        validator: (value) {
                          if (value!.length < 6) {
                            return "Password must be at least 6 chars";
                          } else if (value != passwordController.text) {
                            return "Passwords do not match";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 30),

                      /// Sign Up Button
                      CustomButton(
                        label: "Sign Up",
                        onPressed: () {
                          bool isValid =
                              _formKey.currentState?.validate() ?? false;
                          if (!isValid) {
                            return;
                          }
                          _formKey.currentState?.save();
                          AuthService.signUp(
                            context,
                            email: emailController.text,
                            password: passwordController.text,
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      /// Navigate to Login
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Have an account? "),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Sign in here",
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
