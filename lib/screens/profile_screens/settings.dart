import 'package:flutter/material.dart';
import '../../widgets/profile_utils.dart';
import '../history_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedLanguage = 'English';

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'App Language',
          style: TextStyle(fontFamily: 'PoppinsSemiBold', color: Color(0xFF384087)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['English'].map((lang) {
            return RadioListTile<String>(
              title: Text(lang, style: const TextStyle(fontFamily: 'Poppins')),
              value: lang,
              groupValue: _selectedLanguage,
              activeColor: const Color(0xFF384087),
              onChanged: (value) {
                setState(() => _selectedLanguage = value!);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF384087), fontFamily: 'Poppins'),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Clear History',
          style: TextStyle(fontFamily: 'PoppinsSemiBold', color: Color(0xFF384087)),
        ),
        content: const Text(
          'Are you sure you want to clear all translation history?',
          style: TextStyle(fontFamily: 'Poppins'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.grey, fontFamily: 'Poppins'),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() => historyItems.clear());
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('History cleared'),
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 1),
                ),
              );
            },
            child: const Text(
              'Clear',
              style: TextStyle(
                color: Colors.red,
                fontFamily: 'PoppinsSemiBold',
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF384087),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            buildProfileHeader(context, "Settings"),
            Expanded(
              child: Container(
                width: double.infinity,
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
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _selectedLanguage,
                            style: const TextStyle(fontFamily: 'PoppinsMedium', color: Colors.grey),
                          ),
                          const Icon(Icons.chevron_right, color: Colors.grey),
                        ],
                      ),
                      onTap: _showLanguageDialog,
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.delete_outlined, color: Color(0xFF384087)),
                      title: const Text(
                        "Clear History",
                        style: TextStyle(fontFamily: 'PoppinsMedium', color: Color(0xFF384087)),
                      ),
                      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                      onTap: _showClearHistoryDialog,
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