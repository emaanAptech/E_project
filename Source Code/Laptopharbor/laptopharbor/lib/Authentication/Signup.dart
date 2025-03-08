// ignore_for_file: unused_local_variable, prefer_const_constructors, unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laptopharbor/Authentication/Login.dart';
import 'package:laptopharbor/Authentication/Signup.dart';
import 'package:laptopharbor/myHome.dart';

class Signup extends StatefulWidget {
  Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color.fromARGB(255, 223, 223, 223),

      body: Stack(children: [
        // Background Image
        Positioned.fill(
          child: Image.asset(
            "images/background.jpg", // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        Center(
          child: SizedBox(
            width: 350,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // First CircleAvatar with gradient background
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.black, Colors.grey],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "REGISTER!",
                  style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: Colors.white),
                ),
                const SizedBox(height: 16),

                // // First Name
                // TextField(
                //   controller: fnameController,
                //   keyboardType: TextInputType.name,
                //   decoration: InputDecoration(
                //     labelText: "Enter your First",
                //     labelStyle: GoogleFonts.poppins(
                //       fontSize: 16,
                //       fontWeight: FontWeight.w400,
                //       // color: Colors.black,
                //     ),
                //     filled: true,
                //     fillColor: Colors.white,
                //     prefixIcon: const Icon(
                //       Icons.person_3,
                //       size: 18,
                //     ),
                //     border: const OutlineInputBorder(
                //       borderRadius: BorderRadius.all(Radius.circular(15)),
                //     ),
                //     enabledBorder: const OutlineInputBorder(
                //       borderRadius: BorderRadius.all(Radius.circular(15)),
                //       borderSide: BorderSide(
                //         color: Color.fromARGB(255, 255, 255, 255),
                //       ),
                //     ),
                //   ),
                // ),

                // const SizedBox(height: 16),

                // // Last Name
                // TextField(
                //   controller: lnameController,
                //   keyboardType: TextInputType.name,
                //   decoration: InputDecoration(
                //     labelText: "Enter your Last Name",
                //     labelStyle: GoogleFonts.poppins(
                //       fontSize: 16,
                //       fontWeight: FontWeight.w400,
                //       // color: Colors.black,
                //     ),
                //     filled: true,
                //     fillColor: Colors.white,
                //     prefixIcon: const Icon(
                //       Icons.person_3,
                //       size: 18,
                //     ),
                //     border: const OutlineInputBorder(
                //       borderRadius: BorderRadius.all(Radius.circular(15)),
                //     ),
                //     enabledBorder: const OutlineInputBorder(
                //       borderRadius: BorderRadius.all(Radius.circular(15)),
                //       borderSide: BorderSide(
                //         color: Color.fromARGB(255, 255, 255, 255),
                //       ),
                //     ),
                //   ),
                // ),

                // const SizedBox(height: 16),

                // Email Field
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Enter your Email",
                    labelStyle: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      // color: Colors.black,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(
                      Icons.email,
                      size: 18,
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Password Field
                TextField(
                  controller: passController,
                  obscureText: true,
                  obscuringCharacter: "*",
                  decoration: InputDecoration(
                    labelText: "Create Password",
                    labelStyle: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      // color: Colors.black,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(
                      Icons.lock,
                      size: 18,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Register Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        setState(() {
                          isLoading = true;
                        });
                        final credential = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: emailController.text,
                          password: passController.text,
                        );
                        // fnameController.clear();
                        // lnameController.clear();
                        emailController.clear();
                        passController.clear();
                        
                        // Stop loader
                        setState(() {
                          isLoading = false;
                        });
                      } 
                      on FirebaseAuthException catch (e) {
                        setState(() {
                          isLoading = false;
                        });
                        if (e.code == 'weak-password') {
                          print('The password provided is too weak.');
                        } else if (e.code == 'email-already-in-use') {
                          print('The account already exists for that email.');
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text("Register",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: const Color.fromARGB(255, 255, 255, 255),
                        )),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?  ",
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: const Color.fromARGB(255, 0, 255, 0),
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 9,
                ),
                Visibility(
                    visible: isLoading, child: CircularProgressIndicator())
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
