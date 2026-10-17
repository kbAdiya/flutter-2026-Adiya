
import 'package:flutter/material.dart';

import '../models/profile.dart';
import '../models/workshop.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.profile,
    required this.workshops,
    required this.onProfileChanged,
    required this.themeMode,
    required this.onThemeChanged,
  });

  final Profile profile;
  final List<Workshop> workshops;
  final ValueChanged<Profile> onProfileChanged;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;

  @override
  State<ProfileScreen> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _groupController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.profile.name,
    );

    _groupController = TextEditingController(
      text: widget.profile.group,
    );
  }

  @override
  void didUpdateWidget(ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.profile.name != oldWidget.profile.name) {
      _nameController.text = widget.profile.name;
    }

    if (widget.profile.group != oldWidget.profile.group) {
      _groupController.text = widget.profile.group;
    }
  }

  void _saveName(String value) {
    widget.onProfileChanged(
      widget.profile.copyWith(
        name: value.trim(),
      ),
    );
  }

  void _saveGroup(String value) {
    if (!RegExp(r'^[A-Za-z]{2,5}-\d{4}$').hasMatch(value.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Group format: IT-2302'),
        ),
      );
      return;
    }

    widget.onProfileChanged(
      widget.profile.copyWith(
        group: value.trim(),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _groupController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.profile.name.trim();

    int joined = 0;

    if (name.isNotEmpty) {
      joined = widget.workshops.where((workshop) {
        return workshop.contains(name);
      }).length;
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Your profile',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _nameController,
          textInputAction: TextInputAction.done,
          onSubmitted: _saveName,
          decoration: const InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _groupController,
          textInputAction: TextInputAction.done,
          onSubmitted: _saveGroup,
          decoration: const InputDecoration(
            labelText: 'Group (e.g. IT-2302)',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        Text('You are on $joined lists'),
        const SizedBox(height: 24),
        Text(
          'Theme',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Wrap(
          spacing: 8,
          children: [
            for (final mode in ThemeMode.values)
              ChoiceChip(
                label: Text(mode.name),
                selected: widget.themeMode == mode,
                onSelected: (_) {
                  widget.onThemeChanged(mode);
                },
              ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Press Done on the keyboard to save each field.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
