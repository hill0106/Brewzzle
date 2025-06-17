import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'login.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final Color background = const Color(0xFFF9F6F1);
  final Color primaryBrown = const Color(0xFF4B2E1E);
  final Color mutedGreen = const Color(0xFF7B8B7B);

  bool _showPassword = false;
  bool _showConfirmPassword = false;
  DateTime? _selectedDate;

  final TextEditingController _birthdayController = TextEditingController();

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _birthdayController.text = DateFormat('MM/dd/yyyy').format(picked);
      });
    }
  }

  Widget _buildField(String label, String hint, {bool obscure = false, bool toggle = false, TextEditingController? controller, VoidCallback? onSuffixTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF4B2E1E), fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            suffixIcon: toggle
              ? IconButton(
                  icon: Icon(
                    obscure ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: onSuffixTap,
                )
              : null,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Form fields
              _buildField("Full Name", "Enter your full name"),
              _buildField("Email", "Enter your email"),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Birthday", style: TextStyle(color: Color(0xFF4B2E1E), fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _birthdayController,
                    readOnly: true,
                    onTap: () => _pickDate(context),
                    decoration: InputDecoration(
                      hintText: "mm/dd/yyyy",
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: const Icon(Icons.calendar_today),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
              _buildField(
                "Password",
                "Create a strong password",
                obscure: !_showPassword,
                toggle: true,
                onSuffixTap: () => setState(() => _showPassword = !_showPassword),
              ),
              _buildField(
                "Confirm Password",
                "Confirm your password",
                obscure: !_showConfirmPassword,
                toggle: true,
                onSuffixTap: () => setState(() => _showConfirmPassword = !_showConfirmPassword),
              ),

              // Sign up button
              SizedBox(
                width: screenWidth * 0.8,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Handle sign up
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBrown,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text("Sign up", style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),

              const SizedBox(height: 24),

              // Divider
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
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Google Sign-In
                  },
                  icon: const Icon(Icons.g_mobiledata, color: Colors.black),
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

              // Already have account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? ", style: TextStyle(color: mutedGreen)),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                    child: Text(
                      "Log in",
                      style: TextStyle(
                        color: primaryBrown,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ))
    );
  }
}
