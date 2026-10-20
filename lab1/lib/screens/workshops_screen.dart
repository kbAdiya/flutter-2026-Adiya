import 'package:flutter/material.dart';

import '../models/workshop.dart';
import '../widgets/empty_state.dart';
import '../widgets/workshop_card.dart';

class WorkshopsScreen extends StatefulWidget {
  const WorkshopsScreen({
    super.key,
    required this.workshops,
    required this.onFavourite,
    required this.onOpen,
    required this.onCreate,
  });

  final List<Workshop> workshops;
  final ValueChanged<Workshop> onFavourite;
  final ValueChanged<Workshop> onOpen;
  final VoidCallback onCreate;

  @override
  State<WorkshopsScreen> createState() {
    return _WorkshopsScreenState();
  }
}

class _WorkshopsScreenState extends State<WorkshopsScreen> {
  final _searchController = TextEditingController();

  String _search = '';
  DanceCategory? _category;
  bool _showPast = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clear() {
    _searchController.clear();

    setState(() {
      _search = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.workshops.where((workshop) {
      final searchMatch = workshop.title.toLowerCase().contains(
        _search.toLowerCase(),
      );

      final categoryMatch = _category == null || workshop.category == _category;

      final dateMatch = _showPast || !workshop.isPast;

      return searchMatch && categoryMatch && dateMatch;
    }).toList();

    filtered.sort((a, b) {
      if (a.isPast != b.isPast) {
        if (a.isPast) {
          return 1;
        } else {
          return -1;
        }
      }

      return a.when.compareTo(b.when);
    });

    Widget card(Workshop workshop) {
      return WorkshopCard(
        workshop: workshop,
        onFavourite: () {
          widget.onFavourite(workshop);
        },
        onTap: () {
          widget.onOpen(workshop);
        },
      );
    }

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search workshops',
                prefixIcon: const Icon(Icons.search),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                border: const OutlineInputBorder(),
                suffixIcon: _search.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _clear,
                      ),
              ),
              onChanged: (value) {
                setState(() {
                  _search = value;
                });
              },
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                ChoiceChip(
                  label: const Text('All'),
                  selected: _category == null,
                  onSelected: (_) {
                    setState(() {
                      _category = null;
                    });
                  },
                ),
                const SizedBox(width: 8),
                for (final category in DanceCategory.values) ...[
                  ChoiceChip(
                    label: Text(category.label),
                    selected: _category == category,
                    onSelected: (_) {
                      setState(() {
                        _category = category;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                ],
                FilterChip(
                  label: const Text('Show past workshops'),
                  selected: _showPast,
                  onSelected: (value) {
                    setState(() {
                      _showPast = value;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? EmptyState(
                    message: 'No workshops found',
                    icon: Icons.search_off,
                    buttonText: 'Clear filters',
                    onPressed: _clear,
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < 600) {
                        return ListView.separated(
                          padding: const EdgeInsets.all(12),
                          itemCount: filtered.length,
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 8);
                          },
                          itemBuilder: (context, index) {
                            return card(filtered[index]);
                          },
                        );
                      }

                      return GridView.builder(
                        padding: const EdgeInsets.all(12),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 360,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              mainAxisExtent: 132,
                            ),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          return card(filtered[index]);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: widget.onCreate,
        child: const Icon(Icons.add),
      ),
    );
  }
}
