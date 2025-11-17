import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simplyserve/custom_widget/gradient_button.dart';
import 'package:simplyserve/screen/location/change_location_page.dart';
import 'package:simplyserve/service/auth_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = "";
  String email = "";
  String? imageUrl;
  final ImagePicker _picker = ImagePicker();
  @override
  void initState() {
    dataSet();
    super.initState();
  }

  Future<void> dataSet() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      name = prefs.getString('user_name') ?? "";
      email = prefs.getString('user_email') ?? "";
    });
  }

  Future<void> pickAndUploadImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile == null) return;

      File imageFile = File(pickedFile.path);

      // Create reference with unique name
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('$fileName.jpg');

      // Upload file and wait for completion
      final uploadTask = storageRef.putFile(imageFile);

      // Wait until upload completes successfully
      final snapshot = await uploadTask.whenComplete(() => null);

      // Get download URL safely after upload completes
      final downloadURL = await snapshot.ref.getDownloadURL();

      setState(() {
        imageUrl = downloadURL;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image uploaded successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error uploading image: $e')));
    }
  }

  void showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                pickAndUploadImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                pickAndUploadImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8,
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  const Text(
                    'Profile',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  // Settings icon
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.settings_outlined),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 12,
              ),
              child: Column(
                children: [
                  // Avatar with camera icon overlay
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: imageUrl != null
                            ? NetworkImage(imageUrl!)
                            : const NetworkImage(
                                'https://cdn-icons-png.flaticon.com/512/847/847969.png',
                              ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap:
                              showImageSourceDialog, // your function to pick/upload image
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.blue,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    ],

                    // Optional: You can remove the ElevatedButton completely
                    // ElevatedButton.icon(
                    //   onPressed: showImageSourceDialog,
                    //   icon: const Icon(Icons.upload),
                    //   label: const Text("Upload Image"),
                    // ),

                    // backgroundImage: const NetworkImage(
                    //   'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=580',
                    // ), // replace with AssetImage if you have local avatar
                  ),
                  const SizedBox(height: 16),

                  // Name
                  Text(
                    name,
                    style: textTheme.titleLarge?.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Email
                  Text(
                    email,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),
            const Divider(height: 1, thickness: 1, color: Color(0xFFF2F2F2)),

            // Options list
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _ProfileTile(
                    icon: Icons.edit_outlined,
                    title: 'Edit Profile',
                    onTap: () {},
                  ),
                  _ProfileTile(
                    icon: Icons.location_on_outlined,
                    title: 'Manage Addresses',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChangeLocationPage(),
                        ),
                      );
                    },
                  ),
                  _ProfileTile(
                    icon: Icons.credit_card_outlined,
                    title: 'Payment Methods',
                    onTap: () {},
                  ),
                  _ProfileTile(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    onTap: () {},
                  ),
                  _ProfileTile(
                    icon: Icons.favorite_border,
                    title: 'Favorites',
                    onTap: () {},
                  ),
                  _ProfileTile(
                    icon: Icons.receipt_long_outlined,
                    title: 'Order History',
                    onTap: () {},
                  ),
                  _ProfileTile(
                    icon: Icons.star_border,
                    title: 'Loyalty Rewards',
                    onTap: () {},
                  ),

                  const SizedBox(height: 12),

                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 30),
                    child: GradientButton(
                      text: 'Log Out',
                      onPressed: () => AuthService().logoutUser(context),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20),
          child: Row(
            children: [
              // Icon with subtle circular background like screenshot
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, size: 26, color: Colors.black54),
            ],
          ),
        ),
      ),
    );
  }
}
