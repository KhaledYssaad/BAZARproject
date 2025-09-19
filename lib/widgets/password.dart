import 'package:app/constants/colors.dart';
import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final bool signup;
  final TextEditingController? controller;
  final ValueChanged<bool>? onValidChanged;
  final ValueChanged<String>? onChanged; // ✅ instead of unused dynamic

  const PasswordField({
    super.key,
    required this.signup,
    this.controller,
    this.onValidChanged,
    this.onChanged,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscurePassword = true;
  bool _hasMinLength = false;
  bool _hasUpperLower = false;
  bool _hasNumber = false;

  void _onChanged(String value) {
    // propagate change to parent
    widget.onChanged?.call(value);

    if (!widget.signup) return;
    final hasMinLength = value.length >= 8;
    final hasUpperLower = RegExp(r'(?=.*[a-z])(?=.*[A-Z])').hasMatch(value);
    final hasNumber = RegExp(r'\d').hasMatch(value);
    final isValid = hasMinLength && hasUpperLower && hasNumber;

    setState(() {
      _hasMinLength = hasMinLength;
      _hasUpperLower = hasUpperLower;
      _hasNumber = hasNumber;
    });

    widget.onValidChanged?.call(isValid);
  }

  Widget _buildConditionRow(bool condition, String text) {
    if (!widget.signup) return const SizedBox.shrink();
    return Row(
      children: [
        Icon(
          condition ? Icons.check : Icons.cancel_outlined,
          color: condition ? AppColors.primaryPurple : Colors.red,
          size: 18,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller ?? TextEditingController();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Password",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF121212),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: controller,
              obscureText: _obscurePassword,
              onChanged: _onChanged,
              decoration: InputDecoration(
                hintText: "Your password",
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          _buildConditionRow(_hasMinLength, "At least 8 characters"),
          _buildConditionRow(_hasUpperLower, "Contains upper and lower case"),
          _buildConditionRow(_hasNumber, "Contains a number"),
        ],
      ),
    );
  }
}
