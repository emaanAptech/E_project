import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laptopharbor/Screens/CartServices.dart';
import 'package:laptopharbor/Screens/Wishlist.dart';

class MyCustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final int cartItemCount;
  final int wishlistItemCount;
  final List<Map<String, dynamic>> wishlistItems;
  final List<Map<String, dynamic>> cartItems;

  const MyCustomAppBar({
    Key? key,
    required this.cartItemCount,
    this.wishlistItemCount = 0,
    required this.wishlistItems,
    required this.cartItems,
  }) : super(key: key);

  @override
  _MyCustomAppBarState createState() => _MyCustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}

class _MyCustomAppBarState extends State<MyCustomAppBar> {
  bool _isSearching = false;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.black),
      title: _isSearching
          ? TextField(
              controller: _searchController,
              autofocus: true,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: "Search...",
                hintStyle:
                    GoogleFonts.poppins(color: Colors.black.withOpacity(0.5)),
                border: InputBorder.none,
              ),
              onChanged: (query) {
                // Implement search functionality if needed
              },
            )
          : Center(
              child: Text(
                "Laptop Harbor",
                style: GoogleFonts.rationale(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                ),
              ),
            ),
      actions: [
        if (!_isSearching)
          IconButton(
            onPressed: () {
              setState(() {
                _isSearching = true;
              });
            },
            icon: const FaIcon(FontAwesomeIcons.magnifyingGlass, size: 20),
          ),
        _buildIconWithBadge(
          icon: FontAwesomeIcons.heart,
          count: widget.wishlistItemCount,
          onPressed: () => _showWishlist(context),
        ),
        _buildIconWithBadge(
          icon: FontAwesomeIcons.cartShopping,
          count: widget.cartItemCount,
          onPressed: () => _showCart(context),
        ),
      ],
    );
  }

  Widget _buildIconWithBadge({
    required IconData icon,
    required int count,
    required VoidCallback onPressed,
  }) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        IconButton(
          onPressed: onPressed,
          icon: FaIcon(icon, size: 20),
        ),
        if (count > 0)
          Positioned(
            right: 5,
            top: 5,
            child: Container(
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(15),
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                count.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  void _showCart(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return CartServices(cartItems: List.from(widget.cartItems));
      },
    );
  }

  void _showWishlist(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return WishListScreen(wishList: List.from(widget.wishlistItems));
      },
    );
  }
}
