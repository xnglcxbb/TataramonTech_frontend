import 'package:flutter/material.dart';
import '../../widgets/profile_utils.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF384087),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // 2. Using the shared public helper
            buildProfileHeader(context, "Settings"),
            Expanded(
              child: Container(
                width: double.infinity,
                // 3. Using the shared public decoration
                decoration: profileContainerDecoration(),
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  children: [
                    ListTile(
                      leading: const Icon(Icons.language_rounded, color: Color(0xFF384087)),
                      title: const Text(
                        "App Language",
                        style: TextStyle(fontFamily: 'PoppinsMedium', color: Color(0xFF333652)),
                      ),
                      trailing: const Text(
                        "English",
                        style: TextStyle(fontFamily: 'PoppinsMedium', color: Colors.grey),
                      ),
                      onTap: () {
                        // Logic for language selection
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.delete_sweep_outlined, color: Colors.redAccent),
                      title: const Text(
                        "Clear History",
                        style: TextStyle(
                          fontFamily: 'PoppinsMedium',
                          color: Colors.redAccent,
                        ),
                      ),
                      onTap: () {
                        // Logic for clearing local translation data
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}