import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';
import 'dashboard_screen.dart';
import 'database_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  late AnimationController _floatController;
  final Color primaryPurple = const Color(0xFFB8A2D6);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    emailController.dispose();
    passwordController.dispose();
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
          _bling(top: 100, left: 40, size: 30),
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _floatController,
              builder: (context, child) => Transform.translate(
                offset: Offset(0, _floatController.value * -20),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: primaryPurple.withAlpha(120), blurRadius: 80, spreadRadius: 10)],
                    ),
                    child: Hero(
                      tag: 'mascot_hero',
                      child: Image.asset('assets/rb_mascot.png', height: 220),
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
                  constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.6),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 40),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(160),
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
                    border: Border.all(color: Colors.white.withAlpha(100), width: 2),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('WELCOME BACK', style: GoogleFonts.pressStart2p(fontSize: 10, color: Colors.black45)),
                        const SizedBox(height: 16),
                        Text('LOGIN', style: GoogleFonts.pressStart2p(fontSize: 24, color: primaryPurple, shadows: [Shadow(color: primaryPurple.withAlpha(100), blurRadius: 15)])),
                        const SizedBox(height: 32),
                        _field("EMAIL", "pixel@bytes.com", emailController),
                        const SizedBox(height: 24),
                        _field("PASSWORD", "********", passwordController, isPass: true),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
                              );
                            },
                            child: Text('Forgot Password?', style: GoogleFonts.poppins(color: Colors.black54, fontSize: 13)),
                          ),
                        ),
                        const SizedBox(height: 32),
                      const SizedBox(height: 32),
                        _neonButton("SIGN IN", () async {
                          String email = emailController.text.trim().toLowerCase();
                          String password = passwordController.text.trim();

                          if (email.isEmpty || password.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Please fill all fields")),
                            );
                            return;
                          }

                          final user = await DatabaseHelper.instance.loginUser(email, password);

                          if (user != null) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const DashboardScreen()),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Invalid email or password")),
                            );
                          }
                        }),
                        const SizedBox(height: 16),
                        Center(
                          child: TextButton(
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
                            child: Text("Don't have an account? Sign up", style: GoogleFonts.poppins(color: primaryPurple, fontWeight: FontWeight.bold)),
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
            fillColor: Colors.white.withAlpha(200),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          ),
        ),
      ],
    );
  }

  Widget _neonButton(String txt, VoidCallback onTap) {
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
            elevation: 0
        ),
        onPressed: onTap,
        child: Text(txt, style: GoogleFonts.pressStart2p(fontSize: 14, color: Colors.white)),
      ),
    );
  }

  Widget _bling({required double top, double? left, double? right, required double size}) {
    return Positioned(top: top, left: left, right: right, child: Container(width: size, height: size, decoration: BoxDecoration(color: primaryPurple.withAlpha(80), borderRadius: BorderRadius.circular(6))));
  }
}