
import 'dart:async';

import 'package:flutter/material.dart';

import '../models/countdown.dart';
import '../models/workshop.dart';
import '../routes.dart';
import '../utils/format.dart';
import '../widgets/empty_state.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({
    super.key,
    required this.arguments,
  });

  final DetailArguments arguments;

  @override
  State<DetailScreen> createState() {
    return _DetailScreenState();
  }
}

class _DetailScreenState extends State<DetailScreen> {
  late Workshop _workshop;
  Timer? _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();

    _workshop = widget.arguments.workshop;

    _timer = Timer.periodic(
      const Duration(minutes: 1),
          (timer) {
        setState(() {
          _now = DateTime.now();
        });
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final name = widget.arguments.profileName.trim();

    final (taken: taken, free: free) = _workshop.places;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_workshop.title),
        ),
        body: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 170,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/dance.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  left: 12,
                  top: 12,
                  child: Chip(
                    avatar: Icon(_workshop.category.icon),
                    label: Text(_workshop.category.label),
                  ),
                ),
                Positioned(
                  right: 12,
                  bottom: 12,
                  child: Chip(
                    label: Text(
                      countdownText(
                        countdownFor(_workshop.when, _now),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            TabBar(
              tabs: [
                const Tab(text: 'About'),
                Tab(text: 'People ($taken)'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      ListTile(
                        leading: const Icon(Icons.calendar_today),
                        title: Text(formatDate(_workshop.when)),
                      ),
                      ListTile(
                        leading: const Icon(Icons.place),
                        title: Text(_workshop.place),
                        subtitle: Text(
                          _workshop.isOnline
                              ? 'Online link'
                              : 'In person',
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.people),
                        title: Text('$taken taken · $free free'),
                      ),
                      if (_workshop.description != null)
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            _workshop.description ?? '',
                          ),
                        ),
                    ],
                  ),
                  _workshop.participants.isEmpty
                      ? const EmptyState(
                    message: 'Nobody has joined yet',
                    icon: Icons.people_outline,
                  )
                      : ListView(
                    children: [
                      for (final person in _workshop.participants)
                        ListTile(
                          title: Text(
                            person,
                            style: person == name
                                ? TextStyle(
                              fontWeight: FontWeight.bold,
                              color: scheme.primary,
                            )
                                : null,
                          ),
                          trailing: person == name
                              ? const Text('You')
                              : null,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
