import 'package:app/constants/colors.dart';
import 'package:flutter/material.dart';

class UserInfoInput extends StatefulWidget {
  final TextEditingController controller;
  final String label;

  const UserInfoInput({
    super.key,
    required this.controller,
    required this.label,
  });

  @override
  State<UserInfoInput> createState() => _UserInfoInputState();
}

class _UserInfoInputState extends State<UserInfoInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: const TextStyle(
              fontFamily: "Roboto",
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color.fromARGB(235, 12, 12, 68),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: widget.controller, 
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
              fontSize: 16,
              height: 1.5,
              letterSpacing: 0,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.VeryLightGrey,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
