import 'package:flutter/material.dart';
import 'dart:typed_data';

class UserProfile {
  String name;
  String id;
  String? birthYear;
  String? phoneNumber;
  String? profileImage; // Path to local file
  String? backgroundImage; // Path to local file
  Uint8List? profileImageBytes; // 프로필 이미지 바이트 데이터

  UserProfile({
    required this.name,
    required this.id,
    this.birthYear,
    this.phoneNumber,
    this.profileImage,
    this.backgroundImage,
    this.profileImageBytes,
  });
}

class UserProfileProvider extends ChangeNotifier {
  UserProfile _userProfile = UserProfile(name: '당근이22', id: '#123456');

  UserProfile get userProfile => _userProfile;

  void updateProfile({
    String? name,
    String? id,
    String? birthYear,
    String? phoneNumber,
    String? profileImage,
    String? backgroundImage,
    Uint8List? profileImageBytes,
  }) {
    _userProfile = UserProfile(
      name: name ?? _userProfile.name,
      id: id ?? _userProfile.id,
      birthYear: birthYear ?? _userProfile.birthYear,
      phoneNumber: phoneNumber ?? _userProfile.phoneNumber,
      profileImage: profileImage ?? _userProfile.profileImage,
      backgroundImage: backgroundImage ?? _userProfile.backgroundImage,
      profileImageBytes: profileImageBytes ?? _userProfile.profileImageBytes,
    );
    notifyListeners();
  }
}
