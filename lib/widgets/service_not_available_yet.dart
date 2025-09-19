import 'package:app/constants/colors.dart';
import 'package:flutter/material.dart';

class ServiceNotAvailableYet {
  static Future<void> show(BuildContext context, String input) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
        elevation: 10,
        title: Row(
          children: const [
            Icon(Icons.error_outline, color: AppColors.primaryPurple, size: 28),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                "Service Unavailable",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "This service is not available yet due to time constraints. "
              "We will add it as soon as possible.",
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
            const SizedBox(height: 15),
            if (input.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple10,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  input,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryPurple,
                  ),
                ),
              ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "Continue",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
