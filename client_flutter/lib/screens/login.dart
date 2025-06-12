import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final Color background = const Color(0xFFF9F6F1);
    final Color primaryBrown = const Color(0xFF4B2E1E);
    final Color mutedGreen = const Color(0xFF7B8B7B);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        automaticallyImplyLeading: true, // shows back button automatically
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4B2E1E)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Image.asset('assets/Logo.png', height: 32),
            const SizedBox(width: 8),
            const Text(
              "Brewzzle",
              style: TextStyle(
                color: Color(0xFF4B2E1E),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: 
          SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 32),

                  // Email field
                  Container(
                    width: screenWidth * 0.8,
                    alignment: Alignment.centerLeft,
                    child: const Text("Email"),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: screenWidth * 0.8,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Enter your email",
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),


                  const SizedBox(height: 24),

                  // Password field
                  Container(
                    width: screenWidth * 0.8,
                    alignment: Alignment.centerLeft,
                    child: const Text("Password"),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(width: screenWidth * 0.8, child:
                  TextField(
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: "Enter your password",
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  )),

                  const SizedBox(height: 32),

                  // Login Button
                  SizedBox(
                    height: 48,
                    width: screenWidth * 0.7,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBrown,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text("Login", style: TextStyle(fontSize: 16, color: Colors.white))
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Forgot Password
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: mutedGreen,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Sign up text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(color: mutedGreen),
                      ),
                      GestureDetector(
                        onTap: () {
                          // TODO: Navigate to Sign Up
                        },
                        child: Text(
                          "Sign up",
                          style: TextStyle(
                            color: primaryBrown,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Divider with "or"
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey.shade300)),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("or", style: TextStyle(color: Colors.grey)),
                      ),
                      Expanded(child: Divider(color: Colors.grey.shade300)),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Google Sign-In
                  SizedBox(
                    width: screenWidth * 0.7,
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Google Sign-In
                      },
                      icon: const Icon(Icons.g_mobiledata, color: Colors.black, size: 32),
                      label: const Text(
                        "Continue with Google",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        side: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
          ),
        ),
      )
    )
    );
  }
}
