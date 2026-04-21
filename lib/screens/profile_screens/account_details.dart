import 'package:flutter/material.dart';
import 'package:soft_eng_projects/screens/profile_screens/edit_profile.dart';

class AccountDetailsScreen extends StatelessWidget {
  const AccountDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF384087),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // --- HEADER ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Sophia',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'PoppinsBold',
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Balancing spacer for the back button
                ],
              ),
            ),

            // --- MAIN WHITE CONTAINER ---
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
                  padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Picture Center Alignment
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey.shade300, width: 1),
                                color: Colors.white,
                                // ADDED: Shadow for the circular profile container
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.06),
                                    blurRadius: 15,
                                    offset: const Offset(2, 5),
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: const CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(Icons.person_outline, size: 30, color: Color(0xFF384087)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 50),

                      // User Info List
                      _buildInfoField("USERNAME", "@sophielicious"),
                      _buildInfoField("FULL NAME", "Sophia Thompson"),
                      _buildInfoField("GENDER", "Female"),
                      _buildInfoField("EMAIL ADDRESS", "sophiathompson19@gmail.com"),

                      const SizedBox(height: 80),

                      // Edit Profile Action Button
                      SizedBox(
                        width: double.infinity,
                        height: 41,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF384087),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            elevation: 5,
                            shadowColor: Colors.black.withValues(alpha: 0.5),
                          ),
                          onPressed: () {
                            // Navigates to the EditProfile screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                            );
                          },
                          child: const Text(
                            "Edit Profile",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'PoppinsSemiBold',
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
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

  Widget _buildInfoField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF384087),
              fontFamily: 'PoppinsBold',
              fontSize: 15,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF5D6398),
              fontFamily: 'PoppinsMedium',
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}