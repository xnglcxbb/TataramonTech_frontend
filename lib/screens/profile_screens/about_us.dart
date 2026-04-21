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
                child: const Padding(
                  padding: EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Text("TranslateApp v1.0", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      SizedBox(height: 20),
                      Text(
                        "Providing seamless English to Bikol translations for students and travelers.",
                        textAlign: TextAlign.center,
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