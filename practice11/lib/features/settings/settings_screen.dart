import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/auth_model.dart';
import '../users/users_model.dart';
import 'settings_model.dart';
import '../profile/profile_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsModel>();
    final usersModel = context.watch<UsersModel>();

    final List<String> cities = [];

    for (final user in usersModel.items) {
      final city = user.address.city;

      if (!cities.contains(city)) {
        cities.add(city);
      }
    }

    cities.sort();

    String? selectedCity = settings.city;

    if (selectedCity != null && !cities.contains(selectedCity)) {
      selectedCity = null;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Dark mode'),
            subtitle: const Text('Enable dark theme'),
            value: settings.dark,
            onChanged: (value) {
              settings.setDark(value);
            },
          ),

          const SizedBox(height: 24),

          DropdownButtonFormField<String>(
            initialValue: selectedCity,
            decoration: const InputDecoration(
              labelText: 'Filter by city',
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
            onChanged: (value) {
              if (value == null || value.isEmpty) {
                settings.setCity(null);
              } else {
                settings.setCity(value);
              }
            },
          ),

          const SizedBox(height: 24),

          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('My Profile'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const ProfileScreen();
                  },
                ),
              );
            },
          ),

          const SizedBox(height: 32),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Sign out'),
            onTap: () async {
              final auth = context.read<AuthModel>();

              await auth.logout();

              if (!context.mounted) {
                return;
              }

              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
