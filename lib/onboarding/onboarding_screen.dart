import 'package:app/onboarding/intro_page.dart';
import '../constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  void _skip() {
    _controller.jumpToPage(2);
  }

  void _next() {
    if (_currentPage == 2) {
      Navigator.pushNamed(context, "/login");
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _signIn() {
    Navigator.pushNamed(context, "/login");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: _skip,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryPurple,
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 0),
              ),
              child: const Text(
                "Skip",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: const [
              IntroPage(
                image: "assets/images/IntroPage1.png",
                title: "Now reading books will be easier",
                description:
                    "Discover new worlds, join a vibrant reading community. Start your reading adventure effortlessly with us.",
              ),
              IntroPage(
                  image: "assets/images/IntroPage2.png",
                  title: "Your Bookish Soulmate Awaits",
                  description:
                      "Let us be your guide to the perfect read. Discover books tailored to your tastes for a truly rewarding experience."),
              IntroPage(
                  image: "assets/images/IntroPage3.png",
                  title: "Start Your Adventure",
                  description:
                      "Ready to embark on a quest for inspiration and knowledge? Your adventure begins now. Let's go!"),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: SmoothPageIndicator(
                      controller: _controller,
                      count: 3,
                      effect: SlideEffect(
                        dotHeight: 8,
                        dotWidth: 8,
                        spacing: 4,
                        dotColor: Colors.grey[200]!,
                        activeDotColor: AppColors.primaryPurple,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 327),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _next,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          _currentPage == 2 ? "Get Started" : "Continue",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 327),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton(
                        onPressed: _signIn,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide.none,
                          backgroundColor: Colors.grey[50],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Sign in",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryPurple,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
