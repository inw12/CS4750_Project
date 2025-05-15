import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:this_is_a_to_do_app/pages/authentication/sign_up_widget.dart';
import '../../assets/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../home.dart';

class SignInWidget extends StatefulWidget {
  const SignInWidget({super.key});

  @override
  State<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final email = TextEditingController();
    final password = TextEditingController();

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
              _buildHeader(), // Header Text
              SizedBox(height: 30),

              _buildEmailField(email), // Username
              SizedBox(height: 10),

              _buildPasswordField(password), // Password
              SizedBox(height: 60),

              _buildSubmitButton(formKey, email, password), // Submit Button
              SizedBox(height: 20),

              _buildRegisterPrompt(context), // Register Prompt
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      'Login',
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
        if (value == null || value.isEmpty) {
          return "Please enter your email address.";
        }
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
        hintText: 'Password',
        hintStyle: TextStyle(color: Colors.white60),
      ),
    );
  }

  Widget _buildSubmitButton(GlobalKey<FormState> formKey, TextEditingController email,TextEditingController password,) {
    return SizedBox(
      width: 375,
      height: 55,
      child: ElevatedButton(
        onPressed: () async {
          final isValid = formKey.currentState!.validate();
          if (isValid) {
            try {
              await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text, password: password.text);
              if(!mounted) return;
              Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
            } catch (e) {
              if (kDebugMode) {
                print("Login Error");
                print(e.toString());
              }
            }
          }
        },
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
        child: Text(
          'Submit',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildRegisterPrompt(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: "Don't have an account? Register ",
            style: TextStyle(color: Colors.white54),
          ),
          TextSpan(
            text: "here",
            style: const TextStyle(
              color: AppColors.primary,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.primary,
            ),
            recognizer: TapGestureRecognizer()..onTap = _togglePages,
          ),
        ],
      ),
    );
  }

  Future<void> _togglePages() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => SignUpWidget()),
    );
    if (!mounted) return;
    if (result == 'success') _buildSnackBar();
  }

  void _buildSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Registration successful!',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.accept,
        duration: Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 16,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(20),
      ),
    );
  }
}
