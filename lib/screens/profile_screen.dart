import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_profile.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProfile = context.watch<UserProfileProvider>().userProfile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.share))],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // Background Image
                Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: userProfile.backgroundImage != null
                      ? Image.file(
                          File(userProfile.backgroundImage!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                // Profile Image
                Positioned(
                  bottom: -50,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: userProfile.profileImage != null
                          ? FileImage(File(userProfile.profileImage!))
                          : null,
                      child: userProfile.profileImage == null
                          ? const Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.grey,
                            )
                          : null,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
            Text(
              userProfile.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(userProfile.id, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfileScreen(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    '프로필 수정',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Divider(thickness: 8, color: Color(0xFFF5F5F5)),
            ListTile(
              title: const Text('태어난 연도'),
              trailing: Text(userProfile.birthYear ?? '미입력'),
            ),
            const Divider(height: 1),
            ListTile(
              title: const Text('전화번호'),
              trailing: Text(userProfile.phoneNumber ?? '미입력'),
            ),
            const Divider(height: 1),
          ],
        ),
      ),
    );
  }
}
