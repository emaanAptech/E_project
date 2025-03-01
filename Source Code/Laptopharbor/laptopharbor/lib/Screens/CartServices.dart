// ignore_for_file: sort_child_properties_last, unused_local_variable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:laptopharbor/Screens/PaymentMethod.dart';

class CartServices extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  const CartServices({super.key, required this.cartItems});

  @override
  _CartServicesState createState() => _CartServicesState();
}

class _CartServicesState extends State<CartServices> {
  @override
  Widget build(BuildContext context) {
    double totalPrice = 0.0;
    int totalQuantity = 0;

    // Calculate the total price and quantity
    for (var item in widget.cartItems) {
      final priceString = item['productPrice'] ?? '';
      double price = 0.0;
      try {
        price = double.parse(priceString.replaceAll(',', ''));
      } catch (e) {
        print("Error parsing price: $priceString");
      }
      final quantity = item['quantity'] ?? 1;
      totalPrice += price * quantity;
      totalQuantity = quantity;
    }

    // Shipping fee
    double shippingFee = 200;

    // Format the total price and shipping fee
    final numberFormat = NumberFormat('#,##0.00', 'en_US');
    final formattedTotalAmount = numberFormat.format(totalPrice + shippingFee);
    final formattedShipping = numberFormat.format(shippingFee);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Cart",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        centerTitle: true,
      ),
      body: widget.cartItems.isEmpty
          ? Center(
              child: Text(
                "Your cart is empty",
                style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = widget.cartItems[index];
                      final productName = item['productName'] ?? 'No Name';
                      final priceString = item['productPrice'] ?? '0.0';
                      double productPrice = 0.0;
                      try {
                        productPrice =
                            double.parse(priceString.replaceAll(',', ''));
                      } catch (e) {
                        print("Error parsing price: $priceString");
                      }
                      final quantity = item['quantity'] ?? 1;
                      final totalItemPrice = productPrice * quantity;

                      final productImage = item['productImage'] ?? 'https://via.placeholder.com/100';

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16),
                          leading: Image.network(
                            productImage,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                          title: Text(
                            productName,
                            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove, size: 20),
                                    onPressed: () {
                                      setState(() {
                                        if (item['quantity'] > 1) {
                                          item['quantity']--;
                                        }
                                      });
                                    },
                                  ),
                                  Text('$quantity', style: GoogleFonts.poppins(fontSize: 18)),
                                  IconButton(
                                    icon: Icon(Icons.add, size: 20),
                                    onPressed: () {
                                      setState(() {
                                        item['quantity']++;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: Text(
                            "\PKR${numberFormat.format(totalItemPrice)}",
                            style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Divider(thickness: 1, color: Colors.grey),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Shipping Fee",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        "\PKR$formattedShipping",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                // Divider(thickness: 1, color: Colors.grey),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Price",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "\PKR$formattedTotalAmount",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentMethod(
                            totalAmount: totalPrice + shippingFee,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "Proceed to Payment",
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 18.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      backgroundColor: Colors.green,
                      minimumSize: Size(double.infinity, 20),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
