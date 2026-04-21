import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? selectedGender;

  @override
  void dispose() {
    _usernameController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF384087),
      // Removing SafeArea here allows the Container to hit the bottom edge
      body: Column(
        children: [
          // HEADER SECTION
          // We add top padding manually now to account for the status bar
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 50, 25, 10),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      "Edit Profile",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'PoppinsBold',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),

          // MAIN CONTENT BODY
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
                // Use bottom padding here to ensure content isn't
                // cut off by the home indicator on iOS/Android
                padding: const EdgeInsets.fromLTRB(30, 40, 30, 40),
                child: Column(
                  children: [
                    _buildProfilePictureSection(),
                    const SizedBox(height: 40),
                    _buildProfileField("USERNAME", "Enter username", _usernameController),
                    const SizedBox(height: 20),
                    _buildProfileField("FULL NAME", "Enter name", _fullNameController),
                    const SizedBox(height: 20),
                    _buildProfileField("EMAIL ADDRESS", "Enter email", _emailController),
                    const SizedBox(height: 20),
                    _buildGenderDropdown(),
                    const SizedBox(height: 50),
                    _buildSaveButton(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePictureSection() {
    return Stack(
      children: [
        Container(
          width: 120,
          height: 120,
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
        Positioned(
          bottom: 5,
          right: 5,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration( // Removed 'const' because of dynamic shadow values
              color: const Color(0xFFCDD0EC),
              shape: BoxShape.circle,
              // Use boxShadow for the Container
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Icon(
              Icons.edit_outlined,
              size: 20,
              color: const Color(0xFF384087),
              // Use shadows for the Icon
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "GENDER",
          style: TextStyle(
              fontFamily: 'PoppinsBold',
              fontSize: 15,
              color: Color(0xFF384087)),
        ),
        const SizedBox(height: 8),
        Container(
          // 1. Set the desired height here
          height: 45,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xFFCDD0EC)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4)),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              // 2. Set itemHeight to match or be slightly less than your container height
              // Flutter default is 48.0, so we must lower it for a 45.0 container.
              itemHeight: 48.0,
              value: selectedGender,
              hint: const Text(
                "Select",
                style: TextStyle(color: Color(0xFFCDD0EC), fontSize: 13),
              ),
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF384087)),
              items: ["Male", "Female", "Other"]
                  .map((String value) => DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: const TextStyle(fontSize: 13)),
              ))
                  .toList(),
              onChanged: (newValue) => setState(() => selectedGender = newValue),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
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
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile Updated Successfully!")));
          Navigator.pop(context);
        },
        child: const Text("Save",
            style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'PoppinsSemiBold',
            ),
        ),
      ),
    );
  }

  Widget _buildProfileField(String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontFamily: 'PoppinsBold',
                fontSize: 14,
                color: Color(0xFF384087))
        ),
        const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4))
            ],
          ),
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              isDense: true, // IMPORTANT: Makes the field more compact
              hintStyle: const TextStyle(
                color: Color(0xFFCDD0EC),
                fontSize: 13,
              ),
              filled: true,
              fillColor: Colors.white,
              // Adjust vertical padding to control height internally
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),

              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Color(0xFFCDD0EC))
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                      color: Color(0xFF384087),
                      width: 1.8)
              ),
            ),
          ),
        ),
      ],
    );
  }
}