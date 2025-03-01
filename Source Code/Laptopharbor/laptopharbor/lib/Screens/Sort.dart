import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laptopharbor/Screens/MyAppbar.dart'; // Assuming this is the correct path

class SortAndFilterPage extends StatefulWidget {
  const SortAndFilterPage({super.key});

  @override
  _SortAndFilterPageState createState() => _SortAndFilterPageState();
}

class _SortAndFilterPageState extends State<SortAndFilterPage> {
  double minPrice = 0.0;
  double maxPrice = 2000000.0;
  double productMinPrice = 0.0;
  double productMaxPrice = 2000000.0;
  String selectedSort = 'Price Low to High';
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> filteredProducts = [];
  bool isLoading = true;

  // Mock data for cart and wishlist. Replace these with actual logic to fetch from Firestore or your app state.
  List<String> cartProductIds = [];
  List<String> wishlistProductIds = [];
  List<Map<String, dynamic>> cartItems = [];
  List<Map<String, dynamic>> wishlistItems = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  // Fetching products from Firestore
  Future<void> fetchProducts() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .get();
      setState(() {
        products = querySnapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'id': doc.id,
            'productName': data['productName'] ?? 'No Name',
            'productImage': data['productImage'] ?? '',
            'productPrice': _parsePrice(data['productPrice'] ?? '0.0'),
          };
        }).toList();

        // Calculate the minimum and maximum product price
        if (products.isNotEmpty) {
          productMinPrice = products
              .map((product) => product['productPrice'] ?? 0.0)
              .reduce((a, b) => a < b ? a : b); // Find the lowest price
          productMaxPrice = products
              .map((product) => product['productPrice'] ?? 0.0)
              .reduce((a, b) => a > b ? a : b); // Find the highest price

          // Update the filter range values
          minPrice = productMinPrice;
          maxPrice = productMaxPrice;
        }

        filteredProducts = List.from(products);
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
    price = price.replaceAll(',', ''); // Remove any commas
    return double.tryParse(price) ?? 0.0; // Parse and return the price as double
  }

  // Apply Filters and Sorting
  void _applyFiltersAndSorting() {
    setState(() {
      // Filter by price range
      filteredProducts = products.where((product) {
        double price = product['productPrice'] ?? 0.0;
        return price >= minPrice && price <= maxPrice;
      }).toList();

      // Sort products based on selected option
      if (selectedSort == 'Price Low to High') {
        filteredProducts.sort((a, b) =>
            (a['productPrice'] ?? 0).compareTo(b['productPrice'] ?? 0));
      } else if (selectedSort == 'Price High to Low') {
        filteredProducts.sort((a, b) =>
            (b['productPrice'] ?? 0).compareTo(a['productPrice'] ?? 0));
      } else if (selectedSort == 'Name A to Z') {
        filteredProducts.sort((a, b) =>
            (a['productName'] ?? '').compareTo(b['productName'] ?? ''));
      } else if (selectedSort == 'Name Z to A') {
        filteredProducts.sort((a, b) =>
            (b['productName'] ?? '').compareTo(a['productName'] ?? ''));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyCustomAppBar(
        cartItemCount: cartProductIds.length,
        wishlistItemCount: wishlistProductIds.length,
        wishlistItems: wishlistItems,
        cartItems: cartItems,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Filter and Sort Section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Price Range Filter
                      Center(
                        child: Text(
                          'Price Range: \PKR${minPrice.toStringAsFixed(0)} - \PKR${maxPrice.toStringAsFixed(0)}',
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                      ),
                      RangeSlider(
                        values: RangeValues(minPrice, maxPrice),
                        min: productMinPrice,
                        max: productMaxPrice,
                        divisions: 100,
                        labels: RangeLabels(
                          minPrice.toStringAsFixed(0),
                          maxPrice.toStringAsFixed(0),
                        ),
                        onChanged: (values) {
                          setState(() {
                            minPrice = values.start;
                            maxPrice = values.end;
                          });
                          _applyFiltersAndSorting();
                        },
                      ),
                      const SizedBox(height: 16),
                      // Sort Dropdown
                      Text('Sort By:', style: GoogleFonts.poppins(fontSize: 14)),
                      DropdownButton<String>(
                        value: selectedSort,
                        onChanged: (value) {
                          setState(() {
                            selectedSort = value!;
                          });
                          _applyFiltersAndSorting();
                        },
                        items: [
                          'Price Low to High',
                          'Price High to Low',
                          'Name A to Z',
                          'Name Z to A',
                        ]
                            .map((sortOption) => DropdownMenuItem<String>(
                                  value: sortOption,
                                  child: Text(
                                    sortOption,
                                    style: GoogleFonts.poppins(fontSize: 16),
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
                // Product Grid
                Expanded(
                  child: filteredProducts.isEmpty
                      ? const Center(child: Text('No products found.'))
                      : GridView.builder(
                          padding: const EdgeInsets.all(16.0),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                          ),
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = filteredProducts[index];
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
                                        height: 150,
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
