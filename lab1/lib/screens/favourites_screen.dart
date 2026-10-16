
import 'package:flutter/material.dart';

import '../models/workshop.dart';
import '../widgets/empty_state.dart';
import '../widgets/workshop_card.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({
    super.key,
    required this.workshops,
    required this.onFavourite,
    required this.onOpen,
  });

  final List<Workshop> workshops;
  final ValueChanged<Workshop> onFavourite;
  final ValueChanged<Workshop> onOpen;

  @override
  Widget build(BuildContext context) {
    final favourites = workshops.where((workshop) {
      return workshop.isFavourite;
    }).toList();

    if (favourites.isEmpty) {
      return const EmptyState(
        message: 'No favourites yet',
        icon: Icons.favorite_border,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: favourites.length,
      separatorBuilder: (context, index) {
        return const SizedBox(height: 8);
      },
      itemBuilder: (context, index) {
        final workshop = favourites[index];

        return WorkshopCard(
          workshop: workshop,
          onFavourite: () {
            onFavourite(workshop);
          },
          onTap: () {
            onOpen(workshop);
          },
        );
      },
    );
  }
}
