import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laptopharbor/Screens/ProdList.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  Future<List<Map<String, dynamic>>> fetchCategories() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('categories').get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching categories'));
          }
          final categories = snapshot.data ?? [];
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 3 / 4,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return ProductCard(
                  name: category['categoryName'] ?? 'No Name',
                  image: category['categoryImage'] ?? '',
                  details: category['categoryDescription'] ?? 'No Description',
                  onSeeMore: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProdListing(
                          selectedCategory:
                              category['categoryName'] ?? 'Unknown Category',
                          onAddToCart: (product) {},
                          onAddToWishList: (product) {},
                          onRemoveFromWishList: (product) {},
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String name;
  final String image;
  final String details;
  final VoidCallback onSeeMore;

  const ProductCard({
    required this.name,
    required this.image,
    required this.details,
    required this.onSeeMore,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                image,
                height: 150,
                width: double.infinity,
                fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Text(
              name,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              details,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[700],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: ElevatedButton(
              onPressed: onSeeMore,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'See More',
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
