import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  final List<Map<String, String>> cart;
  final List<Map<String, dynamic>> completedOrders;

  const ProfileScreen({
    super.key, 
    required this.cart, 
    this.completedOrders = const []
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Color softPink = const Color(0xFFFDE2E4);
  final Color primaryPurple = const Color(0xFFB8A2D6);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFB8A2D6), size: 22),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      Text(
                        "MY PROFILE",
                        style: GoogleFonts.pressStart2p(fontSize: 14, color: primaryPurple),
                      ),
                      const Spacer(),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        _buildProfileHeader(),
                        const SizedBox(height: 40),
                        _buildOrderHistory(),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(color: softPink, shape: BoxShape.circle),
              child: const Icon(Icons.person, size: 80, color: Colors.white),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(color: Color(0xFFB8A2D6), shape: BoxShape.circle),
                child: const Icon(Icons.edit, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text("Sweet Tooth Guest", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
        Text("guest@randombytes.com", style: GoogleFonts.poppins(fontSize: 14, color: Colors.black38)),
      ],
    );
  }

  Widget _buildOrderHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.history, color: Color(0xFFB8A2D6)),
            const SizedBox(width: 10),
            Text("Order History", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 15),
        if (widget.completedOrders.isEmpty)
          Container(
            padding: const EdgeInsets.all(40),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Icon(Icons.shopping_bag_outlined, size: 50, color: Colors.black12),
                const SizedBox(height: 10),
                Text("No orders placed yet.", style: GoogleFonts.poppins(color: Colors.black26)),
              ],
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.completedOrders.length,
            itemBuilder: (context, index) {
              final order = widget.completedOrders[index];
              return Card(
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: softPink.withOpacity(0.5)),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(15),
                  title: Text(order['items'] ?? "", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: Text("Order ID: #${order['id']} | ${order['date']}", style: GoogleFonts.poppins(fontSize: 12)),
                  trailing: Text(order['total'] ?? "", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: primaryPurple)),
                ),
              );
            },
          ),
      ],
    );
  }
}
