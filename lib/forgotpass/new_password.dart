import 'package:app/apiServices/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:app/constants/colors.dart';
import 'package:app/widgets/account_change_password.dart';
import 'package:app/auth/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NewPassword extends StatefulWidget {
  const NewPassword({super.key});

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  final _authService = AuthService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _tokenController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _validPassword;
  bool _loading = false;

  Future<void> _resetPassword(bool account) async {
    if (!_formKey.currentState!.validate()) return;

    if (_validPassword == null || _validPassword!.isEmpty) {
      showNotification(
        id: 1,
        title: "Password Required",
        body: "Please enter a new password to reset your account.",
      );
      return;
    }

    setState(() => _loading = true);

    final email = _emailController.text.trim();
    final token = _tokenController.text.trim();

    try {
      await _authService.verifyOtp(
        email: email,
        token: token,
        type: OtpType.recovery,
      );

      await _authService.updatePassword(_validPassword!);

      if (!mounted) return;
      showNotification(
        id: 2,
        title: "Password Reset Successful",
        body: "Your password has been updated.",
      );

      Navigator.pushNamedAndRemoveUntil(
        context,
        "/login/forgotpassword/congrats",
        (route) => false,
        arguments: {
          "email": email,
          "password": _validPassword!,
          "account": account,
        },
      );
    } catch (e) {
      if (mounted) {
        showNotification(
          id: 3,
          title: "Password Reset Failed",
          body: "Something went wrong. Please try again.",
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    bool obscure = false,
    VoidCallback? toggleObscure,
    FocusNode? focusNode,
    bool readOnly = false,
  }) {
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hint,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF121212),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              readOnly: readOnly,
              focusNode: focusNode,
              controller: controller,
              obscureText: obscure,
              decoration: InputDecoration(
                hintText: "Your $hint",
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                suffixIcon: toggleObscure != null
                    ? IconButton(
                        icon: Icon(
                          obscure ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: toggleObscure,
                      )
                    : null,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map?;
    final account = args?["account"] ?? false;
    final email = args?["email"] ?? "";

    if (account && email.isNotEmpty && _emailController.text.isEmpty) {
      _emailController.text = email;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Create New Password"),
        backgroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildInput(
              controller: _emailController,
              hint: "Email",
              readOnly: account,
            ),
            const SizedBox(height: 16),
            _buildInput(
              controller: _tokenController,
              hint: "Token",
            ),
            const SizedBox(height: 16),
            AccountChangePassword(
              callback: (password) {
                setState(() {
                  _validPassword = password;
                });
              },
            ),
            const SizedBox(height: 28),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (!_loading) {
                    _resetPassword(account);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(48),
                  ),
                ),
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Confirm",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
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
