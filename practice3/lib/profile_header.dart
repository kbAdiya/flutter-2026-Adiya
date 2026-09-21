import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String university;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.university,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/images/photo.jpg', width: 120, height: 120),
        Text(name, style: const TextStyle(fontFamily: 'MyProfileFont')),
        Text(university),
      ],
    );
  }
}
