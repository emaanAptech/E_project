// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:laptopharbor/Screens/MyAppbar.dart';

class ProductDetailsPage extends StatefulWidget {
  final String productId;
  const ProductDetailsPage({super.key, required this.productId});

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  DocumentSnapshot? productSnapshot;
  bool isLoading = true;
  String productImage = '';
  double productRating = 0.0;
  List<Map<String, dynamic>> wishList = [];
  List<Map<String, dynamic>> cart = [];
  String ratingMessage = '';  // State variable for rating message

  @override
  void initState() {
    super.initState();
    _fetchProductDetails();
  }

  Future<void> _fetchProductDetails() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.productId)
          .get();

      if (snapshot.exists) {
        setState(() {
          productSnapshot = snapshot;
          isLoading = false;
          productImage = snapshot['productImage'] ?? '';
          productRating = snapshot['productRating']?.toDouble() ?? 0.0;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print("Product not found");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching product details: $e");
    }
  }

  Future<void> _updateRating(double newRating) async {
    try {
      // Update rating in Firestore
      await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.productId)
          .update({'productRating': newRating});

      setState(() {
        productRating = newRating;
        ratingMessage = "Thank you for rating!"; // Update the message after rating
      });

      // Optionally, show a SnackBar for a temporary message
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text("Thank you for rating!"),
      //     duration: Duration(seconds: 2),
      //   ),
      // );
    } catch (e) {
      print("Error updating rating: $e");
    }
  }

  // Add product to wishlist
  void _addToWishlist() {
    setState(() {
      wishList.add({
        'productId': widget.productId,
        'productName': productSnapshot?['productName'],
        'productPrice': productSnapshot?['productPrice'],
        'productImage': productImage,
      });
    });
  }

  // Add product to cart
  void _addToCart() {
    setState(() {
      cart.add({
        'productId': widget.productId,
        'productName': productSnapshot?['productName'],
        'productPrice': productSnapshot?['productPrice'],
        'productImage': productImage,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyCustomAppBar(
        cartItemCount: cart.length,
        wishlistItems: wishList,
        cartItems: cart,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : productSnapshot != null
              ? SingleChildScrollView(
                  child: Card(
                    margin: EdgeInsets.all(16),
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    color: Colors.white, // Set background color to white
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          productImage.isNotEmpty
                              ? Container(
                                  height: 200,
                                  child: Image.network(
                                    productImage,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Container(
                                  height: 200,
                                  child:
                                      Center(child: Text('No image available'))),
                          SizedBox(height: 20),
                          Text(
                            productSnapshot?['productName'] ?? 'Product Name',
                            style: GoogleFonts.poppins(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal[800],
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '\$${productSnapshot?['productPrice'] ?? 0}',
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              color: Colors.amber,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            productSnapshot?['productDescription'] ??
                                'No description available',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 20),
                          // Product rating with interactivity
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ...List.generate(5, (index) {
                                return IconButton(
                                  icon: Icon(
                                    index < productRating
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.amber,
                                    size: 24,
                                  ),
                                  onPressed: () {
                                    _updateRating(index + 1.0); // Update rating when clicked
                                  },
                                );
                              }),
                              SizedBox(width: 8),
                              Text(
                                '($productRating)', // Dynamic rating
                                style: GoogleFonts.poppins(
                                    fontSize: 16, color: Colors.grey[700]),
                              ),
                            ],
                          ),
                          // Show the rating message below the stars
                          if (ratingMessage.isNotEmpty)
                            Text(
                              ratingMessage,
                              style: GoogleFonts.poppins(
                                  fontSize: 14, color: Colors.green[700]),
                            ),
                          SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                )
              : Center(
                  child: Text("Product not found",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold))),
    );
  }
}
