
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
    _replace(
      workshop,
      workshop.copyWith(
        isFavourite: !workshop.isFavourite,
      ),
    );
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
    final result = await Navigator.of(context).pushNamed<Workshop>(
      Routes.form,
      arguments: const FormArguments(),
    );

    if (result == null || !mounted) {
      return;
    }

    setState(() {
      _workshops.add(result);
    });
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
            onCreate: _create,
          ),
          FavouritesScreen(
            workshops: _workshops,
            onFavourite: _toggleFavourite,
            onOpen: _open,
          ),
          Center(
            child: Text(
              _profile.name.isEmpty ? 'Profile' : _profile.name,
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
