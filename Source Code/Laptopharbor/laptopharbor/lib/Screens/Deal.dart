import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DealsPage extends StatelessWidget {
  const DealsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "Deals & Discounts",
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 30),
          // Deals Grid
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15.0,
              mainAxisSpacing: 15.0,
              childAspectRatio: 1.2,
            ),
            itemCount: deals.length, // Number of deals
            itemBuilder: (context, index) {
              return DealCard(deal: deals[index]);
            },
          ),
        ],
      ),
    );
  }
}

class DealCard extends StatelessWidget {
  final Deal deal;

  const DealCard({required this.deal, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Action when tapping on the deal
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DealDetailPage(deal: deal)),
        );
      },
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        shadowColor: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.7),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                deal.imagePath,
                fit: BoxFit.cover,
              ),
              Container(
                color: Colors.black.withOpacity(0.4),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      deal.name,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "Rs${deal.discountedPrice}",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Rs${deal.originalPrice}",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.white,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                    if (deal.isFlashSale)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          "Flash Sale",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Deal {
  final String name;
  final String imagePath;
  final double originalPrice;
  final double discountedPrice;
  final bool isFlashSale;

  Deal({
    required this.name,
    required this.imagePath,
    required this.originalPrice,
    required this.discountedPrice,
    this.isFlashSale = false,
  });
}

final List<Deal> deals = [
  Deal(
    name: 'Apple MacBook Pro',
    imagePath: 'images/apple.jpg',
    originalPrice: 1200.0,
    discountedPrice: 999.0,
    isFlashSale: true,
  ),
  Deal(
    name: 'HP Pavilion 15',
    imagePath: 'images/hp.jpg',
    originalPrice: 800.0,
    discountedPrice: 650.0,
  ),
  Deal(
    name: 'Acer Swift 3',
    imagePath: 'images/acer2.jpg',
    originalPrice: 600.0,
    discountedPrice: 450.0,
  ),
  Deal(
    name: 'Asus ZenBook',
    imagePath: 'images/asus.jpg',
    originalPrice: 900.0,
    discountedPrice: 799.0,
  ),
];

// Example DealDetailPage where more information can be shown
class DealDetailPage extends StatelessWidget {
  final Deal deal;

  const DealDetailPage({required this.deal, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(deal.name, 
        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(deal.imagePath,),
            SizedBox(height: 20),
            Text(
              deal.name,
              style: GoogleFonts.poppins(
                  fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Original Price: ₹${deal.originalPrice}",
              style: GoogleFonts.poppins(
                  fontSize: 18, decoration: TextDecoration.lineThrough),
            ),
            SizedBox(height: 10),
            Text(
              "Discounted Price: ₹${deal.discountedPrice}",
              style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange),
            ),
            if (deal.isFlashSale)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "Hurry! Limited Time Offer!",
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
              ),
              SizedBox(height: 8,),
            ElevatedButton(
              onPressed: () {
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
              ),
              child: Text(
                "Buy Now",
                style: GoogleFonts.poppins(
                  fontSize: 18, // Font size of the text
                  fontWeight: FontWeight.bold,
                  color: Colors.white // Text weight
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
