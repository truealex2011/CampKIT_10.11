import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities.dart';
import '../feed/feed_screen.dart';
import '../feed/media_pool.dart';

class EventPreviewScreen extends ConsumerStatefulWidget {
  const EventPreviewScreen({super.key, required this.event});

  final CampusEvent event;

  static Future<void> show(BuildContext context, CampusEvent event) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EventPreviewScreen(event: event),
      ),
    );
  }

  @override
  ConsumerState<EventPreviewScreen> createState() => _EventPreviewScreenState();
}

class _EventPreviewScreenState extends ConsumerState<EventPreviewScreen> {
  late final MediaPool _pool;

  @override
  void initState() {
    super.initState();
    _pool = MediaPool();
    _pool.syncWith(
      [widget.event.id],
      {widget.event.id: widget.event.video?.path},
    );
    _pool.setActive(0);
  }

  @override
  void dispose() {
    _pool.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: EventCard(event: widget.event, pool: _pool),
          ),
          Positioned(
            top: MediaQuery.paddingOf(context).top + 10,
            left: 16,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                      tooltip: 'Назад',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 14),
                      child: Text(
                        'Вид участника',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
