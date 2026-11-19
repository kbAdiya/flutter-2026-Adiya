import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/storage/secure_store.dart';

import 'user.dart';

class UserDetailScreen extends StatelessWidget {
  final User user;

  const UserDetailScreen({super.key, required this.user});

  Future<void> _openUrl(BuildContext context, Uri uri) async {
    try {
      final bool success = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!context.mounted) {
        return;
      }

      if (!success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('No app can open this')));
      }
    } catch (error) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('No app can open this')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(user.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Personal Information',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          ListTile(
            leading: const Icon(Icons.badge),
            title: const Text('ID'),
            subtitle: Text(user.id.toString()),
          ),

          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Name'),
            subtitle: Text(user.name),
          ),

          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Username'),
            subtitle: Text(user.username),
          ),

          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('Email'),
            subtitle: Text(user.email),
            onTap: () async {
              final Uri uri = Uri(scheme: 'mailto', path: user.email);

              await _openUrl(context, uri);
            },
          ),

          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('Phone'),
            subtitle: Text(user.phone),
            onTap: () async {
              final Uri uri = Uri(scheme: 'tel', path: user.phoneDigits);

              await _openUrl(context, uri);
            },
          ),

          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Website'),
            subtitle: Text(user.website ?? 'Not available'),
            onTap: user.website == null
                ? null
                : () async {
                    final String website = user.website!;

                    String url = website;

                    if (!url.startsWith('https://') &&
                        !url.startsWith('http://')) {
                      url = 'https://$url';
                    }

                    final Uri uri = Uri.parse(url);

                    await _openUrl(context, uri);
                  },
          ),

          const Divider(height: 32),

          const Text(
            'Address',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          ListTile(
            title: const Text('Street'),
            subtitle: Text(user.address.street),
          ),

          ListTile(
            title: const Text('Suite'),
            subtitle: Text(user.address.suite),
          ),

          ListTile(
            title: const Text('City'),
            subtitle: Text(user.address.city),
          ),

          ListTile(
            title: const Text('Zipcode'),
            subtitle: Text(user.address.zipcode),
          ),

          ListTile(
            title: const Text('Latitude'),
            subtitle: Text(user.address.geo.lat.toString()),
          ),

          ListTile(
            title: const Text('Longitude'),
            subtitle: Text(user.address.geo.lng.toString()),
          ),

          const Divider(height: 32),

          const Text(
            'Company',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          ListTile(
            title: const Text('Company Name'),
            subtitle: Text(user.company.name),
          ),

          ListTile(
            title: const Text('Catch Phrase'),
            subtitle: Text(user.company.catchPhrase),
          ),

          ListTile(
            title: const Text('Business'),
            subtitle: Text(user.companyBs),
          ),

          if (kDebugMode)
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Copy token to clipboard'),
              onTap: () async {
                final store = context.read<SecureStore>();

                final token = await store.readToken();

                if (!context.mounted) {
                  return;
                }

                if (token == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No token found')),
                  );
                  return;
                }

                await Clipboard.setData(ClipboardData(text: token));

                if (!context.mounted) {
                  return;
                }

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Token copied')));
              },
            ),
        ],
      ),
    );
  }
}
