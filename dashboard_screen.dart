import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'profile_screen.dart' as profile;
import 'item_list_screen.dart';
import 'checkout_screen.dart' as checkout;

const Color softPink = Color(0xFFFDE2E4);
const Color backgroundGray = Color(0xFFF8F9FA);
const Color primaryPurple = Color(0xFFB8A2D6);
const Color cardPink = Color(0xFFFDE2E4);

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Map<String, String>> cart = [];
  final List<Map<String, dynamic>> completedOrders = [];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWeb = size.width > 600;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: backgroundGray,
      drawer: _buildDrawer(),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(15, isWeb ? 40 : 60, 25, 40),
                decoration: const BoxDecoration(
                  color: softPink,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.menu, color: primaryPurple, size: 30),
                          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                        ),
                        GestureDetector(
                          onLongPress: () {
                            Navigator.pushNamed(context, '/admin');
                          },
                          child: Text(
                            "RANDOM BYTES",
                            style: GoogleFonts.pressStart2p(fontSize: isWeb ? 18 : 14, color: primaryPurple),
                          ),
                        ),
                        _buildHeaderActions(),
                      ],
                    ),
                    const SizedBox(height: 35),
                    _buildHeaderText(isWeb),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  children: [
                    _sectionHeader("Dessert Blind Box (Available Now)"),
                    const SizedBox(height: 20),
                    _buildProductList([
                      {"title": "Blind Box - Regular", "price": "₱55", "icon": Icons.inventory_2},
                      {"title": "Blind Box - No Nuts", "price": "₱55", "icon": Icons.card_giftcard},
                    ], isClickable: true),
                    
                    const SizedBox(height: 35),
                    _sectionHeader("Our Menu"),
                    const SizedBox(height: 20),
                    _buildProductList([
                      {"title": "Cookies - Matcha", "price": "₱55", "icon": Icons.cookie},
                      {"title": "Cookies - Chocolate Chip", "price": "₱55", "icon": Icons.cookie_outlined},
                      {"title": "Cookies - Double Chocolate Chip", "price": "₱55", "icon": Icons.cookie_rounded},
                      {"title": "Brownies", "price": "₱55", "icon": Icons.square_rounded},
                      {"title": "Mini Donuts - Chocolate", "price": "₱55", "icon": Icons.donut_small},
                      {"title": "Mini Donuts - Cinnamon", "price": "₱55", "icon": Icons.donut_small_outlined},
                    ], isClickable: false),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductList(List<Map<String, dynamic>> products, {required bool isClickable}) {
    return SizedBox(
      height: 230,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 25),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final p = products[index];
          return _ProductCard(
            p['title'], 
            p['price'], 
            p['icon'], 
            cart: cart, 
            completedOrders: completedOrders,
            isClickable: isClickable,
          );
        },
      ),
    );
  }

  Widget _buildHeaderText(bool isWeb) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Sweet Surprises,\nOne Byte at a time.",
            style: GoogleFonts.poppins(
              fontSize: isWeb ? 42 : 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.1,
              shadows: [const Shadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))],
            ),
          ),
          const SizedBox(height: 15),
          Text(
            "Explore our daily Blind Box surprises and browse our full menu gallery!",
            style: GoogleFonts.poppins(fontSize: isWeb ? 14 : 11, color: Colors.black54, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderActions() {
    return Row(
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: const Icon(Icons.shopping_cart_outlined, color: primaryPurple),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => checkout.CheckoutScreen(
                  cart: cart, 
                  completedOrders: completedOrders,
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 15),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => profile.ProfileScreen(
                  cart: cart,
                  completedOrders: completedOrders,
                ),
              ),
            );
          },
          child: const CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 20, color: primaryPurple),
          ),
        )
      ],
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: softPink),
            child: Center(
              child: Text("RANDOM\nBYTES",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.pressStart2p(fontSize: 18, color: primaryPurple)),
            ),
          ),
          _drawerTile(Icons.home_outlined, "Home", () => Navigator.pop(context)),
          _drawerTile(Icons.shopping_cart_outlined, "My Cart", () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => checkout.CheckoutScreen(
                  cart: cart, 
                  completedOrders: completedOrders,
                ),
              ),
            );
          }),
          const Spacer(),
          const Divider(),
          _drawerTile(Icons.exit_to_app, "Exit App", () {
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          }, color: Colors.redAccent),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _drawerTile(IconData icon, String title, VoidCallback onTap, {Color color = primaryPurple}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
      onTap: onTap,
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final String title;
  final String price;
  final IconData icon;
  final List<Map<String, String>> cart;
  final List<Map<String, dynamic>> completedOrders;
  final bool isClickable;

  const _ProductCard(
    this.title, 
    this.price, 
    this.icon, {
    required this.cart,
    required this.completedOrders,
    this.isClickable = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        elevation: isClickable ? 2 : 1,
        shadowColor: Colors.black12,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: isClickable ? () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ItemListScreen(
                  title: title,
                  price: price,
                  cart: cart,
                  completedOrders: completedOrders,
                ),
              ),
            );
          } : null,
          child: Container(
            width: 170,
            padding: const EdgeInsets.all(15),
            child: Opacity(
              opacity: isClickable ? 1.0 : 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: cardPink.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Icon(icon, size: 60, color: primaryPurple),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    isClickable ? "Available for Order" : "Viewing Gallery",
                    style: const TextStyle(fontSize: 10, color: Colors.black38),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isClickable ? primaryPurple : Colors.grey[400],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isClickable ? Icons.shopping_cart : Icons.visibility_outlined, 
                          size: 14, 
                          color: Colors.white
                        ),
                      ),
                      Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
