import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrackOrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            "Track Order",
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Information
            _buildOrderInfo(),
            SizedBox(height: 24),

            // Timeline
            Expanded(
              child: ListView(
                children: [
                  _buildTimelineStep(
                    title: "Order Placed",
                    isCompleted: true,
                    date: "12 Dec, 2024 - 10:00 AM",
                    isLast: false,
                  ),
                  _buildTimelineStep(
                    title: "Order Processed",
                    isCompleted: true,
                    date: "12 Dec, 2024 - 12:00 PM",
                    isLast: false,
                  ),
                  _buildTimelineStep(
                    title: "Shipped",
                    isCompleted: true,
                    date: "13 Dec, 2024 - 9:00 AM",
                    isLast: false,
                  ),
                  _buildTimelineStep(
                    title: "Out for Delivery",
                    isCompleted: false,
                    date: "",
                    isLast: false,
                  ),
                  _buildTimelineStep(
                    title: "Delivered",
                    isCompleted: false,
                    date: "",
                    isLast: true,
                  ),
                ],
              ),
            ),

            // Bottom Action Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  // Widget: Order Info
  Widget _buildOrderInfo() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Order #12345",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Status: In Transit",
            style: GoogleFonts.poppins(
              color: Colors.grey[700],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // Widget: Timeline Step
  Widget _buildTimelineStep({
    required String title,
    required bool isCompleted,
    required String date,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(
              isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isCompleted ? Colors.green : Colors.grey,
            ),
            if (!isLast)
              Container(
                height: 50,
                width: 2,
                color: isCompleted ? Colors.green : Colors.grey,
              ),
          ],
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isCompleted ? Colors.black : Colors.grey,
                ),
              ),
              SizedBox(height: 4),
              if (date.isNotEmpty)
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget: Bottom Action Buttons
  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // ElevatedButton.icon(
        //   onPressed: () {
        //     // Add support functionality
        //   },
        //   icon: Icon(Icons.headset_mic, color: Colors.white),
        //   label: Text(
        //     "Contact Support",
        //     style: GoogleFonts.poppins(color: Colors.white),
        //   ),
        //   style: ElevatedButton.styleFrom(
        //     backgroundColor: Colors.redAccent,
        //     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        //   ),
        // ),
        ElevatedButton.icon(
          onPressed: () {
            // Add support functionality
          },
          icon: Icon(Icons.headset_mic, color: Colors.white),
          label: Text(
            "Contact Support",
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }
}

void main() => runApp(MaterialApp(
      home: TrackOrderPage(),
    ));
