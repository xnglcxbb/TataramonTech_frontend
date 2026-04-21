import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'login_screen.dart';
import 'home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  bool obscureText = true;
  bool obscureConfirmText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF384087),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            // Removed fixed height to prevent overflow/scrolling
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 25,
                  spreadRadius: 2,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            // Removed SingleChildScrollView to make the UI static
            child: Column(
              mainAxisSize: MainAxisSize.min, // Shrink-wraps the white box to the content
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TITLE SECTION
                const Center(
                  child: Column(
                    children: [
                      Text(
                        'Sign Up',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          color: Color(0xFF333652),
                        ),
                      ),
                      Text(
                        'TataramonTech',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Lemon',
                          color: Color(0xFF384087),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Name', style: TextStyle(fontFamily: 'PoppinsMedium', fontSize: 14)),
                      const SizedBox(height: 6),
                      buildInputField(hint: "Enter Name"),

                      const SizedBox(height: 14),
                      const Text('Email', style: TextStyle(fontFamily: 'PoppinsMedium', fontSize: 14)),
                      const SizedBox(height: 6),
                      buildInputField(hint: "Enter email"),

                      const SizedBox(height: 14),
                      const Text('Password', style: TextStyle(fontFamily: 'PoppinsMedium', fontSize: 14)),
                      const SizedBox(height: 6),
                      buildInputField(
                        hint: "Enter password",
                        obscureText: obscureText,
                        suffixIcon: IconButton(
                          onPressed: () => setState(() => obscureText = !obscureText),
                          icon: Icon(
                            obscureText ? Icons.remove_red_eye_outlined : Icons.visibility_off_outlined,
                            color: const Color(0xFF384087),
                            size: 20,
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),
                      const Text('Confirm Password', style: TextStyle(fontFamily: 'PoppinsMedium', fontSize: 14)),
                      const SizedBox(height: 6),
                      buildInputField(
                        hint: "Confirm password",
                        obscureText: obscureConfirmText,
                        suffixIcon: IconButton(
                          onPressed: () => setState(() => obscureConfirmText = !obscureConfirmText),
                          icon: Icon(
                            obscureConfirmText ? Icons.remove_red_eye_outlined : Icons.visibility_off_outlined,
                            color: const Color(0xFF384087),
                            size: 20,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // SIGN UP BUTTON
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1F2240),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const HomeScreen()),
                              );
                            }
                          },
                          child: const Text(
                            'Sign up',
                            style: TextStyle(fontSize: 15, fontFamily: 'PoppinsMedium', color: Colors.white),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),
                      const Center(child: Text('OR', style: TextStyle(fontFamily: 'PoppinsMedium', fontSize: 12))),
                      const SizedBox(height: 12),

                      socialButton(text: "Google", icon: "assets/icons/google.svg"),
                      const SizedBox(height: 10),
                      socialButton(text: "Facebook", icon: "assets/icons/facebook.svg"),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account?",
                            style: TextStyle(fontFamily: 'PoppinsMedium', fontSize: 12, color: Color(0xFF333652)),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginScreen()),
                              );
                            },
                            child: const Text(
                              'Sign in',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF333652), fontFamily: 'PoppinsBold', fontSize: 12),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInputField({required String hint, bool obscureText = false, Widget? suffixIcon}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontFamily: 'PoppinsMedium', fontSize: 12, color: Color(0xFFCDD0EC)),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Color(0xFF384087), width: 1.5),
          ),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }

  Widget socialButton({required String text, required String icon}) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1F2240),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(icon, width: 22, height: 22),
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(color: Color(0xFFFAFBFF), fontSize: 15, fontFamily: 'PoppinsMedium'),
            ),
          ],
        ),
      ),
    );
  }
}