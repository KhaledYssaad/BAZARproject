import 'package:flutter/material.dart';
import 'package:app/constants/colors.dart';

class HelpCenter extends StatelessWidget {
  const HelpCenter({super.key});

  final List<Map<String, String>> faqs = const [
    {
      "question": "How do I reset my password?",
      "answer": "Go to Profile > Change Password and follow the instructions."
    },
    {
      "question": "How can I contact support?",
      "answer":
          "You can email support@example.com or use the Contact Us button below."
    },
    {
      "question": "How do I add books to my cart?",
      "answer": "Browse the library, select a book, and tap 'Add to Cart'."
    },
    {
      "question": "How do I mark a book as favorite?",
      "answer":
          "Tap the heart icon on the book detail page to add it to your favorites."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Help Center",
          style: TextStyle(
            fontFamily: "Open Sans",
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              "Frequently Asked Questions",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...faqs.map((faq) => Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                  child: ExpansionTile(
                    tilePadding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    childrenPadding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    backgroundColor: Colors.transparent,
                    collapsedBackgroundColor: Colors.transparent,
                    title: Text(
                      faq["question"]!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    children: [
                      Text(
                        faq["answer"]!,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ))),
            const SizedBox(height: 24),
            Container(
              height: 40,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.email,
                  color: Colors.white,
                ),
                label: const Text("Contact Support (mzel yakho)",
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
