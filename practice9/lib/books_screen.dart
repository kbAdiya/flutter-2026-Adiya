import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/book.dart';
import 'models/cart.dart';
import 'cart_badge.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() {
    return _BooksScreenState();
  }
}

class _BooksScreenState extends State<BooksScreen> {
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    debugPrint('BooksScreen build');

    final filteredBooks = books.where((book) {
      String title = book.title.toLowerCase();
      String author = book.author.toLowerCase();
      String search = searchText.toLowerCase();

      return title.contains(search) || author.contains(search);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Books'),
        actions: [const CartBadge()],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(65),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: const InputDecoration(
                hintText: 'Search books...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                filled: true,
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        children: filteredBooks.map((book) {
          debugPrint('row ${book.title}');

          return ListTile(
            title: Text(book.title),
            subtitle: Text(book.author),
            trailing: Consumer<Cart>(
              builder: (context, cart, child) {
                bool isAdded = cart.items.contains(book);

                if (isAdded) {
                  return const Text('Added');
                } else {
                  return OutlinedButton(
                    onPressed: () {
                      final bool ok = context.read<Cart>().add(book);

                      if (ok) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Added'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      }
                    },
                    child: const Text('Add'),
                  );
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
