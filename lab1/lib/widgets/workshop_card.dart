
import 'package:flutter/material.dart';

import '../models/workshop.dart';
import '../utils/format.dart';

class WorkshopCard extends StatelessWidget {
  const WorkshopCard({
    super.key,
    required this.workshop,
    required this.onFavourite,
    required this.onTap,
  });

  final Workshop workshop;
  final VoidCallback onFavourite;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    String badge = '';

    if (workshop.isFull) {
      badge = 'FULL';
    } else if (workshop.freePlaces <= 5) {
      badge = '${workshop.freePlaces} left';
    }

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 27,
                    backgroundColor: workshop.category.color(scheme),
                    child: Icon(
                      workshop.category.icon,
                      color: scheme.onPrimary,
                    ),
                  ),
                  if (badge.isNotEmpty)
                    Positioned(
                      right: -9,
                      bottom: -10,
                      child: Badge(
                        label: Text(badge),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workshop.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      formatDate(workshop.when),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      workshop.place,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onFavourite,
                icon: Icon(
                  workshop.isFavourite
                      ? Icons.favorite
                      : Icons.favorite_border,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
