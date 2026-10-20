import 'package:flutter/material.dart';

import '../data/seed_data.dart';
import '../models/profile.dart';
import '../models/workshop.dart';
import '../routes.dart';

import 'favourites_screen.dart';
import 'profile_screen.dart';
import 'workshops_screen.dart';

class Shell extends StatefulWidget {
  const Shell({
    super.key,
    required this.themeMode,
    required this.onThemeChanged,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;

  @override
  State<Shell> createState() {
    return _ShellState();
  }
}

class _ShellState extends State<Shell> {
  int _selectedTab = 0;

  late List<Workshop> _workshops;
  Profile _profile = const Profile.empty();

  @override
  void initState() {
    super.initState();
    _workshops = createSeedWorkshops();
  }

  void _goToProfile() {
    setState(() {
      _selectedTab = 2;
    });
  }

  void _replace(Workshop oldItem, Workshop newItem) {
    final index = _workshops.indexOf(oldItem);

    if (index == -1) {
      return;
    }

    setState(() {
      _workshops[index] = newItem;
    });
  }

  void _toggleFavourite(Workshop workshop) {
    _replace(workshop, workshop.copyWith(isFavourite: !workshop.isFavourite));
  }

  void _delete(Workshop workshop) {
    setState(() {
      _workshops.remove(workshop);
    });
  }

  void _open(Workshop workshop) {
    var current = workshop;

    Navigator.of(context).pushNamed(
      Routes.detail,
      arguments: DetailArguments(
        workshop: workshop,
        profileName: _profile.name,
        goToProfile: _goToProfile,
        onUpdate: (updated) {
          _replace(current, updated);
          current = updated;
        },
        onDelete: _delete,
      ),
    );
  }

  Future<void> _create() async {
    final result = await Navigator.of(context)
        .pushNamed<Workshop>(Routes.form, arguments: const FormArguments());

    if (result == null || !mounted) {
      return;
    }

    setState(() {
      _workshops.add(result);
    });
  }

  Future<void> _about() async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('About'),
          content: const Text('Dance Workshops - Flutter Lab 1. '),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _reset() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Reset data?'),
          content: const Text(
            'Restore all original workshops and clear your profile?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) {
      return;
    }

    setState(() {
      _workshops = createSeedWorkshops();
      _profile = const Profile.empty();
      _selectedTab = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dance Workshops')),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: Center(child: Text('Dance Workshops'))),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
              onTap: () {
                Navigator.of(context).pop();
                _about();
              },
            ),
            ListTile(
              leading: const Icon(Icons.restore),
              title: const Text('Reset data'),
              onTap: () {
                Navigator.of(context).pop();
                _reset();
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          WorkshopsScreen(
            workshops: _workshops,
            onFavourite: _toggleFavourite,
            onOpen: _open,
            onCreate: _create,
          ),
          FavouritesScreen(
            workshops: _workshops,
            onFavourite: _toggleFavourite,
            onOpen: _open,
          ),
          ProfileScreen(
            profile: _profile,
            workshops: _workshops,
            onProfileChanged: (profile) {
              setState(() {
                _profile = profile;
              });
            },
            themeMode: widget.themeMode,
            onThemeChanged: widget.onThemeChanged,
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        height: 60,
        selectedIndex: _selectedTab,
        onDestinationSelected: (index) {
          setState(() {
            _selectedTab = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.list), label: 'Workshops'),
          NavigationDestination(
            icon: Icon(Icons.favorite),
            label: 'Favourites',
          ),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
