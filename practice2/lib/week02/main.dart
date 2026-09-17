import 'catalogue.dart';
import 'data.dart';
import 'models.dart';
import 'shelf_state.dart';

void main() {
  List<Book> books = rawBooks
      .map((json) => Book.fromJson(json))
      .toList();

  print('=== ALL BOOKS ===');

  for (Book book in books) {
    print('Title: ${book.title}');
    print('Year: ${book.year}');
    print('Pages: ${book.pages}');
    print('Author: ${book.author}');
    print('Genre: ${book.genre.label}');
    print('Description: ${book.description ?? 'No description'}');
    print('Long book: ${book.isLong}');
    print('Old book: ${book.isOld}');
    print('--------------------');
  }

  print('');

  Library library = Library(List<LibraryItem>.from(books));

  library.open();

  print('=== LIBRARY CATALOGUE ===');
  print('');

  print('Every title:');
  print(library.everyTitle());
  print('');

  print('Books after 2010:');
  print(library.booksAfter2010());
  print('');

  print('Average pages:');
  print(library.averagePages());
  print('');

  print('Books by author:');
  print(library.booksByAuthor());
  print('');

  print('Distinct authors:');
  print(library.distinctAuthors());
  print('');

  print('All genres:');
  print(library.allGenres());
  print('');

  print('Country of Clean Code:');
  print(library.countryOf('Clean Code'));
  print('');

  print('Country of Design Patterns:');
  print(library.countryOf('Design Patterns'));
  print('');

  print('Display:');
  print(library.display);
  print('');

  print('Report:');
  print(library.report());
  print('');

  print('Record stats:');
  ({int count, double avgPages}) stats = statsOf(books);
  print('Count: ${stats.count}');
  print('Average pages: ${stats.avgPages}');
  print('');

  ShelfState emptyState = Empty();
  ShelfState readyState = Ready(books);
  ShelfState brokenState = Broken('Unable to load shelf');

  print('Shelf states:');
  print(describe(emptyState));
  print(describe(readyState));
  print(describe(brokenState));
}