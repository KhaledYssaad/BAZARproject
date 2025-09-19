import 'package:app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/providers/radio_provider.dart';

class MethodRadio extends StatelessWidget {
  const MethodRadio({super.key});

  @override
  Widget build(BuildContext context) {
    final methodeProvider = Provider.of<RadioProvider>(context);
    final selected = methodeProvider.selectedMethod;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildOption(
            context: context,
            value: "email",
            icon: Icons.email,
            title: "Email",
            subtitle: "Send to your email",
            isSelected: selected == "email"),
        const SizedBox(width: 16),
        _buildOption(
            context: context,
            value: "phone",
            icon: Icons.phone,
            title: "Phone",
            subtitle: "Send to your phone",
            isSelected: selected == "phone"),
      ],
    );
  }

  Widget _buildOption({
    required BuildContext context,
    required bool isSelected,
    required String value,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return GestureDetector(
      onTap: () {
        context.read<RadioProvider>().setMethod(value);
      },
      child: Container(
        width: 158,
        height: 150,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(
                  color: AppColors.primaryPurple,
                )
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 24,
              color:
                  isSelected ? AppColors.primaryPurple : AppColors.primaryGrey,
            ),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? AppColors.primaryPurple : Colors.black87,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.primaryGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
