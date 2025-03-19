// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laptopharbor/Screens/MyAppbar.dart';

class AllLaptopsPage extends StatefulWidget {
  const AllLaptopsPage({super.key});

  @override
  _AllLaptopsPageState createState() => _AllLaptopsPageState();
}

class _AllLaptopsPageState extends State<AllLaptopsPage> {
  List<Map<String, dynamic>> products = [];
  bool isLoading = true;

  List<String> cartProductIds = [];
  List<String> wishlistProductIds = [];
  List<Map<String, dynamic>> cartItems = [];
  List<Map<String, dynamic>> wishlistItems = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('products').get();
      setState(() {
        products = querySnapshot.docs.map((doc) {
          final data = doc.data();

          print('Raw Data: $data'); // Debugging to check Firestore data

          return {
            'id': doc.id,
            'productName': data['productName'] ?? 'No Name',
            'productImage': data['productImage'] ?? '',
            'productPrice': _parsePrice(data['productPrice'] ?? '0.0'),
            'trendproductCategory': data.containsKey('trendproductCategory')
                ? (data['trendproductCategory'] is List
                    ? data['trendproductCategory'].join(', ')
                    : data['trendproductCategory'])
                : 'Gaming', // Default to Gaming if missing
          };
        }).toList();

        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching products: $error');
    }
  }

  // Helper function to parse price strings to double
  double _parsePrice(String price) {
    price = price.replaceAll(',', '');
    return double.tryParse(price) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Title for All Laptops
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'All Laptops',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Product Grid
                Expanded(
                  child: products.isEmpty
                      ? const Center(child: Text('No products found.'))
                      : GridView.builder(
                          padding: const EdgeInsets.all(16.0),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                          ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(16)),
                                    child: Container(
                                      color: Colors.white,
                                      child: Image.network(
                                        product['productImage'] ?? '',
                                        height: 130,
                                        width: double.infinity,
                                        fit: BoxFit.contain,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Icon(
                                            Icons.broken_image,
                                            size: 50,
                                            color: Color.fromARGB(255, 0, 0, 0),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: Text(
                                            product['productName'] ?? 'No Name',
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Center(
                                          child: Text(
                                            '\PKR${product['productPrice'] ?? 0}',
                                            style: GoogleFonts.poppins(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          ),
                                        ),
                                        Center(
                                          child: Text(
                                            'Brand: ${product['trendproductCategory'] ?? 'Unknown'}',
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                                color: const Color.fromARGB(
                                                    255, 49, 102, 50)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
