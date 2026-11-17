import 'package:flutter/material.dart';

import 'user.dart';

class UserDetailScreen extends StatelessWidget {
  final User user;

  const UserDetailScreen({super.key, required this.user});

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
          ),

          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('Phone'),
            subtitle: Text(user.phone),
            onTap: () {
              // Practice 12: url_launcher
            },
          ),

          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Website'),
            subtitle: Text(user.website ?? 'Not available'),
            onTap: () {
              // Practice 12: url_launcher
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
        ],
      ),
    );
  }
}
