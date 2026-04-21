import 'package:flutter/material.dart';
import 'onboarding/onboarding_1.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const Onboarding1(),
          ),
        );
      },

      child: Scaffold(
        backgroundColor: Colors.white,

        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Image.asset(
                'assets/images/logo.png',
                width: 198,
                height: 155,
              ),

              const SizedBox(height: 20),

              const Text(
                'TataramonTech',
                style: TextStyle(
                  color: Color(0xFF333652),
                  fontSize: 24,
                  fontFamily: 'Lemon',
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Text(
                'Bridging Bikol and English — One Word at a Time',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}