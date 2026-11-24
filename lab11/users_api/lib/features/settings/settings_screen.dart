import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/auth_model.dart';
import '../profile/profile_screen.dart';
import '../users/users_model.dart';

import 'settings_model.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsModel>();
    final users = context.watch<UsersModel>();

    final cities = users.items.map((user) => user.address.city).toSet().toList()
      ..sort();

    final selectedCity = settings.city;

    if (selectedCity != null && !cities.contains(selectedCity)) {
      cities.add(selectedCity);
      cities.sort();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Profile'),
            subtitle: const Text('Change profile photo'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const ProfileScreen()),
              );
            },
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Dark mode'),
            subtitle: const Text('Use dark theme'),
            secondary: const Icon(Icons.dark_mode),
            value: settings.dark,
            onChanged: (value) async {
              await settings.setDark(value);
            },
          ),
          const Divider(),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: settings.city ?? '',
            decoration: const InputDecoration(
              labelText: 'City filter',
              border: OutlineInputBorder(),
            ),
            items: [
              const DropdownMenuItem<String>(
                value: '',
                child: Text('All cities'),
              ),
              for (final city in cities)
                DropdownMenuItem<String>(value: city, child: Text(city)),
            ],
            onChanged: (value) async {
              await settings.setCity(value == '' ? null : value);
            },
          ),
          const SizedBox(height: 24),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign out'),
            onTap: () async {
              await context.read<AuthModel>().logout();
            },
          ),
        ],
      ),
    );
  }
}
