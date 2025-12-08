import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';
import '../models/user_profile.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late TextEditingController _nameController;
  late TextEditingController _idController;
  final ImagePicker _picker = ImagePicker();
  Uint8List? _selectedImage;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<UserProfileProvider>(context, listen: false);
    _nameController = TextEditingController(text: provider.userProfile.name);
    _idController = TextEditingController(text: provider.userProfile.id);
    _selectedImage = provider.userProfile.profileImageBytes;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
        final textColor = isDark ? Colors.white : Colors.black;

        return Container(
          color: bgColor,
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt, color: textColor),
                  title: Text('카메라로 촬영', style: TextStyle(color: textColor)),
                  onTap: () async {
                    Navigator.pop(context);
                    await _getImageFromCamera();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_library, color: textColor),
                  title: Text('앨범에서 선택', style: TextStyle(color: textColor)),
                  onTap: () async {
                    Navigator.pop(context);
                    await _getImageFromGallery();
                  },
                ),
                if (_selectedImage != null)
                  ListTile(
                    leading: const Icon(Icons.delete, color: Colors.red),
                    title: const Text(
                      '프로필 사진 삭제',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        _selectedImage = null;
                      });
                    },
                  ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _getImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _selectedImage = bytes;
        });
      }
    } catch (e) {
      Get.snackbar('오류', '카메라를 사용할 수 없습니다');
    }
  }

  Future<void> _getImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _selectedImage = bytes;
        });
      }
    } catch (e) {
      Get.snackbar('오류', '갤러리에서 이미지를 가져올 수 없습니다');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white : Colors.black;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.close, color: iconColor),
        ),
        title: const Text('프로필 수정'),
        backgroundColor: cardColor,
        foregroundColor: iconColor,
        elevation: 0.5,
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: const Text(
              '저장',
              style: TextStyle(
                color: Color(0xFFFF6F0F),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 32),
            // 프로필 이미지
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: isDark
                          ? Colors.grey[700]
                          : Colors.grey[200],
                      backgroundImage: _selectedImage != null
                          ? MemoryImage(_selectedImage!)
                          : null,
                      child: _selectedImage == null
                          ? Icon(
                              Icons.person,
                              size: 50,
                              color: isDark
                                  ? Colors.grey[500]
                                  : Colors.grey[400],
                            )
                          : null,
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6F0F),
                          shape: BoxShape.circle,
                          border: Border.all(color: cardColor, width: 2),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            // 입력 필드들
            Container(
              color: cardColor,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '닉네임',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    style: TextStyle(color: iconColor),
                    decoration: InputDecoration(
                      hintText: '닉네임을 입력해주세요',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      filled: true,
                      fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '아이디',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _idController,
                    style: TextStyle(color: iconColor),
                    decoration: InputDecoration(
                      hintText: '아이디',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      filled: true,
                      fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    enabled: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveProfile() {
    if (_nameController.text.trim().isEmpty) {
      Get.snackbar('오류', '닉네임을 입력해주세요');
      return;
    }

    final provider = Provider.of<UserProfileProvider>(context, listen: false);
    provider.updateProfile(
      name: _nameController.text.trim(),
      profileImageBytes: _selectedImage,
    );
    Get.snackbar('완료', '프로필이 저장되었습니다');
    Navigator.pop(context);
  }
}
