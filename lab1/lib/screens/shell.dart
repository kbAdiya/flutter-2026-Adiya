
import 'package:flutter/material.dart';

import '../data/seed_data.dart';
import '../models/profile.dart';
import '../models/workshop.dart';
import '../routes.dart';

import 'favourites_screen.dart';
import 'workshops_screen.dart';

class Shell extends StatefulWidget {
  const Shell({super.key});

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

  void _toggleFavourite(Workshop workshop) {
    final index = _workshops.indexOf(workshop);

    if (index == -1) {
      return;
    }

    setState(() {
      _workshops[index] = workshop.copyWith(
        isFavourite: !workshop.isFavourite,
      );
    });
  }

  void _open(Workshop workshop) {
    Navigator.of(context).pushNamed(
      Routes.detail,
      arguments: DetailArguments(
        workshop: workshop,
        profileName: _profile.name,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dance Workshops'),
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          WorkshopsScreen(
            workshops: _workshops,
            onFavourite: _toggleFavourite,
            onOpen: _open,
            onCreate: () {},
          ),
          FavouritesScreen(
            workshops: _workshops,
            onFavourite: _toggleFavourite,
            onOpen: _open,
          ),
          Center(
            child: Text(
              _profile.name.isEmpty
                  ? 'Profile'
                  : _profile.name,
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedTab,
        onDestinationSelected: (index) {
          setState(() {
            _selectedTab = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.list),
            label: 'Workshops',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite),
            label: 'Favourites',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
