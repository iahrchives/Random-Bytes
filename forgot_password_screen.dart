import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'database_helper.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> with TickerProviderStateMixin {
  late AnimationController _floatController;
  final Color primaryPurple = const Color(0xFFB8A2D6);
  final TextEditingController emailController = TextEditingController(); // Added controller

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
          Positioned(
            top: 100,
            right: 0,
            left: 0,
            child: AnimatedBuilder(
              animation: _floatController,
              builder: (context, child) => Transform.rotate(
                angle: _floatController.value * -0.1,
                child: Hero(
                  tag: 'mascot_hero',
                  child: Image.asset('assets/rb_mascot.png', height: 250),
                ),
              ),
            ),
          ),
          _bling(top: 150, left: 30, size: 25),
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * 0.55,
                  ),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 40),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(160),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                    border: Border.all(color: Colors.white.withAlpha(100), width: 2),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('OOPS!', style: GoogleFonts.pressStart2p(fontSize: 10, color: Colors.black45)),
                        const SizedBox(height: 16),
                        Text('FORGOT\nPASSWORD',
                          style: GoogleFonts.pressStart2p(
                              fontSize: 22,
                              color: primaryPurple,
                              height: 1.4,
                              shadows: [Shadow(color: primaryPurple.withAlpha(100), blurRadius: 15)]
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Don\'t worry! Enter your email and we\'ll send you a byte-sized code to reset it.',
                          style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
                        ),
                        const SizedBox(height: 32),

                        _field("EMAIL", "pixel@bytes.com", emailController),

                        const SizedBox(height: 40),
                        _neonButton("SEND RESET CODE"),

                        const SizedBox(height: 16),
                        Center(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              "Wait, I remember it! Log in",
                              style: GoogleFonts.poppins(
                                color: primaryPurple,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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

  Widget _field(String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.pressStart2p(fontSize: 9, color: Colors.black87)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
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

  Widget _neonButton(String txt) {
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
          String email = emailController.text.trim();
          if (email.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Please enter your email")),
            );
            return;
          }

          bool exists = await DatabaseHelper.instance.checkEmailExists(email);
          if (!exists) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Email not found")),
            );
            return;
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Reset code sent to $email")),
          );
        },
        child: Text(txt, style: GoogleFonts.pressStart2p(fontSize: 12, color: Colors.white)),
      ),
    );
  }

  Widget _bling({required double top, double? left, double? right, required double size}) {
    return Positioned(
      top: top, left: left, right: right,
      child: Container(
        width: size, height: size,
        decoration: BoxDecoration(
          color: primaryPurple.withAlpha(80),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }
}
