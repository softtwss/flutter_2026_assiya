import 'models.dart';

class Library {
  final List<LibraryItem> items;
  String? _cachedReport;

  late final DateTime openedAt;

  Library({
    List<LibraryItem>? items,
  }) : items = [...?items];

  void add(LibraryItem item) {
    items.add(item);
    _cachedReport = null;
  }

  Book? findByTitle(String title) {
    for (final item in items) {
      if (item is Book && item.title == title) {
        return item;
      }
    }

    return null;
  }

  String countryOf(String title) =>
      findByTitle(title)?.author.country ?? 'unknown';

  void open() {
    openedAt = DateTime.now();
  }

  List<Book> get books => items.whereType<Book>().toList();

  List<String> get everyTitle =>
      books.map((book) => book.title).toList();

  List<Book> get booksAfter2010 =>
      books.where((book) => book.year > 2010).toList();

  // fold is used instead of reduce because reduce throws on an empty iterable.
  double get averagePageCount =>
      books.isEmpty
          ? 0
          : books.fold<int>(
                0,
                (sum, book) => sum + book.pages,
              ) /
              books.length;

  Map<String, int> get booksByAuthor =>
      books.fold<Map<String, int>>(
        {},
        (counts, book) {
          counts[book.author.name] =
              (counts[book.author.name] ?? 0) + 1;
          return counts;
        },
      );

  Set<String> get distinctAuthorNames =>
      books.map((book) => book.author.name).toSet();

  Set<Genre> get genres =>
      books.map((book) => book.genre).toSet();

  List<String> get displayList => [
        'CATALOGUE',
        for (final book in books) '${book.title} (${book.year})',
        ...distinctAuthorNames,
        if (books.any((book) => book.pages == 0))
          '(incomplete data)',
      ];

  String get report => _cachedReport ??= displayList.join('\n');
}