import 'package:flutter/material.dart';
import 'package:concentric_transition/concentric_transition.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dashboard_screen.dart';
import 'admin_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RandomBytesApp());
}

class RandomBytesApp extends StatelessWidget {
  const RandomBytesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Random Bytes',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        primaryColor: const Color(0xFFB8A2D6),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFB8A2D6)),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomePage(),
        '/home': (context) => const DashboardScreen(),
        '/admin': (context) => const AdminPage(),
      },
    );
  }
}

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> with TickerProviderStateMixin {
  late AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _PageData(
        title: "WELCOME!",
        subtitle: 'Sweet Surprises,\nOne Byte at a time.',
        image: "assets/rb_mascot.png",
        bgColor: const Color(0xFFFDE2E4),
        textColor: const Color(0xFFB8A2D6),
      ),
      _PageData(
        title: "DESSERT BLIND BOX",
        subtitle: "Ready to start your surprise?",
        image: "assets/rb_mascot.png",
        bgColor: const Color(0xFFB8A2D6),
        textColor: Colors.white,
      ),
    ];

    final size = MediaQuery.of(context).size;
    final isWeb = size.width > 600;

    return Scaffold(
      body: ConcentricPageView(
        colors: pages.map((p) => p.bgColor).toList(),
        radius: isWeb ? 60 : 40,
        itemCount: pages.length,
        itemBuilder: (index) {
          final page = pages[index];

          return Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Stack(
                children: [
                  _animatedPixel(top: 100, left: 40, size: 30, color: page.textColor.withAlpha(80), offset: 1.0),
                  _animatedPixel(top: 220, right: 30, size: 20, color: page.textColor.withAlpha(60), offset: 0.5),

                  SafeArea(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        constraints: BoxConstraints(minHeight: size.height - 50),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 40),
                            AnimatedBuilder(
                              animation: _floatController,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(0, _floatController.value * -20),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: page.textColor.withAlpha(120),
                                          blurRadius: 60,
                                          spreadRadius: 15,
                                        ),
                                      ],
                                    ),
                                    child: Image.asset(
                                      page.image, 
                                      height: isWeb ? 350 : 250,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 40),
                            Text(
                              page.title,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.pressStart2p(
                                color: page.textColor,
                                fontSize: isWeb ? 28 : 22,
                                height: 1.5,
                                shadows: [
                                  Shadow(color: page.textColor.withAlpha(150), blurRadius: 10),
                                ],
                              ),
                            ),
                            const SizedBox(height: 25),
                            Text(
                              page.subtitle,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: page.textColor.withAlpha(230),
                                fontSize: isWeb ? 18 : 16,
                                fontWeight: FontWeight.w600,
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(height: 40),

                            if (index == 1)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 40),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _entryBtn(context, "START ORDERING", () => Navigator.pushReplacementNamed(context, '/home'), Colors.white, const Color(0xFFB8A2D6), shadow: true),
                                  ],
                                ),
                              ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _animatedPixel({required double top, double? left, double? right, double? bottom, required double size, required Color color, required double offset}) {
    return Positioned(
      top: top, left: left, right: right, bottom: bottom,
      child: AnimatedBuilder(
        animation: _floatController,
        builder: (context, child) {
          return Transform.rotate(
            angle: _floatController.value * offset,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(size * 0.2),
                boxShadow: [BoxShadow(color: color.withAlpha(100), blurRadius: 10)],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _entryBtn(BuildContext context, String txt, VoidCallback onPressed, Color bg, Color tColor, {bool border = false, bool shadow = false}) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          elevation: shadow ? 12 : 0,
          shadowColor: tColor.withAlpha(150),
          side: border ? const BorderSide(color: Colors.white, width: 2.5) : BorderSide.none,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        onPressed: onPressed,
        child: Text(txt, style: GoogleFonts.pressStart2p(color: tColor, fontSize: 11)),
      ),
    );
  }
}

class _PageData {
  final String title, subtitle, image;
  final Color bgColor, textColor;
  _PageData({required this.title, required this.subtitle, required this.image, required this.bgColor, required this.textColor});
}
