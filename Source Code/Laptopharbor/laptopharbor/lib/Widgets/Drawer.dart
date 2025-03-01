// ignore_for_file: unused_import, must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laptopharbor/Authentication/Login.dart';
import 'package:laptopharbor/Screens/CartServices.dart';
import 'package:laptopharbor/Screens/ProfileSetting.dart';
import 'package:laptopharbor/Screens/Trackorder.dart';
import 'package:laptopharbor/Screens/Wishlist.dart';

class MyDrawer extends StatelessWidget {
  final List<Map<String, dynamic>> wishList;
  


  MyDrawer({super.key, required this.wishList});
  List<Map<String, dynamic>> cartItems = [];

  Widget buildListTile(String title, VoidCallback onTap, [IconData? icon]) 
  {
    return ListTile(
      onTap: onTap,
      leading: icon != null ? Icon(icon, color: Colors.black) : null,
      title: Row(
        children: [
          const SizedBox(width: 10),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: const Color.fromARGB(255, 0, 0, 0),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(50),
        bottomRight: Radius.circular(50),
      ),
      child: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 255, 255, 255),
                    Color.fromARGB(96, 0, 0, 0),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 8,
                          offset: Offset(2, 4),
                        )
                      ],
                    ),
                    child: const CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage("images/profile.jpeg"),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "User Name", // Replace with dynamic data
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  Text(
                    "User@gmail.com", // Replace with dynamic data
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ],
              ),
            ),
            // For Order, navigate to CartServices page
            buildListTile("Cart", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartServices(
                      cartItems: cartItems), // Pass the cart items here
                ),
              );
            }, Icons.shopping_cart),

            buildListTile(
              "Wish List",
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WishListScreen(
                      wishList: wishList,
                    ),
                  ),
                );
              },
              Icons.favorite,
            ),
            buildListTile("Track your Order", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TrackOrderPage(),
                ),
              );
            }, Icons.track_changes),
            const Divider(),
            buildListTile("Setting", () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ProfileSettingsPage()),
              );
            }, Icons.settings),
            buildListTile("Logout", () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            }, Icons.logout),
          ],
        ),
      ),
    );
  }
}
