import 'package:flutter/material.dart';

import 'user.dart';

class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(user.name)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const CircleAvatar(radius: 35, child: Icon(Icons.person, size: 40)),
          const SizedBox(height: 20),
          Text(
            user.name,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.alternate_email),
            title: Text(user.username),
            subtitle: const Text('Username'),
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: Text(user.email),
            subtitle: const Text('Email'),
          ),
          ListTile(
            leading: const Icon(Icons.phone),
            title: Text(user.phone),
            subtitle: const Text('Phone'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(user.website ?? 'No website'),
            subtitle: const Text('Website'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.location_city),
            title: Text(user.address.city),
            subtitle: Text(
              '${user.address.street}, '
              '${user.address.suite}, '
              '${user.address.zipcode}',
            ),
          ),
          ListTile(
            leading: const Icon(Icons.map),
            title: Text(
              '${user.address.geo.lat}, '
              '${user.address.geo.lng}',
            ),
            subtitle: const Text('Coordinates'),
          ),
          ListTile(
            leading: const Icon(Icons.business),
            title: Text(user.company.name),
            subtitle: Text(user.company.catchPhrase),
          ),
        ],
      ),
    );
  }
}
