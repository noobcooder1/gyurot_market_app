import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/user_profile.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _birthYearController;
  late TextEditingController _phoneNumberController;
  File? _profileImage;
  File? _backgroundImage;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final userProfile = context.read<UserProfileProvider>().userProfile;
    _nameController = TextEditingController(text: userProfile.name);
    _birthYearController = TextEditingController(text: userProfile.birthYear);
    _phoneNumberController = TextEditingController(
      text: userProfile.phoneNumber,
    );
    if (userProfile.profileImage != null) {
      _profileImage = File(userProfile.profileImage!);
    }
    if (userProfile.backgroundImage != null) {
      _backgroundImage = File(userProfile.backgroundImage!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthYearController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(bool isProfile) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        if (isProfile) {
          _profileImage = File(image.path);
        } else {
          _backgroundImage = File(image.path);
        }
      });
    }
  }

  void _saveProfile() {
    context.read<UserProfileProvider>().updateProfile(
      name: _nameController.text,
      birthYear: _birthYearController.text,
      phoneNumber: _phoneNumberController.text,
      profileImage: _profileImage?.path,
      backgroundImage: _backgroundImage?.path,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필 수정'),
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: const Text('완료', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // Background Image
                GestureDetector(
                  onTap: () => _pickImage(false),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: _backgroundImage != null
                        ? Image.file(_backgroundImage!, fit: BoxFit.cover)
                        : const Icon(Icons.camera_alt, color: Colors.grey),
                  ),
                ),
                // Profile Image
                Positioned(
                  bottom: 20, // Adjusted to be visible
                  child: GestureDetector(
                    onTap: () => _pickImage(true),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : null,
                      child: _profileImage == null
                          ? const Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.grey,
                            )
                          : null,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: MediaQuery.of(context).size.width / 2 - 50,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 20,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: '닉네임',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _birthYearController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: '태어난 연도',
                      hintText: '예) 1990',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: '전화번호',
                      hintText: '010-1234-5678',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
