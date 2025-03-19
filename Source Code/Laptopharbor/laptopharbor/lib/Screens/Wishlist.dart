// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WishListScreen extends StatefulWidget {
  List<Map<String, dynamic>> wishList;

  WishListScreen({required this.wishList, super.key});

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  void onDeleteItem(int index) {
    setState(() {
      widget.wishList.removeAt(index); // Remove the item from the list
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Item removed from wishlist!',
          style: GoogleFonts.poppins(),
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.white,
  //     appBar: AppBar(
  //       backgroundColor: Colors.white,
  //       elevation: 0,
  //       title: Text(
  //         'Wish List',
  //         style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 22),
  //       ),
  //       centerTitle: true,
  //     ),
  //     body: widget.wishList.isEmpty
  //         ? Center(
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Icon(Icons.favorite_border, size: 50, color: Colors.grey),
  //                 SizedBox(height: 10),
  //                 Text(
  //                   "Your wish list is empty!",
  //                   style: GoogleFonts.poppins(
  //                     fontSize: 18,
  //                     color: Colors.grey,
  //                     fontWeight: FontWeight.w500,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           )
  //         : ListView.builder(
  //             itemCount: widget.wishList.length,
  //             itemBuilder: (context, index) {
  //               return Card(
  //                 elevation: 5,
  //                 margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(15),
  //                 ),
  //                 child: ListTile(
  //                   contentPadding: EdgeInsets.all(10),
  //                   leading: ClipRRect(
  //                     borderRadius: BorderRadius.circular(10),
  //                     child: Image.network(
  //                       widget.wishList[index]['productImage'],
  //                       fit: BoxFit.cover,
  //                       width: 70,
  //                       height: 70,
  //                       errorBuilder: (context, error, stackTrace) {
  //                         return Icon(Icons.broken_image, size: 30);
  //                       },
  //                     ),
  //                   ),
  //                   title: Text(
  //                     widget.wishList[index]['productName'],
  //                     style: GoogleFonts.poppins(
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 16,
  //                     ),
  //                   ),
  //                   subtitle: Text(
  //                     "\$${widget.wishList[index]['productPrice']}",
  //                     style: GoogleFonts.poppins(
  //                       fontSize: 14,
  //                       color: Colors.green,
  //                       fontWeight: FontWeight.w500,
  //                     ),
  //                   ),
  //                   trailing: IconButton(
  //                     icon: Icon(Icons.delete_outline_rounded, color: Colors.red),
  //                     onPressed: () {
  //                       onDeleteItem(index);
  //                     },
  //                   ),
  //                 ),
  //               );
  //             },
  //           ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    print("Wishlist content: ${widget.wishList}"); // Debugging

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Wish List',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
      ),
      body: widget.wishList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 50, color: Colors.grey),
                  SizedBox(height: 10),
                  Text(
                    "Your wish list is empty!",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: widget.wishList.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(10),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        widget.wishList[index]['productImage'],
                        fit: BoxFit.cover,
                        width: 70,
                        height: 70,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.broken_image, size: 30);
                        },
                      ),
                    ),
                    title: Text(
                      widget.wishList[index]['productName'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      "\$${widget.wishList[index]['productPrice']}",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: IconButton(
                      icon:
                          Icon(Icons.delete_outline_rounded, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          widget.wishList.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
