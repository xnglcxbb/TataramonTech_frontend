import 'package:flutter/material.dart';
import '../login_screen.dart';

class Onboarding1 extends StatefulWidget {
  const Onboarding1({super.key});

  @override
  State<Onboarding1> createState() => _Onboarding1State();
}

class _Onboarding1State extends State<Onboarding1> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _goToLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ── Swipeable pages ──────────────────────────────
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            children: [
              buildPage(
                title: 'Welcome to TataramonTech',
                description: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(
                        fontFamily: 'PoppinsMedium',
                        fontSize: 12,
                        color: Color(0xFF333652)),
                    children: [
                      TextSpan(
                          text: 'A smart app to help you translate between\n'),
                      TextSpan(
                        text: 'English and Bikol',
                        style: TextStyle(
                            fontFamily: 'PoppinsBold',
                            color: Color(0xFF384087),
                            fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: ' effortlessly.'),
                    ],
                  ),
                ),
              ),
              buildPage(
                title: 'Understand Every Word',
                description: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(
                        fontFamily: 'PoppinsMedium',
                        fontSize: 12,
                        color: Color(0xFF333652)),
                    children: [
                      TextSpan(text: 'TataramonTech shows '),
                      TextSpan(
                        text: 'Part-of-Speech (POS)\ntags',
                        style: TextStyle(
                            fontFamily: 'PoppinsBold',
                            color: Color(0xFF384087),
                            fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                          text:
                              ' so you can see how each word\nfunctions in a sentence.'),
                    ],
                  ),
                ),
              ),
              buildPage(
                title: 'Save and Explore',
                description: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(
                        fontFamily: 'PoppinsMedium',
                        fontSize: 12,
                        color: Color(0xFF333652)),
                    children: [
                      TextSpan(
                          text:
                              'Keep your translation history and\nexplore sentences easily.\n'),
                      TextSpan(
                        text: 'Learn, translate, and understand\n',
                        style: TextStyle(
                            fontFamily: 'PoppinsBold',
                            color: Color(0xFF384087),
                            fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                          text: 'language better with TataramonTech!'),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ── Bottom controls ──────────────────────────────
          Positioned(
            bottom: 50,
            left: 30,
            right: 30,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Dots
                buildDots(),
                const SizedBox(height: 30),

                // Next / Get Started button
                GestureDetector(
                  onTap: _nextPage,
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF384087),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        _currentPage == 2 ? 'Get Started' : 'Next',
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'PoppinsSemiBold',
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Skip button (only on pages 0 and 1)
                if (_currentPage < 2)
                  GestureDetector(
                    onTap: _goToLogin,
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'Poppins',
                        color: Color(0xFFA1A5CD),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPage({required String title, required Widget description}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/logo.png',
            width: 250,
            height: 180,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 15),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              letterSpacing: 2.0,
              color: Color(0xFF384087),
              fontSize: 16,
              fontFamily: 'PoppinsBold',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 3),
          description,
          const SizedBox(height: 140),
        ],
      ),
    );
  }

  Widget buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? Colors.amber
                : const Color(0xFF384087),
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}
