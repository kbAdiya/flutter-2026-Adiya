
import 'package:flutter/material.dart';

import 'data/seed_data.dart';
import 'models/workshop.dart';
import 'screens/workshops_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dance Workshops',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Workshop> _workshops;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dance Workshops'),
      ),
      body: WorkshopsScreen(
        workshops: _workshops,
        onFavourite: _toggleFavourite,
        onOpen: (workshop) {},
        onCreate: () {},
      ),
    );
  }
}
