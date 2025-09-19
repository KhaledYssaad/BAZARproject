import 'package:app/constants/colors.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  void _forgotpassword() {
    Navigator.pushNamed(context, "/login/forgotpassword");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      alignment: Alignment.centerLeft,
      child: TextButton(
        style: ButtonStyle(
          padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
          minimumSize: WidgetStateProperty.all(Size.zero),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          overlayColor: WidgetStateProperty.all(Colors.transparent),
        ),
        onPressed: _forgotpassword,
        child: const Text(
          "Forgot Password?",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "Roboto",
            fontWeight: FontWeight.w600,
            fontSize: 14,
            height: 1.4,
            color: AppColors.primaryPurple,
          ),
        ),
      ),
    );
  }
}
