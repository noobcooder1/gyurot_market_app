import 'package:flutter/material.dart';

class UserProfile {
  String name;
  String id;
  String? birthYear;
  String? phoneNumber;
  String? profileImage; // Path to local file
  String? backgroundImage; // Path to local file

  UserProfile({
    required this.name,
    required this.id,
    this.birthYear,
    this.phoneNumber,
    this.profileImage,
    this.backgroundImage,
  });
}

class UserProfileProvider extends ChangeNotifier {
  UserProfile _userProfile = UserProfile(name: '당근이', id: '#123456');

  UserProfile get userProfile => _userProfile;

  void updateProfile({
    String? name,
    String? id,
    String? birthYear,
    String? phoneNumber,
    String? profileImage,
    String? backgroundImage,
  }) {
    _userProfile = UserProfile(
      name: name ?? _userProfile.name,
      id: id ?? _userProfile.id,
      birthYear: birthYear ?? _userProfile.birthYear,
      phoneNumber: phoneNumber ?? _userProfile.phoneNumber,
      profileImage: profileImage ?? _userProfile.profileImage,
      backgroundImage: backgroundImage ?? _userProfile.backgroundImage,
    );
    notifyListeners();
  }
}
