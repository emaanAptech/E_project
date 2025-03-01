import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laptopharbor/Screens/MyAppbar.dart';

class PlaceOrderForm extends StatefulWidget {
  final String selectedPaymentMethod;

  const PlaceOrderForm({super.key, required this.selectedPaymentMethod});

  @override
  _PlaceOrderFormState createState() => _PlaceOrderFormState();
}

class _PlaceOrderFormState extends State<PlaceOrderForm>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _shippingController = TextEditingController();
  final _paymentController = TextEditingController();

  String? _selectedPaymentMethod;

  // Cart item list (Dummy data or from your cart logic)
  List<Map<String, dynamic>> cart = [];

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _selectedPaymentMethod = widget.selectedPaymentMethod;
    _paymentController.text = _selectedPaymentMethod ?? '';
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    _fadeAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _animationController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _shippingController.dispose();
    _paymentController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('orders').add({
          'customerName': _nameController.text,
          'customerEmail': _emailController.text,
          'customerPhone': _phoneController.text,
          'shippingAddress': _shippingController.text,
          'paymentMethod': _selectedPaymentMethod,
          'cart': cart,
          'timestamp': FieldValue.serverTimestamp(),
        });

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
                  onPressed: () => Navigator.of(context).pop(),
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

        _formKey.currentState!.reset();
        _selectedPaymentMethod = null;
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error submitting order: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyCustomAppBar(
        cartItemCount: cart.length,
        wishlistItems: [],
        cartItems: cart,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black87, Colors.black],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.6),
                      blurRadius: 15,
                      offset: Offset(0, 8))
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Place Your Order",
                        style: GoogleFonts.poppins(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        textAlign: TextAlign.center),
                    SizedBox(height: 10),
                    Text(
                        "Please fill in the details below to complete your order.",
                        style: GoogleFonts.poppins(color: Colors.grey[300]),
                        textAlign: TextAlign.center),
                    SizedBox(height: 20),
                    _buildTextField(
                        controller: _nameController,
                        label: "Name",
                        hintText: "Enter your name",
                        validator: (value) => value == null || value.isEmpty
                            ? "Name is required"
                            : null),
                    _buildTextField(
                        controller: _emailController,
                        label: "Email",
                        hintText: "Enter your email",
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => value == null || value.isEmpty
                            ? "Email is required"
                            : !RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}")
                                    .hasMatch(value)
                                ? "Enter a valid email"
                                : null),
                    _buildTextField(
                        controller: _phoneController,
                        label: "Phone Number",
                        hintText: "Enter your phone number",
                        keyboardType: TextInputType.phone,
                        validator: (value) => value == null || value.isEmpty
                            ? "Phone number is required"
                            : !RegExp(r"^[0-9]{11}").hasMatch(value)
                                ? "Enter a valid phone number"
                                : null),
                    _buildTextField(
                        controller: _shippingController,
                        label: "Shipping Address",
                        hintText: "Enter Full Address",
                        maxLines: 3,
                        validator: (value) => value == null || value.isEmpty
                            ? "Shipping address is required"
                            : null),
                    _buildTextField(
                        controller: _paymentController,
                        label: "Payment Method",
                        hintText: _selectedPaymentMethod ?? "Select Payment Method",
                        validator: (value) => value == null || value.isEmpty
                            ? "Payment method is required"
                            : null),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 32, 97, 35),
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text("Place Order",
                          style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: GoogleFonts.poppins(color: Colors.black),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(color: Colors.black87),
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.transparent)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.black87)),
        ),
        validator: validator,
      ),
    );
  }
}
