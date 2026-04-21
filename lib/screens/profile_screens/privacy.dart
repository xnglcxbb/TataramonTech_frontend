import 'package:flutter/material.dart';
import '../../widgets/profile_utils.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF384087),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            buildProfileHeader(context, "Privacy"),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: profileContainerDecoration(),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.lock_outline, color: Color(0xFF384087)),
                        title: const Text(
                          "Change Password",
                          style: TextStyle(
                            fontFamily: 'PoppinsMedium',
                            color: Color(0xFF333652),
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
                        onTap: () {
                          // password reset logic here
                        },
                      ),
                      const Divider(height: 1, indent: 15, endIndent: 15),
                      ListTile(
                        leading: const Icon(Icons.description_outlined, color: Color(0xFF384087)),
                        title: const Text(
                          "Privacy Policy",
                          style: TextStyle(
                            fontFamily: 'PoppinsMedium',
                            color: Color(0xFF333652),
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
                        onTap: () {
                          // Logic to open a PDF or URL
                        },
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