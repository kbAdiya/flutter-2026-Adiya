import 'dart:async';

import 'package:flutter/material.dart';

import '../models/countdown.dart';
import '../models/workshop.dart';
import '../routes.dart';
import '../utils/format.dart';
import '../widgets/empty_state.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.arguments});

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

    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {
        _now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _update(Workshop workshop) {
    widget.arguments.onUpdate(workshop);

    setState(() {
      _workshop = workshop;
    });
  }

  Future<void> _edit() async {
    final result = await Navigator.of(context).pushNamed<Workshop>(
      Routes.form,
      arguments: FormArguments(workshop: _workshop),
    );

    if (result == null || !mounted) {
      return;
    }

    _update(result);
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete workshop?'),
          content: Text(_workshop.title),
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
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) {
      return;
    }

    widget.arguments.onDelete(_workshop);
    Navigator.of(context).pop();
  }

  Future<void> _joinOrLeave() async {
    final name = widget.arguments.profileName.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Enter your name in Profile first'),
          action: SnackBarAction(
            label: 'Profile',
            onPressed: () {
              widget.arguments.goToProfile();
              Navigator.of(context).pop();
            },
          ),
        ),
      );
      return;
    }

    final joined = _workshop.contains(name);

    if (!joined && (_workshop.isFull || _workshop.isPast)) {
      return;
    }

    if (joined) {
      final names = _workshop.participants.where((person) {
        return person != name;
      }).toList();

      _update(_workshop.copyWith(participants: names));
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(joined ? 'Leave workshop?' : 'Join workshop?'),
          content: Text(_workshop.title),
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
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) {
      return;
    }
    
    final names = [..._workshop.participants, name];

    _update(_workshop.copyWith(participants: names));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final name = widget.arguments.profileName.trim();
    final joined = name.isNotEmpty && _workshop.contains(name);

    final (taken: taken, free: free) = _workshop.places;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_workshop.title),
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  _edit();
                }

                if (value == 'delete') {
                  _delete();
                }
              },
              itemBuilder: (context) {
                return const [
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                ];
              },
            ),
          ],
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
                      countdownText(countdownFor(_workshop.when, _now)),
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
                          _workshop.isOnline ? 'Online link' : 'In person',
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.people),
                        title: Text('$taken taken · $free free'),
                      ),
                      if (_workshop.description != null)
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(_workshop.description ?? ''),
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
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: joined || (!_workshop.isFull && !_workshop.isPast)
                      ? _joinOrLeave
                      : null,
                  child: Text(joined ? 'Leave' : 'Join'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
