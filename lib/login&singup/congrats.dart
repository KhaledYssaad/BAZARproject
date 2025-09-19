import 'package:app/apiServices/notification_service.dart';
import 'package:app/auth/auth_service.dart';
import 'package:app/constants/colors.dart';
import 'package:flutter/material.dart';

class Congrats extends StatefulWidget {
  final String title;
  final String desc;
  const Congrats({super.key, required this.title, required this.desc});

  @override
  State<Congrats> createState() => _CongratsState();
}

class _CongratsState extends State<Congrats> {
  bool _isLoading = false;
  final authService = AuthService();

  Future<void> _login(String email, String password) async {
    setState(() => _isLoading = true);

    try {
      await authService.signInWithEmailPassword(email, password);

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, "/home");
    } catch (e) {
      if (mounted) {
        showNotification(
            id: 1, title: "Error", body: "Your Login Feild Please Try");
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _handleAction(String email, String password, bool account) {
    if (widget.title == "Congratulation!") {
      if (!_isLoading) {
        _login(email, password);
      }
    } else {
      account
          ? Navigator.pushNamedAndRemoveUntil(context, "/home", (_) => false)
          : Navigator.pushNamedAndRemoveUntil(context, "/login", (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map?;
    final email = args?["email"] ?? "";
    final password = args?["password"] ?? "";
    final account = args?["account"] ?? false;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("assets/images/Group.png"),
            const SizedBox(height: 41),
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 24,
                fontFamily: "Open Sans",
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                widget.desc,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 16,
                  color: AppColors.primaryGrey,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SizedBox(
                height: 56,
                width: 327,
                child: ElevatedButton(
                  onPressed: () {
                    _handleAction(email, password, account);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(48),
                    ),
                  ),
                  child: Text(
                    widget.title == "Congratulation!"
                        ? "Get Started"
                        : account
                            ? "Back to Home page"
                            : "Login",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
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
