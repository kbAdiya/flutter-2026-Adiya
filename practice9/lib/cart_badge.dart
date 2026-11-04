import 'package:flutter/material.dart';

class CartBadge extends StatelessWidget {
  final int count;
  final int total;

  const CartBadge({
    super.key,
    required this.count,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.of(context).pushNamed('/cart');
      },
      icon: Badge(
        label: Text('$count'),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.shopping_cart),
            Text(
              '$total ₸',
              style: const TextStyle(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}