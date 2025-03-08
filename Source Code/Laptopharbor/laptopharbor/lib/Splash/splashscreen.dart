// ignore_for_file: unused_import

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laptopharbor/Authentication/Login.dart';
import 'package:laptopharbor/myHome.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: false);

    _animation = Tween<double>(begin: 0.8, end: 1.1).
    animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    // Navigate to the home screen after a delay
    Timer ( const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
          // gradient: LinearGradient(
          //   colors: [
          //     Colors.black,
          //     Colors.white,
          //   ],
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          // ),
        ),
        
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _animation.value,
                    child: Text(
                      "LH",
                      style: GoogleFonts.blackOpsOne(
                        fontSize: 55,
                        color: const Color.fromARGB(255, 255, 255, 255),
                        letterSpacing: 5, // Constant letter spacing
                        shadows: [
                          const Shadow(
                            offset: Offset(3, 3),
                            blurRadius: 5,
                            color: Color.fromARGB(115, 255, 255, 255),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
             const SizedBox(height: 3),
              // Text(
              //   "Laptop-Harbor",
              //   style: GoogleFonts.marcellus(
              //     fontSize: 24,
              //     color: Colors.white.withOpacity(0.9),
              //     shadows: [
              //       Shadow(
              //         offset: Offset(2, 2),
              //         blurRadius: 4,
              //         color: Colors.black26,
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
