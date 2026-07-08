import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

Future<void> resetDatabase() async {
  String path = join(await getDatabasesPath(), 'retail.db');
  print("Database path: $path");
  await deleteDatabase(path);
  print("Database deleted. You can now register fresh users.");
}

class _RegisterScreenState extends State<RegisterScreen> with TickerProviderStateMixin {
  late AnimationController _floatController;
  final Color primaryPurple = const Color(0xFFB8A2D6);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      await resetDatabase();
    });

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }



  @override
  void dispose() {
    _floatController.dispose();
    nameController.dispose();
    emailController.dispose();
    addressController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFDE2E4), Colors.white, Color(0xFFE2D1F9)],
              ),
            ),
          ),
          _bling(top: 180, right: 30, size: 20),
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _floatController,
              builder: (context, child) => Transform.translate(
                offset: Offset(0, _floatController.value * -15),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: primaryPurple.withAlpha(100), blurRadius: 80, spreadRadius: 5)],
                    ),
                    child: Hero(
                      tag: 'mascot_hero',
                      child: Image.asset('assets/rb_mascot.png', height: 200),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.75),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 32),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(180),
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
                    border: Border.all(color: Colors.white.withAlpha(100), width: 2),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('NEW ADVENTURE', style: GoogleFonts.pressStart2p(fontSize: 10, color: Colors.black45)),
                        const SizedBox(height: 16),
                        Text('SIGN UP', style: GoogleFonts.pressStart2p(fontSize: 24, color: primaryPurple, shadows: [Shadow(color: primaryPurple.withAlpha(100), blurRadius: 10)])),
                        const SizedBox(height: 32),
                        _field("NAME", "Insert name", nameController),
                        const SizedBox(height: 16),
                        _field("EMAIL", "Insert email", emailController),
                        const SizedBox(height: 16),
                        _field("ADDRESS", "Insert address", addressController),
                        const SizedBox(height: 16),
                        _field("PASSWORD", "******", passwordController, isPass: true),
                        const SizedBox(height: 16),
                        _field("CONFIRM PASSWORD", "******", confirmPasswordController, isPass: true),
                        const SizedBox(height: 32),
                        _neonButton(context, "JOIN NOW"),
                        const SizedBox(height: 16),
                        Center(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Already a member? Log in', style: GoogleFonts.poppins(color: primaryPurple, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(String label, String hint, TextEditingController controller, {bool isPass = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.pressStart2p(fontSize: 9, color: Colors.black87)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPass,
          style: GoogleFonts.poppins(fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white.withAlpha(220),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          ),
        ),
      ],
    );
  }

  Widget _neonButton(BuildContext context, String txt) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: primaryPurple.withAlpha(150), blurRadius: 20)],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPurple,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
        ),
        onPressed: () async {
          if (nameController.text.isEmpty ||
              emailController.text.isEmpty ||
              addressController.text.isEmpty ||
              passwordController.text.isEmpty ||
              confirmPasswordController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Please fill all fields")),
            );
            return;
          }

          if (passwordController.text != confirmPasswordController.text) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Passwords do not match")),
            );
            return;
          }

          try {
            String name = nameController.text.trim();
            String email = emailController.text.trim().toLowerCase();
            String address = addressController.text.trim();
            String password = passwordController.text.trim();

            bool exists = await DatabaseHelper.instance.checkEmailExists(email);
            if (exists) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Email already registered")),
              );
              return;
            }

            await DatabaseHelper.instance.registerUser(name, email, address, password);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Registration Successful")),
            );

            Navigator.pop(context);
          } catch (e) {
            print("Registration error: $e");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error: $e")),
            );
          }
        },
        child: Text(txt, style: GoogleFonts.pressStart2p(fontSize: 14, color: Colors.white)),
      ),
    );
  }

  Widget _bling({required double top, double? left, double? right, required double size}) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: primaryPurple.withAlpha(80),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }

}
