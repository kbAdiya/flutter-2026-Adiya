
import 'package:flutter/material.dart';

import 'data/seed_data.dart';
import 'models/workshop.dart';
import 'widgets/workshop_card.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dance Workshops'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _workshops.length,
        itemBuilder: (context, index) {
          final workshop = _workshops[index];

          return WorkshopCard(
            workshop: workshop,
            onFavourite: () {
              setState(() {
                _workshops[index] = workshop.copyWith(
                  isFavourite: !workshop.isFavourite,
                );
              });
            },
            onTap: () {},
          );
        },
      ),
    );
  }
}
