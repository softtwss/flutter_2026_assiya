import 'package:flutter/material.dart';

/// Each category has a label and an icon.
enum EventCategory {
  sport('Sport', Icons.sports_basketball),
  books('Books', Icons.menu_book),
  tech('IT', Icons.computer),
  music('Music', Icons.music_note),
  kDramas('K-Dramas', Icons.movie_outlined);

  const EventCategory(this.label, this.icon);

  final String label;
  final IconData icon;

  // R2: Exhaustive switch expression using ColorScheme roles.
  Color color(ColorScheme scheme) => switch (this) {
        EventCategory.sport => scheme.primary,
        EventCategory.books => scheme.secondary,
        EventCategory.tech => scheme.tertiary,
        EventCategory.music => scheme.error,
        EventCategory.kDramas => scheme.primaryContainer,
      };
}

/// R1: Immutable event model.
@immutable
class Event {
  const Event({
    required this.id,
    required this.title,
    required this.category,
    required this.when,
    required this.place,
    required this.limit,
    this.names = const [],
    this.online = false,
    this.description,
    this.favourite = false,
  });

  // R3: Default values for a new event.
  factory Event.empty() => Event(
        id: '',
        title: '',
        category: EventCategory.tech,
        when: DateTime.now().add(const Duration(days: 1)),
        place: '',
        limit: 50,
      );

  final String id;
  final String title;
  final EventCategory category;
  final DateTime when;
  final String place;
  final int limit;
  final List<String> names;
  final bool online;
  final String? description;
  final bool favourite;

  // R4: Derived values are getters.
  int get count => names.length;

  int get free => (limit - count).clamp(0, limit);

  bool get isFull => count >= limit;

  bool get isPast => when.isBefore(DateTime.now());

  bool contains(String name) => names.contains(name);

  // R5: Record getter.
  ({int taken, int free}) get places => (
        taken: count,
        free: free,
      );

  Event copyWith({
    String? id,
    String? title,
    EventCategory? category,
    DateTime? when,
    String? place,
    int? limit,
    List<String>? names,
    bool? online,
    String? description,
    bool clearDescription = false,
    bool? favourite,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      when: when ?? this.when,
      place: place ?? this.place,
      limit: limit ?? this.limit,
      names: List.unmodifiable(names ?? this.names),
      online: online ?? this.online,
      description: clearDescription ? null : description ?? this.description,
      favourite: favourite ?? this.favourite,
    );
  }
}

/// R1 and R3: Immutable profile model.
@immutable
class Profile {
  const Profile({
    required this.name,
    required this.group,
  });

  const Profile.empty()
      : name = '',
        group = '';

  final String name;
  final String group;

  Profile copyWith({
    String? name,
    String? group,
  }) {
    return Profile(
      name: name ?? this.name,
      group: group ?? this.group,
    );
  }
}
