import 'package:flutter/material.dart';
import 'login.dart';
import 'signup.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F1),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
                
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 80, child: // Logo
                  Image.asset(
                    'assets/Logo.png', // Place your logo in assets and update pubspec.yaml
                  )),
                  Padding(padding: const EdgeInsets.symmetric(vertical: 20), child:
                    const SizedBox(child: const Text(
                        'Brewzzle',
                        style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4B2E1E),
                        letterSpacing: 1.2,
                        ),
                  ))),
                  
                  // TODO: Implement on pressGoogle sign-in
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0), // Adjust the value as needed
                    child: SizedBox(
                        height: 48,
                        width: screenWidth * 0.8,
                        child: ElevatedButton.icon(
                        onPressed: () {
                            // TODO: Implement Google sign-in
                        },
                        icon: const Icon(Icons.g_mobiledata, color: Color(0xFF4B2E1E)),
                        label: const Text(
                            'Continue with Google',
                            style: TextStyle(
                            color: Color(0xFF4B2E1E),
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            ),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                            ),
                            elevation: 0,
                        ),
                        ),
                    ),
                ),
                Padding(padding: const EdgeInsets.symmetric(vertical: 10), child:
                  // Google Button
                  SizedBox(height: 48, width: screenWidth * 0.8, child:ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                    child: const Text(
                      'Log in with Email',
                      style: TextStyle(
                        color: Color(0xFF4B2E1E),
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 0,
                    ),
                  ))),
                  // Email Signup Button
                  Padding(padding: const EdgeInsets.symmetric(vertical: 10), child:
                    SizedBox(height: 48, width: screenWidth * 0.8, child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpScreen()),
                      );
                    },
                        child: const Text(
                        'Sign up with Email',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                        ),
                        ),
                        style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4B2E1E),
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                        ),
                        elevation: 0,
                        ),
                    ))),
                  // Email Signup Button
                 Padding(padding: const EdgeInsets.symmetric(vertical: 16), child:
                    SizedBox(child: // Skip for now
                    TextButton(
                        onPressed: () {
                        // TODO: Skip logic
                        },
                        child: const Text(
                        'Skip for now',
                        style: TextStyle(
                            color: Color(0xFF7B8B7B),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                        ),
                        ),
                    ))),
                  
                   Padding(padding: const EdgeInsets.only(top: 10), child : SizedBox(height: 32, child: const Text(
                    'By continuing, you agree to our Terms of Service',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ))),
                ],
            ),
          ),
        ),
      ),
    );
  }
}