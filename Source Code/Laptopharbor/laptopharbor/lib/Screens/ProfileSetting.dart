// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laptopharbor/Authentication/Login.dart';
import 'package:laptopharbor/myHome.dart';

class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({super.key});

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  String name = "User Name";
  String email = "User@gmail.com";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        title: Text(
          'Profile Settings',
          style: GoogleFonts.poppins(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              color: const Color.fromARGB(255, 0, 0, 0),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(
                      'images/profile.jpeg', // Replace with user image URL
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        email,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () async {
                      // Navigate to Edit Profile Page and wait for result
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfilePage(
                            name: name,
                            email: email,
                            profileImageUrl: '',
                          ),
                        ),
                      );

                      // Update name and email if result is not null
                      if (result != null && result is Map<String, String>) {
                        setState(() {
                          name = result['name']!;
                          email = result['email']!;
                        });
                      }
                    },
                    icon: const Icon(Icons.edit, color: Colors.white),
                  ),
                ],
              ),
            ),
            // const SizedBox(height: 10),
            // Settings Section
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  // Account Settings
                  // SettingsTile(
                  //   icon: Icons.person,
                  //   title: 'Account Information',
                  //   subtitle: 'Update your account details',
                  //   onTap: () {
                  //   //   // Navigator.push(
                  //   //   //   context,
                  //   //   //   MaterialPageRoute(
                  //   //   //     builder: (context) => const AccountInformationPage(),
                  //   //   //   ),
                  //   //   // );
                  //   // },
                  //   }
                  // ),

                  const SizedBox(height: 10),
                  SettingsTile(
                    icon: Icons.lock,
                    title: 'Change Password',
                    subtitle: 'Update your password regularly',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChangePasswordPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  SettingsTile(
                    icon: Icons.notifications,
                    title: 'Notifications',
                    subtitle: 'Manage your notification preferences',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationsPage(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 10),
                  SettingsTile(
                    icon: Icons.privacy_tip,
                    title: 'Privacy Settings',
                    subtitle: 'Manage your privacy options',
                    onTap: () {
                      // Navigate to Privacy Settings Page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PrivacySettingsPage()),
                      );
                    },
                  ),

                  const SizedBox(height: 20),
                  // Save Button
                  Center(
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Use spaceEvenly for even spacing between buttons
    children: [
      ElevatedButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyHome()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          padding: EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          'Update',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      // ElevatedButton(
      //   onPressed: () {
      //     Navigator.pushReplacement(
      //       context,
      //       MaterialPageRoute(builder: (context) => LoginPage()),
      //     );
      //   },
      //   style: ElevatedButton.styleFrom(
      //     backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      //     padding: EdgeInsets.all(20),
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(10),
      //     ),
      //   ),
      //   child: Text(
      //     'Logout',
      //     style: GoogleFonts.poppins(
      //       fontSize: 16,
      //       fontWeight: FontWeight.bold,
      //       color: Colors.white,
      //     ),
      //   ),
      // ),
    ],
  ),
)

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable Settings Tile
class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 28, color: const Color.fromARGB(255, 0, 0, 0)),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  final String name;
  final String email;
  final String profileImageUrl;

  const EditProfilePage({
    super.key,
    required this.name,
    required this.email,
    required this.profileImageUrl,
  });

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // File? _profileImage;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.name;
    emailController.text = widget.email;
  }

  // Function to pick a new image from gallery
  // Future<void> _pickImage() async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  //   if (pickedFile != null) {
  //     setState(() {
  //       _profileImage = File(pickedFile.path);
  //     });
  //   }
  // }

  // Function to capture an image using the camera
  // Future<void> _captureImage() async {
  //   final picker = ImagePicker();
  //   final capturedFile = await picker.pickImage(source: ImageSource.camera);

  //   if (capturedFile != null) {
  //     setState(() {
  //       _profileImage = File(capturedFile.path);
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: Text(
          'Edit Profile',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image Section
            Stack(
              alignment: Alignment.center,
              children: [
                const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage("images/profile.jpeg")),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      // Show a dialog to pick or capture an image
                      // showDialog(
                      //   context: context,
                      //   builder: (context) => AlertDialog(
                      //     title: const Text("Choose an Option"),
                      //     content: Column(
                      //       mainAxisSize: MainAxisSize.min,
                      //       children: [
                      //         ListTile(
                      //           leading: const Icon(Icons.camera_alt),
                      //           title: const Text("Capture Image"),
                      //           onTap: () {
                      //             _captureImage();
                      //             Navigator.pop(context);
                      //           },
                      //         ),
                      //         ListTile(
                      //           leading: const Icon(Icons.photo_album),
                      //           title: const Text("Choose from Gallery"),
                      //           onTap: () {
                      //             _pickImage();
                      //             Navigator.pop(context);
                      //           },
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[700],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Name Input Field
            Text(
              'Name',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Enter your name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Email Input Field
            Text(
              'Email',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Enter your email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Save Changes Button
            ElevatedButton(
              onPressed: () {
                // Save profile changes logic
                String newName = nameController.text;
                String newEmail = emailController.text;

                if (newName.isNotEmpty && newEmail.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Profile Updated',
                        style: GoogleFonts.poppins(),
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );

                  Navigator.pop(context, {
                    'name': newName,
                    'email': newEmail,
                    // 'profileImage': _profileImage?.path ?? widget.profileImageUrl,
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Please fill in all fields.',
                        style: GoogleFonts.poppins(),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Save Changes',
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
    );
  }
}

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController currentPasswordController =
        TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: Text(
          'Change Password',
          style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 0, 0, 0)),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'Current Password',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Enter your current password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'New Password',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Enter your new password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Confirm Password',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Confirm your new password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Validate and update password
                if (newPasswordController.text ==
                        confirmPasswordController.text &&
                    newPasswordController.text.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Password successfully updated!',
                        style: GoogleFonts.poppins(),
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Passwords do not match!',
                        style: GoogleFonts.poppins(),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Save Changes',
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
    );
  }
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool emailNotifications = true;
    bool pushNotifications = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            title: Text(
              'Notifications',
              style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SwitchListTile(
                  title: Text(
                    'Email Notifications',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  value: emailNotifications,
                  onChanged: (bool value) {
                    setState(() {
                      emailNotifications = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: Text(
                    'Push Notifications',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  value: pushNotifications,
                  onChanged: (bool value) {
                    setState(() {
                      pushNotifications = value;
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class PrivacySettingsPage extends StatefulWidget {
  const PrivacySettingsPage({super.key});

  @override
  _PrivacySettingsPageState createState() => _PrivacySettingsPageState();
}

class _PrivacySettingsPageState extends State<PrivacySettingsPage> {
  bool _isProfilePrivate = false;
  bool _allowLocationAccess = true;
  bool _allowFriendRequests = true;
  String _profileVisibility = 'Everyone';
  bool _shareActivityStatus = true;
  bool _enableTwoFactorAuth = false;
  bool _emailNotificationsForChanges = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Privacy Settings',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Privacy Toggle
            SwitchListTile(
              title: Text(
                'Make Profile Private',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              value: _isProfilePrivate,
              onChanged: (bool value) {
                setState(() {
                  _isProfilePrivate = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // Location Access Toggle
            SwitchListTile(
              title: Text(
                'Allow Location Access',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              value: _allowLocationAccess,
              onChanged: (bool value) {
                setState(() {
                  _allowLocationAccess = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // Friend Requests Toggle
            SwitchListTile(
              title: Text(
                'Allow Friend Requests',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              value: _allowFriendRequests,
              onChanged: (bool value) {
                setState(() {
                  _allowFriendRequests = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // Profile Visibility
            ListTile(
              title: Text(
                'Profile Visibility',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              subtitle: Text(
                'Who can see your profile: $_profileVisibility',
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              onTap: () {
                _showProfileVisibilityDialog();
              },
            ),
            const SizedBox(height: 20),

            // Share Activity Status Toggle
            SwitchListTile(
              title: Text(
                'Share Activity Status',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              value: _shareActivityStatus,
              onChanged: (bool value) {
                setState(() {
                  _shareActivityStatus = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // Two-Factor Authentication Toggle
            SwitchListTile(
              title: Text(
                'Enable Two-Factor Authentication',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              value: _enableTwoFactorAuth,
              onChanged: (bool value) {
                setState(() {
                  _enableTwoFactorAuth = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // Email Notifications for Privacy Changes
            SwitchListTile(
              title: Text(
                'Email Notifications for Privacy Changes',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              value: _emailNotificationsForChanges,
              onChanged: (bool value) {
                setState(() {
                  _emailNotificationsForChanges = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // Save Changes Button
            ElevatedButton(
              onPressed: () {
                // Save privacy settings changes
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Privacy Settings Updated',
                      style: GoogleFonts.poppins(),
                    ),
                    backgroundColor: Colors.green,
                  ),
                );

                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Save Changes',
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
    );
  }

  // Function to show profile visibility dialog
  void _showProfileVisibilityDialog() async {
    String? selectedValue = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Select Profile Visibility',
            style:
                GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: Text('Everyone', style: GoogleFonts.poppins()),
                value: 'Everyone',
                groupValue: _profileVisibility,
                onChanged: (String? value) {
                  Navigator.pop(context, value);
                },
              ),
              RadioListTile<String>(
                title: Text('Friends Only', style: GoogleFonts.poppins()),
                value: 'Friends Only',
                groupValue: _profileVisibility,
                onChanged: (String? value) {
                  Navigator.pop(context, value);
                },
              ),
              RadioListTile<String>(
                title: Text('Nobody', style: GoogleFonts.poppins()),
                value: 'Nobody',
                groupValue: _profileVisibility,
                onChanged: (String? value) {
                  Navigator.pop(context, value);
                },
              ),
            ],
          ),
        );
      },
    );

    if (selectedValue != null) {
      setState(() {
        _profileVisibility = selectedValue;
      });
    }
  }
}
