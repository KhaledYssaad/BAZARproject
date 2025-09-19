import 'package:app/constants/colors.dart';
import 'package:app/widgets/service_not_available_yet.dart';
import 'package:flutter/material.dart';

class SpecialOffer extends StatefulWidget {
  const SpecialOffer({super.key});

  @override
  State<SpecialOffer> createState() => _SpecialOfferState();
}

class _SpecialOfferState extends State<SpecialOffer> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> images = [
    'https://covers.openlibrary.org/b/id/7887562-L.jpg',
    'https://covers.openlibrary.org/b/id/7893034-L.jpg',
    'https://covers.openlibrary.org/b/id/7887563-L.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 162,
      child: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: List.generate(3, (index) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        height: 145,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Special Offer",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "Open Sans",
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "Discount 25%",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black54),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                ServiceNotAvailableYet.show(context,
                                    "we'll add discounts dynamicly by Sanity");
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryPurple,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                              ),
                              child: const Text(
                                "Order Now",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Roboto",
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 99,
                        height: 145,
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(3.14),
                        ),
                        child: Image.network(
                          images[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 8 : 4,
                height: _currentPage == index ? 8 : 4,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? Colors.purple
                      : Colors.purple.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
