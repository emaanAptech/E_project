// ignore_for_file: unused_import, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laptopharbor/Screens/MyAppbar.dart';
import 'package:laptopharbor/Screens/ProdDesc.dart';
import 'package:laptopharbor/Screens/Sort.dart';
import 'package:laptopharbor/Screens/Wishlist.dart';

class ProdListing extends StatefulWidget {
  final String selectedCategory;
  final Function(dynamic product) onAddToWishList;
  final Function(dynamic product) onRemoveFromWishList;
  final Function(dynamic product) onAddToCart;

  const ProdListing({
    super.key,
    required this.selectedCategory,
    required this.onAddToWishList,
    required this.onRemoveFromWishList,
    required this.onAddToCart,
  });

  @override
  _ProdListingState createState() => _ProdListingState();
}

class _ProdListingState extends State<ProdListing> {
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> filteredProducts = [];
  List<Map<String, dynamic>> cartItems = [];
  Set<String> cartProductIds = {};
  Set<String> wishlistProductIds = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProductsByCategory(widget.selectedCategory);
  }

  // Fetch all products from Firestore
  Future<void> fetchProductsByCategory(String category) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('productCategory', isEqualTo: category)
          .get();

      setState(() {
        products = querySnapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'id': doc.id,
            'productName': data['productName'] ?? 'No Name',
            'productImage': data['productImage'] ?? '',
            'productPrice': data['productPrice'] ?? 0.0,
          };
        }).toList();
        filteredProducts = List.from(products);
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching products: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _addToCart(Map<String, dynamic> product) {
    final existingProductIndex = cartItems.indexWhere(
      (item) => item['id'] == product['id'],
    );

    setState(() {
      if (existingProductIndex != -1) {
        cartItems[existingProductIndex]['quantity'] += 1;
      } else {
        cartItems.add({...product, 'quantity': 1});
        cartProductIds.add(product['id']);
      }
    });

    _showSnackBar('Added to cart!');
  }

  void _removeFromCart(Map<String, dynamic> product) {
    setState(() {
      cartItems.removeWhere((item) => item['id'] == product['id']);
      cartProductIds.remove(product['id']);
    });
    _showSnackBar('Removed from cart!');
  }

  void _addToWishList(Map<String, dynamic> product) {
    setState(() {
      wishlistProductIds.add(product['id']);
    });

    if (widget.onAddToWishList != null) {
      widget.onAddToWishList(product);
    }

    _showSnackBar('Added to wishlist!');
  }

  void _removeFromWishList(Map<String, dynamic> product) {
    setState(() {
      wishlistProductIds.remove(product['id']);
    });

    if (widget.onRemoveFromWishList != null) {
      widget.onRemoveFromWishList(product);
    }

    _showSnackBar('Removed from wishlist!');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyCustomAppBar(
        cartItemCount: cartProductIds.length,
        wishlistItemCount: wishlistProductIds.length,
        wishlistItems: [],
        cartItems: cartItems,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price Range Filter
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.filter_list),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SortAndFilterPage()),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: filteredProducts.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.shopping_bag_outlined,
                                size: 80,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No items found. Start exploring!',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(15.0),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                            childAspectRatio: 0.7,
                          ),
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = filteredProducts[index];
                            final isInCart =
                                cartProductIds.contains(product['id']);
                            final isInWishList =
                                wishlistProductIds.contains(product['id']);

                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 6,
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
                                        height: 180,
                                        width: double.infinity,
                                        fit: BoxFit.fitHeight,
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 6.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              product['productName'] ??
                                                  'No Name',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Center(
                                          child: Text(
                                            "\PKR${product['productPrice'] ?? '0'}",
                                            style: GoogleFonts.poppins(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Wishlist Icon with solid background
                                        Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: isInWishList
                                                  ? Colors.grey[700]
                                                  : Colors.red,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                  blurRadius: 4,
                                                  spreadRadius: 1,
                                                  offset: Offset(0, 2),
                                                ),
                                              ]),
                                          child: IconButton(
                                            icon: const Icon(
                                              FontAwesomeIcons.heart,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              if (isInWishList) {
                                                _removeFromWishList(product);
                                              } else {
                                                _addToWishList(product);
                                              }
                                            },
                                          ),
                                        ),

                                        Center(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: isInCart
                                                  ? Colors.grey[800]
                                                  : Colors.green,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                  blurRadius: 4,
                                                  spreadRadius: 1,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                              child: IconButton(
                                                icon: const Icon(
                                                  FontAwesomeIcons.cartShopping,
                                                  color: Colors.white,
                                                  size: 21,
                                                ),
                                                onPressed: () {
                                                  if (isInCart) {
                                                    _removeFromCart(product);
                                                  } else {
                                                    _addToCart(product);
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                        ),

                                        Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.blue,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.2),
                                                blurRadius: 4,
                                                spreadRadius: 1,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: IconButton(
                                            icon: const Icon(
                                              FontAwesomeIcons.infoCircle,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProductDetailsPage(
                                                    productId: product['id'],
                                                  ),
                                                ),
                                              );
                                            },
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
