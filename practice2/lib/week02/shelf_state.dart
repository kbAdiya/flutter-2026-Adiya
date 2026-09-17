import 'models.dart';

sealed class ShelfState {}

class Empty extends ShelfState {}

class Ready extends ShelfState {
  final List<Book> books;

  Ready(this.books);
}

class Broken extends ShelfState {
  final String message;

  Broken(this.message);
}

String describe(ShelfState state) {
  return switch (state) {
    Empty() => 'Shelf is empty',
    Ready(books: final books) => 'Shelf is ready: ${books.length} books',
    Broken(message: final message) => 'Shelf is broken: $message',
  };
}

({int count, double avgPages}) statsOf(List<Book> books) {
  double totalPages = books.fold(
    0,
        (sum, book) => sum + book.pages,
  );

  double averagePages = books.isEmpty ? 0 : totalPages / books.length;

  return (
  count: books.length,
  avgPages: averagePages,
  );
}