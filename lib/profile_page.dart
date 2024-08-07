// lib/pages/profile_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _usernameController = TextEditingController(text: 'JohnDoe');
  final _emailController = TextEditingController(text: 'johndoe@example.com');
  final _passwordController = TextEditingController(text: '********');
  final ImagePicker _picker = ImagePicker();
  XFile? _profileImage;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = pickedFile;
      });
    }
  }

  void _updateProfile() {
    // Add your profile update logic here
    print('Profile updated: ${_usernameController.text}, ${_emailController.text}, ${_passwordController.text}');
  }

  void _logout() {
    // Add your logout logic here
    print('Logged out');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings'); // Ensure '/settings' route is defined
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _profileImage != null
                        ? FileImage(File(_profileImage!.path))
                        : AssetImage('assets/default_profile_image.png') as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: _pickImage,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            _buildEditRow('Username', _usernameController),
            _buildEditRow('Email', _emailController),
            _buildEditRow('Password', _passwordController, obscureText: true),
            Spacer(),
            ElevatedButton.icon(
              onPressed: _logout,
              icon: Icon(Icons.logout),
              label: Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditRow(String label, TextEditingController controller, {bool obscureText = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('$label: ${controller.text}', style: TextStyle(fontSize: 18)),
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Edit $label'),
                  content: TextField(
                    controller: controller,
                    obscureText: obscureText,
                    decoration: InputDecoration(labelText: label),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _updateProfile();
                      },
                      child: Text('Submit'),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}
