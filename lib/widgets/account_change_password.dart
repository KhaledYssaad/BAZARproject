import 'package:app/constants/colors.dart';
import 'package:flutter/material.dart';

class AccountChangePassword extends StatefulWidget {
  const AccountChangePassword({super.key, required this.callback});
  final void Function(String? password) callback;

  @override
  State<AccountChangePassword> createState() => _AccountChangePasswordState();
}

class _AccountChangePasswordState extends State<AccountChangePassword> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final FocusNode _newPasswordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  bool _obscureNew = true;
  bool _obscureConfirm = true;
  String? _errorMessageNew;
  String? _errorMessageConfirm;

  bool _validatePassword(String password) {
    final hasMinLength = password.length >= 8;
    final hasNumber = password.contains(RegExp(r'[0-9]'));
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));

    if (!hasMinLength) {
      _errorMessageNew = "Password must be at least 8 characters";
      return false;
    }
    if (!hasUppercase) {
      _errorMessageNew = "Password must contain at least one uppercase letter";
      return false;
    }
    if (!hasNumber) {
      _errorMessageNew = "Password must contain at least one digit";
      return false;
    }

    _errorMessageNew = null;
    return true;
  }

  void _checkPasswords() {
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    final isValid = _validatePassword(newPassword);

    if (isValid && newPassword != confirmPassword) {
      _errorMessageConfirm = "Passwords do not match";
    } else {
      _errorMessageConfirm = null;
    }

    widget
        .callback(isValid && _errorMessageConfirm == null ? newPassword : null);
    setState(() {});
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback toggleObscure,
    required FocusNode focusNode,
    String? errorMessage,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF121212),
              )),
          const SizedBox(height: 8),
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              focusNode: focusNode,
              controller: controller,
              obscureText: obscure,
              onChanged: (_) => _checkPasswords(),
              onSubmitted: (_) => _checkPasswords(),
              decoration: InputDecoration(
                hintText: "••••••••",
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscure ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: toggleObscure,
                ),
              ),
            ),
          ),
          if (errorMessage != null) // 👈 always show error if exists
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                errorMessage,
                style: const TextStyle(
                  color: AppColors.CustomRed,
                  fontSize: 12,
                ),
              ),
            )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _newPasswordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildPasswordField(
          label: "New Password",
          controller: _newPasswordController,
          obscure: _obscureNew,
          toggleObscure: () => setState(() => _obscureNew = !_obscureNew),
          focusNode: _newPasswordFocus,
          errorMessage: _errorMessageNew,
        ),
        const SizedBox(height: 16),
        _buildPasswordField(
          label: "Confirm Password",
          controller: _confirmPasswordController,
          obscure: _obscureConfirm,
          toggleObscure: () =>
              setState(() => _obscureConfirm = !_obscureConfirm),
          focusNode: _confirmPasswordFocus,
          errorMessage: _errorMessageConfirm,
        ),
      ],
    );
  }
}
