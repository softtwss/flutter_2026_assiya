import '../models/event.dart';

/// Twelve VibeEvent entries with dates relative to today.
List<Event> seedEvents() {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  DateTime at(int days, int hour) =>
      today.add(Duration(days: days, hours: hour));

  return [
    Event(
      id: 'e1',
      title: 'K-Drama Night: Pick Our Next Series',
      category: EventCategory.kDramas,
      when: at(2, 19),
      place: 'Movie Lounge',
      limit: 25,
      names: const ['Asiya', 'Dana', 'Madina'],
      description: 'Watch together and vote for the next drama.',
    ),
    Event(
      id: 'e2',
      title: 'Flutter Mini Hackathon: Build Something Cool',
      category: EventCategory.tech,
      when: at(5, 10),
      place: 'Innovation Lab',
      limit: 40,
      names: const ['Nurlan', 'Madina', 'Arman', 'Zhanna'],
      description: 'Bring your laptop and build a small app.',
    ),
    // Mandatory: a 60-character title.
    Event(
      id: 'e3',
      title: 'The Ultimate Book Lovers and Reading Club Meetup',
      category: EventCategory.books,
      when: at(9, 11),
      place: 'City Library',
      limit: 30,
      names: const ['Saule', 'Erlan'],
      description: 'Share your favourite book and meet readers.',
    ),
    // Mandatory: an item at its limit.
    Event(
      id: 'e4',
      title: 'Basketball Night: Friendly Match',
      category: EventCategory.sport,
      when: at(3, 17),
      place: 'Sports Complex',
      limit: 5,
      names: const ['Asiya', 'Timur', 'Dias', 'Arman', 'Erlan'],
      description: 'A friendly match for beginners and regular players.',
    ),
    // Mandatory: a past item.
    Event(
      id: 'e5',
      title: 'Acoustic Music and Open Mic Evening',
      category: EventCategory.music,
      when: at(-6, 18),
      place: 'Indie Cafe',
      limit: 50,
      names: const ['Dana', 'Alina', 'Madina'],
      description: 'Live music, acoustic covers and open mic.',
    ),
    // Mandatory: online event.
    Event(
      id: 'e6',
      title: 'AI and Coding Study Session',
      category: EventCategory.tech,
      when: at(1, 20),
      place: 'https://meet.example.com/ai-study',
      limit: 100,
      online: true,
      names: const ['Zhanna', 'Nurlan'],
      description: 'Explore AI tools and solve coding challenges.',
    ),
    // Mandatory: no optional description.
    Event(
      id: 'e7',
      title: 'Sunday Morning Run Club',
      category: EventCategory.sport,
      when: at(1, 7),
      place: 'Central Park',
      limit: 30,
      names: const ['Saule'],
    ),
    // Three places left.
    Event(
      id: 'e8',
      title: 'Romance Book Club: Monthly Discussion',
      category: EventCategory.books,
      when: at(4, 15),
      place: 'Cozy Corner Cafe',
      limit: 12,
      names: const [
        'Dana',
        'Alina',
        'Madina',
        'Zhanna',
        'Saule',
        'Asiya',
        'Erlan',
        'Dias',
        'Arman',
      ],
      description: 'Discuss the book and share your favourite quotes.',
    ),
    Event(
      id: 'e9',
      title: 'K-Drama Quiz: Guess the Series',
      category: EventCategory.kDramas,
      when: at(12, 16),
      place: 'Community Room',
      limit: 35,
      names: const ['Timur', 'Dana'],
      description: 'Test your knowledge of Korean dramas.',
    ),
    Event(
      id: 'e10',
      title: 'Indie Music Discovery Session',
      category: EventCategory.music,
      when: at(7, 16),
      place: 'Music Studio',
      limit: 25,
      names: const ['Alina'],
      description: 'Bring three songs you think everyone should hear.',
    ),
    Event(
      id: 'e11',
      title: 'Beginner Boxing and Fitness Meetup',
      category: EventCategory.sport,
      when: at(-2, 14),
      place: 'Training Studio',
      limit: 32,
      names: const ['Arman', 'Dias', 'Erlan'],
      description: 'Introductory training. Comfortable sportswear required.',
    ),
    Event(
      id: 'e12',
      title: 'Online Book-to-Screen Discussion',
      category: EventCategory.books,
      when: at(6, 18),
      place: 'https://meet.example.com/book-screen',
      limit: 60,
      online: true,
      names: const ['Madina'],
      description: 'Compare a book with its screen adaptation.',
    ),
  ];
}
