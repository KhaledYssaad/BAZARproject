import 'package:app/apiServices/notification_service.dart';
import 'package:app/auth/auth_service.dart';
import 'package:app/constants/colors.dart';
import 'package:app/widgets/forgot_password.dart';
import 'package:app/widgets/input_field.dart';
import 'package:app/widgets/password.dart';
import 'package:app/widgets/service_not_available_yet.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  void _login() async {
    final email = _emailController.text.trim();
    final password = _passController.text.trim();

    try {
      final authservice = AuthService();
      await authservice.signInWithEmailPassword(email, password);
      Navigator.pushReplacementNamed(context, "/home");
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Wrong Email or Password, try again"),
          duration: const Duration(seconds: 2),
          backgroundColor: AppColors.CustomRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  void _signup() {
    Navigator.pushNamed(context, "/login/signup");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 24, top: 24),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome Back 👋",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF121212),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Sign to your account",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFA6A6A6),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            InputField(
              title: "Email",
              hintText: "Your email",
              controller: _emailController,
            ),
            const SizedBox(height: 16),
            PasswordField(
              signup: false,
              controller: _passController,
            ),
            const SizedBox(height: 16),
            const ForgotPassword(),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: FilledButton(
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all(AppColors.primaryPurple),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(48),
                    ),
                  ),
                  minimumSize:
                      WidgetStateProperty.all(const Size(double.infinity, 48)),
                ),
                onPressed: _login,
                child: const Text(
                  "Login",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    height: 1.4,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don’t have an account?",
                    style: TextStyle(
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      height: 1.5,
                      color: Color(0xFFA6A6A6),
                    ),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      padding:
                          WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
                      minimumSize: WidgetStateProperty.all(Size.zero),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                    ),
                    onPressed: _signup,
                    child: const Text(
                      " Sign Up",
                      style: TextStyle(
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        height: 1.5,
                        color: AppColors.primaryPurple,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Row(
              children: [
                Expanded(child: Divider(thickness: 1, color: Colors.grey)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    "OR",
                    style: TextStyle(
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Expanded(child: Divider(thickness: 1, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  OutlinedButton(
                    onPressed: () async {
                      ServiceNotAvailableYet.show(context, "");
                      // try {
                      //   await AuthService().signInWithGoogle();
                      //   final user = AuthService().getCurrentUser();
                      //   if (user != null) {
                      //     Navigator.pushNamed(context, "/home");
                      //   }
                      // } catch (e) {
                      // }
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      side: const BorderSide(color: Colors.grey, width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/Google.png",
                            width: 16, height: 16),
                        const SizedBox(width: 10),
                        const Text(
                          "Sign in with Google",
                          style: TextStyle(
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () async {
                      ServiceNotAvailableYet.show(context, "");
                      // try {
                      //   await AuthService().signInWithApple();
                      //   final user = AuthService().getCurrentUser();
                      //   if (user != null) {
                      //     Navigator.pushNamed(context, "/home");
                      //   }
                      // } catch (e) {
                      // }
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      side: const BorderSide(color: Colors.grey, width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/Apple.png",
                            width: 16, height: 16),
                        const SizedBox(width: 10),
                        const Text(
                          "Sign in with Apple",
                          style: TextStyle(
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
