import 'models.dart';

class Library {
  final List<LibraryItem> items;

  Library(this.items);

  late final DateTime openedAt;

  String? _cachedReport;

  void add(LibraryItem item) {
    items.add(item);
  }

  Book? findByTitle(String title) {
    for (LibraryItem item in items) {
      if (item is Book && item.title == title) {
        return item;
      }
    }

    return null;
  }

  String countryOf(String title) {
    Book? book = findByTitle(title);

    String country = book?.author.country ?? 'Unknown';

    return country;
  }

  void open() {
    openedAt = DateTime.now();
  }

  String report() {
    _cachedReport ??= 'Library contains ${items.length} items';

    return _cachedReport ?? 'No report';
  }

  List<String> everyTitle() =>
      items.map((item) => item.title).toList();

  List<Book> booksAfter2010() =>
      items.whereType<Book>().where((book) => book.year > 2010).toList();

  // fold is used because it works safely with an empty list,
  // while reduce would throw an error.

  double averagePages() =>
      items.whereType<Book>().fold(0, (sum, book) => sum + book.pages) /
          items.whereType<Book>().length;

  Map<String, int> booksByAuthor() =>
      items.whereType<Book>().fold({}, (map, book) {
        map[book.author.name] = (map[book.author.name] ?? 0) + 1;
        return map;
      });

  Set<String> distinctAuthors() =>
      items.whereType<Book>().map((book) => book.author.name).toSet();

  Set<Genre> allGenres() =>
      items.whereType<Book>().map((book) => book.genre).toSet();

  List<String> get display => [
    'CATALOGUE',
    for (LibraryItem item in items) '${item.title} (${item.year})',
    ...items
        .whereType<Book>()
        .map((book) => book.author.name),
    if (items.whereType<Book>().any((book) => book.pages == 0))
      '(incomplete data)',
  ];
}