class Author {
  final String name;
  final String? country;

  const Author({
    required this.name,
    this.country,
  });

  @override
  String toString() {
    if (country == null) {
      return name;
    } else {
      return '$name ($country)';
    }
  }
}

enum Genre {
  craft('Craft'),
  theory('Theory'),
  unknown('Unknown');

  final String label;

  const Genre(this.label);

  static Genre fromString(String? raw) {
    if (raw == 'craft') {
      return Genre.craft;
    }

    if (raw == 'theory') {
      return Genre.theory;
    }

    return Genre.unknown;
  }
}

abstract class LibraryItem {
  final String title;
  final int year;

  const LibraryItem({
    required this.title,
    required this.year,
  });

  String describe();

  bool get isOld {
    return year < 2000;
  }
}

class Magazine extends LibraryItem {
  final int issue;

  const Magazine({
    required super.title,
    required super.year,
    required this.issue,
  });

  @override
  String describe() {
    return 'Magazine: $title ($year), issue $issue';
  }
}
mixin Borrowable on LibraryItem {
  String borrowLabel() {
    return 'Borrow: $title';
  }
}
class Book extends LibraryItem with Borrowable {
  final int pages;
  final Author author;
  final Genre genre;
  final String? description;

  const Book({
    required super.title,
    required super.year,
    required this.pages,
    required this.author,
    required this.genre,
    this.description,
  });

  Book.missing()
      : pages = 0,
        author = const Author(name: 'Unknown'),
        genre = Genre.unknown,
        description = null,
        super(title: 'Unknown', year: 0);

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['title'] ?? 'Unknown',
      year: json['year'] ?? 0,
      pages: json['pages'] ?? 0,
      author: Author(
        name: json['author'] ?? 'Unknown',
        country: json['country'],
      ),
      genre: Genre.fromString(json['genre']),
      description: json['description'],
    );
  }

  bool get isLong {
    return pages > 400;
  }

  Book copyWith({
    String? title,
    int? year,
    int? pages,
    Author? author,
    Genre? genre,
    String? description,
  }) {
    return Book(
      title: title ?? this.title,
      year: year ?? this.year,
      pages: pages ?? this.pages,
      author: author ?? this.author,
      genre: genre ?? this.genre,
      description: description ?? this.description,
    );
  }

  @override
  String describe() {
    return 'Book: $title ($year)';
  }

  @override
  String toString() {
    return '$title ($year) - $author';
  }
}

class Ghost implements LibraryItem {
  @override
  final String title;

  @override
  final int year;

  const Ghost({
    required this.title,
    required this.year,
  });

  @override
  String describe() {
    return 'Ghost: $title ($year)';
  }

  @override
  bool get isOld {
    return year < 2000;
  }
}


