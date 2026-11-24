import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/storage/secure_store.dart';

import 'user.dart';

class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({super.key, required this.user});

  final User user;

  Future<void> _open(BuildContext context, Uri uri) async {
    bool opened = false;

    try {
      opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      opened = false;
    }

    if (!context.mounted) return;

    if (!opened) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('No app can open this')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final website = user.website;

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
            onTap: () async {
              await _open(context, Uri(scheme: 'mailto', path: user.email));
            },
          ),
          ListTile(
            leading: const Icon(Icons.phone),
            title: Text(user.phone),
            subtitle: const Text('Phone'),
            onTap: () async {
              await _open(context, Uri(scheme: 'tel', path: user.phoneDigits));
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(website ?? 'No website'),
            subtitle: const Text('Website'),
            onTap: website == null
                ? null
                : () async {
                    final url =
                        website.startsWith('https://') ||
                            website.startsWith('http://')
                        ? website
                        : 'https://$website';

                    await _open(context, Uri.parse(url));
                  },
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
          if (kDebugMode) ...[
            const Divider(),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Copy token to clipboard'),
              onTap: () async {
                final token = await context.read<SecureStore>().readToken();

                if (token == null) return;

                await Clipboard.setData(ClipboardData(text: token));

                if (!context.mounted) return;

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Token copied')));
              },
            ),
          ],
        ],
      ),
    );
  }
}
