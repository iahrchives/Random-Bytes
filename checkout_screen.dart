import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:confetti/confetti.dart';
import 'dart:math';

class CheckoutScreen extends StatefulWidget {
  final List<Map<String, String>> cart;
  final List<Map<String, dynamic>> completedOrders;

  const CheckoutScreen({
    super.key,
    required this.cart,
    this.completedOrders = const [],
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _sendReceipt = false;

  ConfettiController? _confettiController;

  final List<String> allFlavors = [
    'Chocolate Chip Cookies',
    'Chocolate Chip Cookies with Almonds',
    'Double Chocolate Chip Cookies',
    'Double Chocolate Chip Cookies with Almonds',
    'White Chocolate Matcha',
    'White Chocolate Matcha with Almonds',
    'Brownies Choco Chips',
    'Brownies Choco Chips with Nuts',
    'Chocolate Donut',
    'Cinnamon Donut'
  ];

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _courseController.dispose();
    _emailController.dispose();
    _confettiController?.dispose();
    super.dispose();
  }

  List<String> _generateMysteryFlavors() {
    List<String> results = [];
    for (var item in widget.cart) {
      bool isNoNuts = item['name']!.toLowerCase().contains("no nuts");

      List<String> basePool = isNoNuts
          ? allFlavors.where((f) => !f.contains("Almonds") && !f.contains("Nuts")).toList()
          : List.from(allFlavors);

      List<String> weightedPool = [];
      for (String f in basePool) {
        weightedPool.add(f);
        if (f.contains("Matcha") || f.contains("Brownies")) {
          weightedPool.add(f); weightedPool.add(f);
        }
      }
      results.add((weightedPool..shuffle()).first);
    }
    return results;
  }

  void _showMysteryReveal(String customerName, List<String> pickedFlavors) {
    final List<String> pastryIcons = ["🍪", "🍩", "🍫"];
    int currentIconIndex = 0;
    Timer? iconTimer;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            iconTimer ??= Timer.periodic(const Duration(milliseconds: 500), (timer) {
              if (mounted) {
                setDialogState(() {
                  currentIconIndex = (currentIconIndex + 1) % pastryIcons.length;
                });
              }
              if (timer.tick >= 8) timer.cancel();
            });

            Future.delayed(const Duration(milliseconds: 4000), () {
              if (mounted && Navigator.canPop(context)) {
                Navigator.of(context, rootNavigator: true).pop();
                _showFinalResult(customerName, pickedFlavors);
              }
            });

            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: Text(pastryIcons[currentIconIndex], key: ValueKey(currentIconIndex), style: const TextStyle(fontSize: 70)),
                  ),
                  const SizedBox(height: 25),
                  Text("WHIPPING UP MAGIC...", style: GoogleFonts.pressStart2p(fontSize: 10, color: const Color(0xFFB8A2D6))),
                  const SizedBox(height: 20),
                  const LinearProgressIndicator(color: Color(0xFFB8A2D6), backgroundColor: Color(0xFFFDE2E4)),
                  const SizedBox(height: 15),
                  Text("Selecting surprises for $customerName...", textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                ],
              ),
            );
          },
        );
      },
    ).then((_) => iconTimer?.cancel());
  }

  void _showFinalResult(String name, List<String> flavors) {
    _confettiController?.play();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Stack(
        alignment: Alignment.topCenter,
        children: [
          AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            title: Text("✨ SURPRISE! ✨", textAlign: TextAlign.center, style: GoogleFonts.pressStart2p(fontSize: 14, color: const Color(0xFFB8A2D6))),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Thank you, $name!", style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 15),
                  Text("Your Mystery Flavors are:", style: GoogleFonts.poppins(fontSize: 13)),
                  const SizedBox(height: 10),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: flavors.length,
                      itemBuilder: (context, index) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDE2E4),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: const Color(0xFFB8A2D6).withOpacity(0.5)),
                        ),
                        child: Text(flavors[index], textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFFB8A2D6))),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _confettiController?.stop();
                      Navigator.of(context, rootNavigator: true).pop();
                      Navigator.pop(context);
                      widget.cart.clear();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB8A2D6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text("YUM! CLAIM ORDER", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              )
            ],
          ),
          IgnorePointer(
            child: ConfettiWidget(
              confettiController: _confettiController!,
              blastDirectionality: BlastDirectionality.explosive,
              colors: const [Colors.pink, Colors.purple, Colors.orange, Colors.white, Colors.yellow],
              createParticlePath: _drawStar,
            ),
          ),
        ],
      ),
    );
  }

  Path _drawStar(Size size) {
    double degToRad(double deg) => deg * (pi / 180.0);
    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final path = Path();
    path.moveTo(size.width, halfWidth);
    for (double step = 0; step < degToRad(360); step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step), halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + degreesPerStep / 2), halfWidth + internalRadius * sin(step + degreesPerStep / 2));
    }
    path.close();
    return path;
  }

  void _processOrder() {
    if (_formKey.currentState!.validate()) {
      List<String> picked = _generateMysteryFlavors();
      _showMysteryReveal(_nameController.text, picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color softPink = Color(0xFFFDE2E4);
    const Color primaryPurple = Color(0xFFB8A2D6);
    double total = 0;
    for (var item in widget.cart) {
      total += double.tryParse(item['price']!.replaceAll('₱', '').trim()) ?? 0;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: primaryPurple), onPressed: () => Navigator.pop(context)),
        title: Text("CHECKOUT", style: GoogleFonts.pressStart2p(fontSize: 14, color: primaryPurple)),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(25),
          children: [
            Text("Customer Information", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            _buildTextField(_nameController, "Full Name", Icons.person),
            const SizedBox(height: 12),
            _buildTextField(_courseController, "Course & Year", Icons.school),
            const SizedBox(height: 12),
            _buildTextField(_emailController, "Email Address", Icons.email, isEmail: true),
            SwitchListTile(activeColor: primaryPurple, title: Text("Send receipt to my email?", style: GoogleFonts.poppins(fontSize: 13)), value: _sendReceipt, onChanged: (v) => setState(() => _sendReceipt = v)),
            const Divider(height: 40),
            Text("Order Summary", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            ...widget.cart.asMap().entries.map((e) => _buildOrderItem(e.value['name']!, e.value['price']!, Icons.card_giftcard, softPink, primaryPurple, onDelete: () => setState(() => widget.cart.removeAt(e.key)))),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(30)),
              child: Column(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Total Price:", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)), Text("₱${total.toStringAsFixed(2)}", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: primaryPurple))]),
                  const SizedBox(height: 25),
                  SizedBox(width: double.infinity, height: 55, child: ElevatedButton(onPressed: widget.cart.isEmpty ? null : _processOrder, style: ElevatedButton.styleFrom(backgroundColor: primaryPurple, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))), child: Text("PLACE ORDER", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isEmail = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon, color: const Color(0xFFB8A2D6)), filled: true, fillColor: const Color(0xFFFDE2E4).withOpacity(0.2), border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none)),
      validator: (val) => (val == null || val.isEmpty) ? "Required" : (isEmail && !val.contains("@") ? "Invalid email" : null),
    );
  }

  Widget _buildOrderItem(String title, String price, IconData icon, Color pink, Color purple, {required VoidCallback onDelete}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: pink.withOpacity(0.5))),
      child: Row(children: [
        Container(width: 50, height: 50, decoration: BoxDecoration(color: pink.withOpacity(0.3), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: purple, size: 22)),
        const SizedBox(width: 15),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)), Text(price, style: TextStyle(fontWeight: FontWeight.bold, color: purple, fontSize: 13))])),
        IconButton(icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20), onPressed: onDelete),
      ]),
    );
  }
}