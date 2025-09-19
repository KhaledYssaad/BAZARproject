import 'package:app/apiServices/notification_service.dart';
import 'package:app/auth/auth_service.dart';
import 'package:app/constants/colors.dart';
import 'package:app/widgets/input_field.dart';
import 'package:app/widgets/password.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordValid = false;

  bool get _isFormValid {
    return _nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _isPasswordValid;
  }

  Future<void> _signup() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final name = _nameController.text.trim();
    final authService = AuthService();

    try {
      await authService.signUpWithEmailPassword(email, password, name);

      if (!mounted) return;

      Navigator.pushReplacementNamed(
        context,
        "/login/signup/verification",
        arguments: {"email": email, "password": password},
      );
    } catch (e) {
      if (mounted) {
        showNotification(
          id: 17,
          title: "Signup Failed",
          body: "signup feild please try again ",
        );
      }
    }
  }

  void _login() {
    Navigator.pushNamed(context, "/login");
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 24, top: 24),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF121212),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Create account and choose favorite menu",
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
                  title: "Name",
                  hintText: "Your Name",
                  controller: _nameController,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 16),
                InputField(
                  title: "Email",
                  hintText: "Your email",
                  controller: _emailController,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 16),
                PasswordField(
                  signup: true,
                  controller: _passwordController,
                  onChanged: (_) => setState(() {}),
                  onValidChanged: (isValid) {
                    setState(() {
                      _isPasswordValid = isValid;
                    });
                  },
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  child: FilledButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        _isFormValid
                            ? AppColors.primaryPurple
                            : Colors.grey, // ✅ disabled color
                      ),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(48),
                        ),
                      ),
                      minimumSize: WidgetStateProperty.all(
                        const Size(double.infinity, 48),
                      ),
                    ),
                    onPressed: _isFormValid ? _signup : null, // ✅ disable
                    child: const Text(
                      "Register",
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
                        "Have an account? ",
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
                          padding: WidgetStateProperty.all<EdgeInsets>(
                              EdgeInsets.zero),
                          minimumSize: WidgetStateProperty.all(Size.zero),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          overlayColor:
                              WidgetStateProperty.all(Colors.transparent),
                        ),
                        onPressed: _login,
                        child: const Text(
                          "Sign In",
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
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "By clicking Register, you agree to our ",
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
                    "Terms and Data Policy.",
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
        ],
      ),
    );
  }
}
