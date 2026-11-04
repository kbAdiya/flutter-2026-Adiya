import 'package:flutter/material.dart';
import 'main.dart';

class CartScreen extends StatelessWidget {
  final List<Book> items;
  final void Function(Book) onRemove;

  const CartScreen({
    super.key,
    required this.items,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    int total = items.fold(0, (sum, book) {
      return sum + book.price;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: items.map((book) {
                return ListTile(
                  title: Text(book.title),
                  subtitle: Text('${book.price} ₸'),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      onRemove(book);
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Total: $total ₸',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}