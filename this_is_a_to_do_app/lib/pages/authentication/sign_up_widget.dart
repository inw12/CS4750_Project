import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../assets/colors.dart';


class SignUpWidget extends StatefulWidget {
  const SignUpWidget({super.key});

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  @override
  Widget build(BuildContext context) {

    final formKey = GlobalKey<FormState>();
    final email = TextEditingController();
    final password = TextEditingController();
    final passwordConfirm = TextEditingController();

    return Form(
      key: formKey,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          minimum: EdgeInsets.only(top: 100, right: 16, left: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildHeader(),
              SizedBox(height: 30),

              _buildEmailField(email),
              SizedBox(height: 40),

              _buildPasswordField(password),
              SizedBox(height: 10),

              _buildPasswordConfirmField(passwordConfirm, password),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  " • Password must contain at least 6 characters.",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              SizedBox(height: 60),

              _buildRegisterButton(formKey, email, password),
              SizedBox(height: 20),

              _buildLoginPrompt(context), // Sign-in Prompt
            ],
          ),
        ),
      ),
    );
  }

  // Header Text
  Widget _buildHeader() {
    return Text(
      'Register',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
    );
  }

  // Username Field
  Widget _buildEmailField(TextEditingController textController) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) return "Please enter your email address.";
        final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
      controller: textController,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Enter Email',
        hintStyle: TextStyle(color: Colors.white60),
      ),
    );
  }

  // Password Field
  Widget _buildPasswordField(TextEditingController textController) {
    return TextFormField(
      obscureText: true,
      controller: textController,
      validator: (value) {
        if (value == null || value.isEmpty) return "Please enter a password.";
        if (value.length < 6) return "Password must be at least 6 characters";
        return null;
      },
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'New Password',
        hintStyle: TextStyle(color: Colors.white60),
      ),
    );
  }

  // Confirm Password Field
  Widget _buildPasswordConfirmField(TextEditingController confirmController, TextEditingController passwordController,) {
    return TextFormField(
      obscureText: true,
      controller: confirmController,
      validator: (value) {
        if (value == null || value.isEmpty) return "Please confirm your password.";
        if (value != passwordController.text) return 'Passwords do not match!';
        return null;
      },
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Confirm Password',
        hintStyle: TextStyle(color: Colors.white60),
      ),
    );
  }

  // Register Button
  Widget _buildRegisterButton(GlobalKey<FormState> formKey, TextEditingController email, TextEditingController password) {
    return SizedBox(
      width: 375,
      height: 55,
      child: ElevatedButton(
        onPressed: () async {
          final isValid = formKey.currentState!.validate();
          if (isValid) {
            try {
              FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email.text,
                  password: password.text
              );
              if (!mounted) return;
              Navigator.pop(context, 'success');
            } catch (e) {
              if (kDebugMode) {
                print("Signup Error");
                print(e.toString());
              }
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
        ),
        child: Text('Register', style: TextStyle(color: Colors.black, fontSize: 16)),
      ),
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: "Already have an account? Login ",
            style: TextStyle(color: Colors.white54),
          ),
          TextSpan(
            text: "here",
            style: const TextStyle(
              color: AppColors.primary,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.primary,
            ),
            recognizer:
                TapGestureRecognizer()
                  ..onTap =
                      () => Navigator.pop(context)
          ),
        ],
      ),
    );
  }
}
