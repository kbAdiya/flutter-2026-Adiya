
import 'package:flutter/material.dart';

enum DanceCategory {
  kpop('K-pop', Icons.music_note),
  hiphop('Hip-hop', Icons.headphones),
  contemporary('Contemporary', Icons.self_improvement),
  ballet('Ballet', Icons.accessibility_new),
  jazzFunk('Jazz Funk', Icons.auto_awesome);

  const DanceCategory(this.label, this.icon);

  final String label;
  final IconData icon;

  Color color(ColorScheme scheme) {
    return switch (this) {
      DanceCategory.kpop => scheme.primary,
      DanceCategory.hiphop => scheme.secondary,
      DanceCategory.contemporary => scheme.tertiary,
      DanceCategory.ballet => scheme.primaryContainer,
      DanceCategory.jazzFunk => scheme.secondaryContainer,
    };
  }
}

class Workshop {
  const Workshop({
    required this.title,
    required this.category,
    required this.when,
    required this.limit,
    required List<String> participants,
    required this.isOnline,
    required this.place,
    this.description,
    this.isFavourite = false,
  }) : _participants = participants;

  final String title;
  final DanceCategory category;
  final DateTime when;
  final int limit;
  final List<String> _participants;
  final bool isOnline;
  final String place;
  final String? description;
  final bool isFavourite;

  List<String> get participants {
    return List.unmodifiable(_participants);
  }

  int get count {
    return _participants.length;
  }

  int get freePlaces {
    return limit - count;
  }

  bool get isFull {
    return count >= limit;
  }

  bool get isPast {
    return when.isBefore(DateTime.now());
  }

  bool contains(String name) {
    return _participants.contains(name);
  }

  ({int taken, int free}) get places {
    return (
    taken: count,
    free: freePlaces,
    );
  }

  Workshop.empty()
      : title = '',
        category = DanceCategory.kpop,
        when = DateTime.now().add(const Duration(days: 1)),
        limit = 20,
        _participants = const [],
        isOnline = false,
        place = '',
        description = null,
        isFavourite = false;

  Workshop copyWith({
    String? title,
    DanceCategory? category,
    DateTime? when,
    int? limit,
    List<String>? participants,
    bool? isOnline,
    String? place,
    String? description,
    bool clearDescription = false,
    bool? isFavourite,
  }) {
    String? newDescription = this.description;

    if (clearDescription) {
      newDescription = null;
    } else if (description != null) {
      newDescription = description;
    }

    return Workshop(
      title: title ?? this.title,
      category: category ?? this.category,
      when: when ?? this.when,
      limit: limit ?? this.limit,
      participants: List<String>.unmodifiable(
        participants ?? _participants,
      ),
      isOnline: isOnline ?? this.isOnline,
      place: place ?? this.place,
      description: newDescription,
      isFavourite: isFavourite ?? this.isFavourite,
    );
  }
}
