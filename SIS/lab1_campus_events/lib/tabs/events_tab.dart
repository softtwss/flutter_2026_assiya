import 'package:flutter/material.dart';

import '../models/event.dart';
import '../widgets/empty_state.dart';
import '../widgets/event_list.dart';

/// R21: search + category chips + past filter.
class EventsTab extends StatefulWidget {
  const EventsTab({
    super.key,
    required this.events,
    required this.onOpen,
    required this.onFavourite,
  });

  final List<Event> events;
  final void Function(Event event) onOpen;
  final void Function(Event event) onFavourite;

  @override
  State<EventsTab> createState() => _EventsTabState();
}

class _EventsTabState extends State<EventsTab> {
  final TextEditingController _search = TextEditingController();

  String _query = '';
  EventCategory? _category;
  bool _showPast = false;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  /// Creates a copy before sorting, so the original list stays unchanged.
  List<Event> get _visible {
    final q = _query.trim().toLowerCase();

    final list = widget.events
        .where((e) => _category == null || e.category == _category)
        .where((e) => _showPast || !e.isPast)
        .where((e) => q.isEmpty || e.title.toLowerCase().contains(q))
        .toList();

    list.sort((a, b) => a.when.compareTo(b.when));
    return list;
  }

  void _resetSearch() {
    _search.clear();
    setState(() {
      _query = '';
      _category = null;
      _showPast = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final visible = _visible;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Find your vibe',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Discover something worth showing up for.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _search,
                onChanged: (value) => setState(() => _query = value),
                decoration: InputDecoration(
                  hintText: 'Search events...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          onPressed: _resetSearch,
                          icon: const Icon(Icons.close),
                          tooltip: 'Reset filters',
                        ),
                  filled: true,
                  fillColor: scheme.surfaceContainerHighest.withValues(
                    alpha: 0.45,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              ChoiceChip(
                label: const Text('All'),
                selected: _category == null,
                onSelected: (_) => setState(() => _category = null),
              ),
              for (final category in EventCategory.values) ...[
                const SizedBox(width: 8),
                ChoiceChip(
                  avatar: Icon(category.icon, size: 18),
                  label: Text(category.label),
                  selected: _category == category,
                  onSelected: (_) {
                    setState(() => _category = category);
                  },
                ),
              ],
              const SizedBox(width: 8),
              FilterChip(
                avatar: const Icon(Icons.history, size: 18),
                label: const Text('Past events'),
                selected: _showPast,
                onSelected: (value) {
                  setState(() => _showPast = value);
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: Row(
            children: [
              Text(
                _category?.label ?? 'Upcoming events',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                '${visible.length} ${visible.length == 1 ? 'event' : 'events'}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: EventList(
            events: visible,
            onOpen: widget.onOpen,
            onFavourite: widget.onFavourite,
            empty: EmptyState(
              icon: Icons.event_busy,
              message: 'No events found',
              actionLabel: 'Reset filters',
              onAction: _resetSearch,
            ),
          ),
        ),
      ],
    );
  }
}
