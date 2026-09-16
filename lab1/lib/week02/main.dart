import 'catalogue.dart';
import 'data.dart';
import 'models.dart';
import 'shelf_state.dart';

void main() {
  final library = Library(
    items: rawBooks.map(Book.fromJson).toList(),
  );

  library.open();

  print('=== QUERIES ===');

  print('Titles: ${library.everyTitle}');

  print(
    'Books after 2010: '
    '${library.booksAfter2010.map((book) => book.title).toList()}',
  );

  print('Average pages: ${library.averagePageCount}');

  print('Books by author: ${library.booksByAuthor}');

  print('Distinct authors: ${library.distinctAuthorNames}');

  print(
    'Genres: '
    '${library.genres.map((genre) => genre.label).toSet()}',
  );

  print('\n=== REPORT ===');
  print(library.report);

  print('\n=== NULL SAFETY ===');
  print('Country of Design Patterns: '
      '${library.countryOf('Design Patterns')}');

  print('Country of Missing Book: '
      '${library.countryOf('Missing Book')}');

  print('\n=== RECORD ===');

  final stats = statsOf(library.books);

  print('Count: ${stats.count}');
  print('Average pages: ${stats.avgPages}');

  print('\n=== SHELF STATES ===');

  print(describe(const Empty()));
  print(describe(Ready(library.books)));
  print(describe(const Broken('Catalogue file is unavailable')));
}