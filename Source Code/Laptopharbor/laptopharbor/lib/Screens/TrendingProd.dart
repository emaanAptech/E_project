// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewProducts extends StatefulWidget {
  @override
  _ViewProductsState createState() => _ViewProductsState();
}

class _ViewProductsState extends State<ViewProducts> {
  bool isLoading = true;
  String? errorMessage;
  List<Map<String, dynamic>> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      setState(() {
        isLoading = true;
      });
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('Trendprod').get();
      final List<Map<String, dynamic>> fetchedProducts =
          snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          ...data,
        };
      }).toList();
      setState(() {
        products = fetchedProducts;
        errorMessage = null;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load products.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Text(errorMessage!,
                      style: GoogleFonts.poppins(color: Colors.red)))
              : products.isEmpty
                  ? const Center(child: Text('No products available.'))
                  : GridView.builder(
                      padding: const EdgeInsets.all(15.0),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        String? selectedDetail;
    
                        return Card(
                          elevation: 3.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  color: Colors
                                      .white, // Adds a white background behind the image
                                  child: product['trendproductImage'] != null
                                      ? Image.network(
                                          product['trendproductImage'],
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit
                                              .contain, // Adjusts the image aspect ratio
                                        )
                                      : Container(
                                          color: Colors
                                              .grey, // Fallback color when no image is available
                                          child: const Center(
                                            child: Icon(
                                                Icons.image_not_supported,
                                                size: 40,
                                                color: Colors.white),
                                          ),
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
                                        product['trendproductName'] ??
                                            'Unknown',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(height: 4.0),
                                    Center(
                                      child: Text(
                                        '\$${product['trendproductPrice'] ?? 'N/A'}',
                                        style: GoogleFonts.poppins(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 4.0),
                                    // Text(
                                    //   'Trending: ${product['isTrending'] == true ? 'Yes' : 'No'}',
                                    //   style: GoogleFonts.poppins(
                                    //       fontStyle: FontStyle.italic),
                                    // ),
                                    SizedBox(height: 4.0),
                                    Center(
                                      child: Text(
                                        'Brand: ${product['trendproductCategory'] ?? 'Unknown'}',
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            color: const Color.fromARGB(255, 49, 102, 50)),
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
    );
  }
}
