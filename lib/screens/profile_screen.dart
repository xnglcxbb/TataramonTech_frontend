import 'package:flutter/material.dart';
import 'profile_screens/account_details.dart';
import 'profile_screens/privacy.dart';
import 'profile_screens/settings.dart';
import 'profile_screens/about_us.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // --- TOP HEADER AREA ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                'Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'PoppinsBold',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.9),
                      offset: const Offset(2, 2),
                      blurRadius: 15,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // --- MAIN WHITE CONTENT AREA ---
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  // Profile Picture Section
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Color(0xFFF0F2FF),
                    child: Icon(Icons.person, size: 30, color: Color(0xFF384087)),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Sophia Thompson",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'PoppinsBold',
                      color: Color(0xFF384087),
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.grey.withValues(alpha: 0.3),
                          offset: const Offset(2, 2),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    "sophiathompson19@gmail.com",
                    style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFFAFB5EB),
                        fontFamily: 'PoppinsMedium'
                    ),
                  ),
                  const SizedBox(height: 40),

                  // --- CONNECTED BUTTONS ---
                  _buildProfileItem(
                    Icons.person_outline,
                    "Account Details",
                        () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AccountDetailsScreen()),
                    ),
                  ),
                  _buildProfileItem(
                    Icons.security_rounded,
                    "Privacy & Security",
                        () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PrivacyScreen()),
                    ),
                  ),
                  _buildProfileItem(
                    Icons.settings,
                    "Settings",
                        () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SettingsScreen()),
                    ),
                  ),
                  _buildProfileItem(
                    Icons.info,
                    "About Us",
                        () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AboutUsScreen()),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Add Logout Logic / Navigation here
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF384087),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                      ),
                      child: const Text(
                        "Log out",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'PoppinsSemiBold',
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileItem(IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F2FF),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF384087)),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'PoppinsMedium',
                  fontSize: 16,
                  color: Color(0xFF333652),
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}