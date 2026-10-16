import 'package:flutter/material.dart';

import 'models/book.dart';
import 'detail_screen.dart';
import 'add_book_screen.dart';
import 'widgets/book_tile.dart';

enum Filter { all, unread, read }

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() {
    return _LibraryScreenState();
  }
}

class _LibraryScreenState extends State<LibraryScreen> {
  final List<Book> _books = [...seed];

  Filter _filter = Filter.all;

  List<Book> get _visible {
    return switch (_filter) {
      Filter.all => _books,
      Filter.unread => unread(_books),
      Filter.read => _books.where((book) => book.read).toList(),
    };
  }

  Future<void> _openDetails(Book book) async {
    final action = await Navigator.of(context).push<BookAction>(
      MaterialPageRoute(
        builder: (context) {
          return DetailScreen(book: book);
        },
      ),
    );

    if (!mounted) {
      return;
    }

    switch (action) {
      case null:
        break;

      case BookAction.toggleRead:
        setState(() {
          book.read = !book.read;
        });

      case BookAction.delete:
        setState(() {
          _books.remove(book);
        });
    }
  }

  Future<void> _addBook() async {
    final book = await Navigator.of(context).push<Book>(
      MaterialPageRoute(
        builder: (context) {
          return const AddBookScreen();
        },
      ),
    );

    if (!mounted) {
      return;
    }

    if (book == null) {
      return;
    }

    setState(() {
      _books.add(book);
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text('Reading list (${_visible.length})')),

      floatingActionButton: FloatingActionButton(
        onPressed: _addBook,
        child: const Icon(Icons.add),
      ),

      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '${_books.length}',
                          style: textTheme.headlineSmall,
                        ),
                        Text('Books', style: textTheme.bodySmall),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '${totalPages(_books)}',
                          style: textTheme.headlineSmall,
                        ),
                        Text('Pages', style: textTheme.bodySmall),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '${unread(_books).length}',
                          style: textTheme.headlineSmall,
                        ),
                        Text('Unread', style: textTheme.bodySmall),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ChoiceChip(
                  label: const Text('All'),
                  selected: _filter == Filter.all,
                  onSelected: (selected) {
                    setState(() {
                      _filter = Filter.all;
                    });
                  },
                ),

                ChoiceChip(
                  label: const Text('Unread'),
                  selected: _filter == Filter.unread,
                  onSelected: (selected) {
                    setState(() {
                      _filter = Filter.unread;
                    });
                  },
                ),

                ChoiceChip(
                  label: const Text('Read'),
                  selected: _filter == Filter.read,
                  onSelected: (selected) {
                    setState(() {
                      _filter = Filter.read;
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: _visible.length,
              itemBuilder: (context, index) {
                final book = _visible[index];

                return BookTile(
                  book: book,
                  onTap: () {
                    _openDetails(book);
                  },
                  onToggle: () {
                    setState(() {
                      book.read = !book.read;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
