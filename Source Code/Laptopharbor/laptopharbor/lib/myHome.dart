// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:laptopharbor/Screens/Alllaptops.dart';
import 'package:laptopharbor/Screens/Category.dart';
import 'package:laptopharbor/Screens/Deal.dart';
import 'package:laptopharbor/Screens/Feedback.dart';
import 'package:laptopharbor/Screens/Herobanner.dart';
import 'package:laptopharbor/Screens/MyAppbar.dart';
import 'package:laptopharbor/Screens/Services.dart';
import 'package:laptopharbor/Screens/TrendingProd.dart';
import 'package:laptopharbor/Widgets/Carousel.dart';
import 'package:laptopharbor/Widgets/Drawer.dart';

class MyHome extends StatefulWidget {
  MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> wishList = [];
  List<Map<String, dynamic>> cart = [];
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  double _scrollPosition = 0;

  bool isLoading = true;
  String? errorMessage;
  List<Map<String, dynamic>> products = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController.addListener(() {
      setState(() {
        _scrollPosition = _scrollController.offset;
      });
    });
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
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildAnimatedSection({
    required Widget child,
    required double startOffset,
    required double endOffset,
  }) {
    bool isVisible =
        _scrollPosition >= startOffset && _scrollPosition <= endOffset;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 900),
      opacity: isVisible ? 1.0 : 0.0,
      child: Transform.translate(
        offset: Offset(0, isVisible ? 0 : 50),
        child: child,
      ),
    );
  }

  Widget _buildTrendingProductsSection() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (errorMessage != null) {
      return Center(
        child: Text(
          errorMessage!,
          style: GoogleFonts.poppins(color: Colors.red),
        ),
      );
    } else if (products.isEmpty) {
      return Center(
        child: Text(
          'No products available.',
          style: GoogleFonts.poppins(),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 0.75,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Card(
              elevation: 3.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: product['trendproductImage'] != null
                          ? Image.network(
                              product['trendproductImage'],
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.contain,
                            )
                          : Container(
                              color: Colors.grey,
                              child: const Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            product['trendproductName'] ?? 'Unknown',
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
                        Center(
                          child: Text(
                            'Brand: ${product['trendproductCategory'] ?? 'Unknown'}',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 40, 102, 42)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyCustomAppBar(
        cartItemCount: cart.length,
        wishlistItems: wishList,
        cartItems: cart,
      ),
      drawer: MyDrawer(wishList: wishList),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.green[400],
              indicatorWeight: 10.0,
              indicatorPadding: const EdgeInsets.symmetric(horizontal: 10.0),
              labelStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
              unselectedLabelStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.normal,
                fontSize: 14.0,
              ),
              tabs: [
                Tab(
                  icon: FaIcon(FontAwesomeIcons.house, size: 18),
                  child: Text(
                    "Home",
                    style: GoogleFonts.poppins(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
                Tab(
                  icon: FaIcon(FontAwesomeIcons.list, size: 18),
                  child: Text(
                    "Category",
                    style: GoogleFonts.poppins(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
                Tab(
                  icon: FaIcon(FontAwesomeIcons.star, size: 18),
                  child: Text(
                    "Laptops",
                    style: GoogleFonts.poppins(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HeroBanner(),
                      const SizedBox(height: 20),
                      const MyCarousel(
                        carouselImages: [
                          "assets/images/apple.jpg",
                          "assets/images/hp.jpg",
                          "assets/images/acer2.jpg",
                          "assets/images/asus.jpg",
                        ],
                      ),
                      Center(
                        child: Text(
                          "Trending Products",
                          style: GoogleFonts.poppins(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      _buildTrendingProductsSection(),
                      const SizedBox(height: 40),
                      const Divider(color: Colors.black, thickness: 1),
                      const SizedBox(height: 40),
                      DealsPage(),
                      const SizedBox(height: 40),
                      const Divider(color: Colors.black, thickness: 1),
                      const SizedBox(height: 40),
                      ServicesPage(),
                      const SizedBox(height: 40),
                      const Divider(color: Colors.black, thickness: 1),
                      FeedbackPage(),
                      const SizedBox(height: 40),
                      Container(
                        color: Colors.black,
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: Text(
                            "© 2024 Laptop Harbor - All Rights Reserved",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Center(child: CategoryPage()),
                Center(child: AllLaptopsPage()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
