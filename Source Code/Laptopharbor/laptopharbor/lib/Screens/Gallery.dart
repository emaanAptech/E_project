import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyGallery extends StatelessWidget {
  const MyGallery({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3), // Shadow color
                    blurRadius: 8, // Spread of the shadow
                    offset: Offset(0, 4), // Position of the shadow
                  ),
                ],
              ),
              width: 200,
              height: 280,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10), // Clip children to border radius
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    // Background image
                    Image.network(
                      "https://images.unsplash.com/photo-1658312226966-29bd4e77c62c?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mzh8fHZlcnRpY2FsJTIwaW1hZ2VzJTIwbGFwdG9wc3xlbnwwfHwwfHx8MA%3D%3D",
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    // Overlay
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.black.withOpacity(0.5),
                    ),
                    // Text overlay
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Apple Laptops",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 22,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
    
  }
}
