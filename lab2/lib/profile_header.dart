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
        Image.asset('assets/images/profile.jpeg', width: 200, height: 200),
        Text(
          name,
          style: TextStyle(
            fontFamily: 'Kablammo',
            fontSize: 24,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Text(university, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
