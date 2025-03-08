// ignore_for_file: unused_import, unused_field, prefer_final_fields, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laptopharbor/Screens/Orderform.dart';
import 'package:intl/intl.dart';

class PaymentMethod extends StatefulWidget {
  final double totalAmount;
  final double shippingFee;

  PaymentMethod({
    super.key,
    required this.totalAmount,
    this.shippingFee = 200.0, // Default shipping fee
  });

  @override
  _PaymentMethodState createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  String _selectedPaymentMethod = 'Select Method';
  double totalAmount = 0.0;
  bool _isOrderPlaced = false;

  // Add controllers for customer details
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _customerEmailController =
      TextEditingController();
  final TextEditingController _customerPhoneController =
      TextEditingController();
  final TextEditingController _shippingAddressController =
      TextEditingController();

  // Define form key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    totalAmount = CartServices.getTotalAmount();
  }

  void _onPlaceOrder() async {
    if (_selectedPaymentMethod == 'Select Method' ||
        _selectedPaymentMethod.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please select a valid payment method!",
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.green,
        ),
      );
      return;
    }

    // Ensure all required customer details are provided
    if (_customerNameController.text.isEmpty ||
        _customerEmailController.text.isEmpty ||
        _customerPhoneController.text.isEmpty ||
        _shippingAddressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all customer details!")),
      );
      return;
    }

    try {
      // Calculate total amount with shipping fee
      double totalAmountWithShipping = widget.totalAmount;

      // Save order details to Firestore
      await FirebaseFirestore.instance.collection('orders').add({
        'customerName': _customerNameController.text,
        'customerEmail': _customerEmailController.text,
        'customerPhone': _customerPhoneController.text,
        'shippingAddress': _shippingAddressController.text,
        'totalAmount': totalAmountWithShipping,
        'paymentMethod': _selectedPaymentMethod,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Show custom dialog instead of SnackBar
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 60),
              SizedBox(height: 16),
              Text("Order Submitted!",
                  style: GoogleFonts.poppins(
                      fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(
                  "Thank you for placing your order. We will contact you soon.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontSize: 16)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Reset form
                  _customerNameController.clear();
                  _customerEmailController.clear();
                  _customerPhoneController.clear();
                  _shippingAddressController.clear();
                  setState(() {
                    _selectedPaymentMethod = 'Select Method';
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text("Close",
                    style: GoogleFonts.poppins(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error placing order: $e")),
      );
    }
  }

  void _changePaymentMethod(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Select Payment Method',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                _buildPaymentMethodOption(
                    'Cash On Delivery', FontAwesomeIcons.moneyBillWave),
                _buildPaymentMethodOption(
                    'Bank Account', FontAwesomeIcons.creditCard),
                _buildPaymentMethodOption(
                    'JazzCash', FontAwesomeIcons.mobileAlt),
                _buildPaymentMethodOption(
                    'SadaPay', FontAwesomeIcons.moneyCheck),
                _buildPaymentMethodOption(
                    'EasyPaisa', FontAwesomeIcons.creditCard),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPaymentMethodOption(String method, IconData icon) {
    return ListTile(
      leading: FaIcon(icon, color: Colors.green),
      title: Text(
        method,
        style: GoogleFonts.poppins(fontSize: 16),
      ),
      onTap: () {
        if (method == 'Bank Account' ||
            method == 'JazzCash' ||
            method == 'SadaPay' ||
            method == 'EasyPaisa') {
          _showAccountDetailsDialog(method);
        } else {
          setState(() {
            _selectedPaymentMethod = method;
          });
          Navigator.of(context).pop(); // Close the dialog
        }
      },
    );
  }

  void _showAccountDetailsDialog(String method) {
    final TextEditingController accountController = TextEditingController();
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Enter Details for $method',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                      labelText: 'Account Holder Name',
                      border: OutlineInputBorder(),
                      labelStyle: GoogleFonts.poppins()),
                      
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: accountController,
                  decoration: InputDecoration(
                      labelText: 'Account Number',
                      border: OutlineInputBorder(),
                      labelStyle: GoogleFonts.poppins()),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isEmpty ||
                        accountController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                          'Please enter both name and account number',
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        )),
                      );
                      return;
                    }

                    setState(() {
                      _selectedPaymentMethod =
                          '$method - ${accountController.text}';
                    });
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: Text(
                    'Submit',
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCustomerDetailsForm() {
    return Column(
      children: [
        _buildTextField(_customerNameController, 'Customer Name'),
        _buildTextField(_customerEmailController, 'Email'),
        _buildTextField(_customerPhoneController, 'Phone'),
        _buildTextField(_shippingAddressController, 'Shipping Address',
            maxLines: 3),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        style: GoogleFonts.poppins(),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        maxLines: maxLines,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label is required';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double totalAmountWithShipping = widget.totalAmount;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Payment Method',
            style: GoogleFonts.poppins(
              color: const Color.fromARGB(255, 0, 0, 0),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfoCard(
                  title: "Payment Method",
                  subtitle: _selectedPaymentMethod,
                  leadingIcon: FontAwesomeIcons.creditCard,
                  onTap: () => _changePaymentMethod(context),
                ),
                const Divider(thickness: 1),
                const SizedBox(height: 20),
                _buildCustomerDetailsForm(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: BottomSheetWidget(
        totalAmount: widget.totalAmount,
        selectedPaymentMethod: _selectedPaymentMethod,
        onPlaceOrder: _onPlaceOrder,
      ),
    );
  }
}

class BottomSheetWidget extends StatelessWidget {
  final double totalAmount;
  final String selectedPaymentMethod;
  final VoidCallback onPlaceOrder;

  const BottomSheetWidget({
    super.key,
    required this.totalAmount,
    required this.selectedPaymentMethod,
    required this.onPlaceOrder,
  });

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,##0.00', 'en_US');
    final formattedTotalAmount = numberFormat.format(totalAmount);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        color: Colors.white,
        elevation: 10,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Total:\PKR$formattedTotalAmount',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: onPlaceOrder,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.green,
                ),
                child: Text(
                  'Place Order',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CartServices {
  static double getTotalAmount() {
    double totalAmount = 0.0;
    return totalAmount;
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData leadingIcon;
  final VoidCallback onTap;

  const InfoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.leadingIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      leading: FaIcon(leadingIcon, color: Colors.green),
      title: Text(
        title,
        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.poppins(),
      ),
      onTap: onTap,
    );
  }
}
