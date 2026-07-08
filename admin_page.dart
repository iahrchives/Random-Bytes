import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final List<Map<String, dynamic>> _orders = [
    {
      'id': '1001',
      'customer': 'Banana',
      'email': 'banana@email.com',
      'course': 'BA MMA - 3rd Year',
      'items': 'Blind Box - Regular (x1)',
      'total': '₱55.00',
      'status': 'Pending'
    },
    {
      'id': '1002',
      'customer': 'Oiiaioiiiai',
      'email': 'oiiaioiiiai@email.com',
      'course': 'BS IS - 2nd Year',
      'items': 'Choco Cookies (x2)',
      'total': '₱110.00',
      'status': 'Pending'
    },
    {
      'id': '1003',
      'customer': 'Wawawawa',
      'email': 'wawawawa@email.com',
      'course': 'BS CS - 3rd Year',
      'items': 'Premium Cakes (x1)',
      'total': '₱155.00',
      'status': 'Completed'
    },
  ];

  void _markAsCompleted(int index) {
    setState(() {
      _orders[index]['status'] = 'Completed';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Order #${_orders[index]['id']} updated to Completed"),
        backgroundColor: const Color(0xFFB8A2D6),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryPurple = Color(0xFFB8A2D6);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text("Admin Dashboard", style: GoogleFonts.pressStart2p(fontSize: 12, color: Colors.white)),
        backgroundColor: primaryPurple,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Customer Orders", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.download, size: 18),
                      label: const Text("Export CSV"),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: primaryPurple),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: MaterialStateProperty.all(const Color(0xFFFDE2E4).withOpacity(0.3)),
                      columns: [
                        DataColumn(label: Text('ID', style: GoogleFonts.poppins(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Customer', style: GoogleFonts.poppins(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Email / Course', style: GoogleFonts.poppins(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Items Purchased', style: GoogleFonts.poppins(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Total', style: GoogleFonts.poppins(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Status', style: GoogleFonts.poppins(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Action', style: GoogleFonts.poppins(fontWeight: FontWeight.bold))),
                      ],
                      rows: _orders.asMap().entries.map((entry) {
                        int idx = entry.key;
                        var order = entry.value;
                        bool isCompleted = order['status'] == 'Completed';

                        return DataRow(cells: [
                          DataCell(Text("#${order['id']}")),
                          DataCell(Text(order['customer'])),
                          DataCell(Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(order['email'] ?? "", style: const TextStyle(fontSize: 12)),
                              Text(order['course'] ?? "", style: const TextStyle(fontSize: 11, color: Colors.grey)),
                            ],
                          )),
                          DataCell(Text(order['items'] ?? "")),
                          DataCell(Text(order['total'] ?? "")),
                          DataCell(Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isCompleted ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              order['status'],
                              style: TextStyle(color: isCompleted ? Colors.green : Colors.orange, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          )),
                          DataCell(
                            isCompleted 
                            ? const Icon(Icons.check_circle, color: Colors.green, size: 20)
                            : IconButton(
                                icon: const Icon(Icons.check, color: primaryPurple),
                                onPressed: () => _markAsCompleted(idx),
                              ),
                          ),
                        ]);
                      }).toList(),
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
}
