import 'package:flutter/material.dart';
import '../../widgets/profile_utils.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF384087),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            buildProfileHeader(context, "About Us"),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: profileContainerDecoration(),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      const Text("TranslateApp v1.0", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 20),
                      RichText(
  textAlign: TextAlign.center,
  text: const TextSpan(
    style: TextStyle(
      color: Colors.black,
      fontSize: 16,
      height: 1.5,
    ),
    children: [
      TextSpan(
        text: 'TataramonTech ',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      TextSpan(
        text:
            'is a mobile translation application designed to translate words, phrases, and sentences between ',
      ),
      TextSpan(
        text: 'English and Central Bikol',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      TextSpan(
        text:
            '. The application uses the ',
      ),
      TextSpan(
        text: 'Apertium Rule-Based Machine Translation (RBMT)',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      TextSpan(
        text:
            ' framework to provide accurate and understandable translations while also displaying ',
      ),
      TextSpan(
        text: 'Part-of-Speech (POS) tags',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      TextSpan(
        text:
            ' for better language understanding.\n\n'
            'Our goal is to help students, educators, and language enthusiasts learn and understand the Central Bikol language while promoting its use as a regional language through modern technology.\n\n'
            'The application was developed by Computer Science students from ',
      ),
      TextSpan(
        text: 'Bicol University – College of Science',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      TextSpan(
        text:
            '.\n\n'
            'Developers:\n'
            '• Marlon Jy Bataller\n'
            '• Angelica Bilaos\n'
            '• Yno Gabarda\n'
            '• Brian Makiling\n'
            '• Brent Clyde Ricablanca\n\n'
            'We are committed to continuously improving the application by enhancing translation accuracy, expanding language resources, and listening to user feedback.',
      ),
    ],
  ),
),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}