import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'signup_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool rememberMe = false;
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF384087),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            height: 727,
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

            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // TITLE
                  const Center(
                    child: Column(
                      children: [
                        Text(
                          'Welcome back!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                            color: Color(0xFF333652),
                            shadows: [
                              Shadow(
                                offset: Offset(2, 2),
                                blurRadius: 8,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'Good to see you again',
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

                  const SizedBox(height: 45),

                  // FORM
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Padding(padding: const EdgeInsets.only(left: 2),
                          child: const Text(
                            'Email',
                            style: TextStyle(
                              fontFamily: 'PoppinsMedium',
                              fontSize: 14,
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        Center(
                          child: SizedBox(
                            width: double.infinity,
                            child: buildInputField(
                              hint: "Enter email",
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        Padding(padding: const EdgeInsets.only(left: 2),
                        child: const Text(
                          'Password',
                          style: TextStyle(
                            fontFamily: 'PoppinsMedium',
                            fontSize: 14,
                          ),
                        ),
                        ),

                        const SizedBox(height: 10),

                        buildInputField(
                          hint: "Enter password",
                          obscureText: obscureText,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                obscureText = !obscureText;
                              });
                            },
                            icon: Icon(
                              // Toggle between the eye and the eye-off icon
                              obscureText ? Icons.remove_red_eye_outlined : Icons.visibility_off_outlined,
                              color: const Color(0xFF384087),
                              size: 22, // Matches your SVG sizing
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // REMEMBER + FORGOT
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Transform.scale(
                                  scale: 0.5,
                                  child: Checkbox(
                                    value: rememberMe,
                                    materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                    visualDensity: VisualDensity.compact,
                                    onChanged: (value) {
                                      setState(() {
                                        rememberMe = value ?? false;
                                      });
                                    },
                                  ),
                                ),
                                const Text(
                                  'Remember me',
                                  style: TextStyle(
                                    fontFamily: 'PoppinsMedium',
                                    fontSize: 12,
                                    color: Color(0xFF333652),
                                  ),
                                ),
                              ],
                            ),
                            const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontFamily: 'PoppinsSemiBold',
                                fontSize: 12,
                                color: Color(0xFF333652),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 40),

                        // LOGIN BUTTON
                        SizedBox(
                          width: double.infinity,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.12),
                                  blurRadius: 25,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1F2240),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding:
                                const EdgeInsets.symmetric(vertical: 14),
                                elevation: 0,
                              ),
                              // LOGIN BUTTON
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  // In a real app, you'd check your database/API here.
                                  // If successful, navigate to the Home Screen:
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const HomeScreen(),
                                    ),
                                  );
                                  print("Login success!");
                                }
                              },
                              child: const Text(
                                'Log in',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'PoppinsMedium',
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Center(child: Text('OR',
                          style: TextStyle(
                            fontFamily: 'PoppinsMedium',
                            fontSize: 13,
                          ),
                        ),
                        ),

                        const SizedBox(height: 20),

                        socialButton(
                          text: "Google",
                          icon: "assets/icons/google.svg",
                        ),

                        const SizedBox(height: 10),

                        socialButton(
                          text: "Facebook",
                          icon: "assets/icons/facebook.svg",
                        ),

                        const SizedBox(height: 30),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center, // Center usually looks better for this UI pattern
                          children: [
                            const Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                fontFamily: 'PoppinsMedium',
                                fontSize: 12,
                                color: Color(0xFF333652),
                              ),
                            ),
                            TextButton( // Using TextButton for a cleaner "link" look
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const SignupScreen()),
                                );
                              },
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF333652),
                                  fontFamily: 'PoppinsBold',
                                  fontSize: 12, // Match the size of your prompt text
                                ),
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
      ),
    );
  }

  // INPUT FIELD
  Widget buildInputField({
    required String hint,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
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
          hintStyle: const TextStyle(
            fontFamily: 'PoppinsMedium',
            fontSize: 12,
            color: Color(0xFFCDD0EC),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              color: Colors.blueAccent,
              width: 1.5,
            ),
          ),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }

  // SOCIAL BUTTON
  Widget socialButton({required String text, required String icon}) {
    return SizedBox(
      width: double.infinity,
      height: 41,
      child: Material(
        color: const Color(0xFF1F2240),
        borderRadius: BorderRadius.circular(30),
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(icon, width: 20, height: 20),
                const SizedBox(width: 5),
                Text(
                  text,
                  style: const TextStyle(
                    color: Color(0xFFFAFBFF),
                    fontSize: 14,
                    fontFamily: 'PoppinsMedium',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}