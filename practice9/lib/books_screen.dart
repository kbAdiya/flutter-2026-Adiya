import 'package:flutter/material.dart';
import 'main.dart';
import 'cart_badge.dart';

class BooksScreen extends StatelessWidget {
  final List<Book> cart;
  final void Function(Book) onAdd;

  const BooksScreen({
    super.key,
    required this.cart,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint('BooksScreen build');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Books'),
        actions: [
          CartBadge(
            count: cart.length,
            total: cart.fold(0, (sum, book) {
              return sum + book.price;
            }),
          ),
        ],
      ),
      body: ListView(
        children: books.map((book) {
          debugPrint('row ${book.title}');

          bool isAdded = cart.contains(book);

          return ListTile(
            title: Text(book.title),
            subtitle: Text(book.author),
            trailing: isAdded
                ? const Text('Added')
                : OutlinedButton(
              onPressed: () {
                onAdd(book);
              },
              child: const Text('Add'),
            ),
          );
        }).toList(),
      ),
    );
  }
}