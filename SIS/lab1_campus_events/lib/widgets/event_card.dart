import 'package:flutter/material.dart';

import '../models/event.dart';
import '../utils/format.dart';

/// R18: reusable event card.
/// R19: category avatar with a FULL / N left badge.
class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.event,
    required this.onTap,
    required this.onFavourite,
  });

  final Event event;
  final VoidCallback onTap;
  final VoidCallback onFavourite;

  String? get _badge {
    if (event.isFull) return 'FULL';
    if (event.free <= 5) return '${event.free} left';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;

    final badge = _badge;
    final categoryColor = event.category.color(scheme);
    final dateColor = event.isPast ? scheme.onSurfaceVariant : scheme.primary;

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 27,
                    backgroundColor: categoryColor.withValues(alpha: 0.13),
                    child: Icon(
                      event.category.icon,
                      size: 27,
                      color: categoryColor,
                    ),
                  ),
                  if (badge != null)
                    Positioned(
                      right: -10,
                      bottom: -7,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: event.isFull ? scheme.error : scheme.tertiary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          badge,
                          style: text.labelSmall?.copyWith(
                            color: event.isFull
                                ? scheme.onError
                                : scheme.onTertiary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      event.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: text.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 14,
                          color: dateColor,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            formatDateTime(event.when),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: text.bodySmall?.copyWith(
                              color: dateColor,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          event.online
                              ? Icons.wifi
                              : Icons.location_on_outlined,
                          size: 15,
                          color: scheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            event.online ? 'Online' : event.place,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: text.bodySmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                onPressed: onFavourite,
                tooltip: event.favourite
                    ? 'Remove from favourites'
                    : 'Add to favourites',
                icon: Icon(
                  event.favourite ? Icons.favorite : Icons.favorite_border,
                  color: event.favourite ? scheme.error : scheme.outline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
