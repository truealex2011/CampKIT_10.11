import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../app/theme.dart';
import '../../domain/entities.dart';
import '../feed/media_pool.dart' show DateFmt;
import '../shared/kit.dart';

class TicketCard extends StatelessWidget {
  const TicketCard({super.key, required this.bundle, this.onOpen});

  final TicketBundle bundle;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final event = bundle.event;
    final code = bundle.registration.ticketCode;
    final came = bundle.registration.isCheckedIn;
    return GlassCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  event.title.isEmpty ? 'Без названия' : event.title,
                  style: Fonts.sansStyle(size: 15.5, weight: 700, height: 1.2),
                ),
              ),
              const SizedBox(width: 8),
              RoleChip(
                label: came ? 'пришёл' : 'ожидает',
                dot: came ? Palette.mint : Palette.gold,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${DateFmt.full(event.startAt)} · ${DateFmt.time(event.startAt)}'
            ' · ${event.place.isEmpty ? 'место не указано' : event.place}',
            style: Fonts.sansStyle(size: 12, color: Palette.muted),
          ),
          const SizedBox(height: 14),
          Center(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Scale.fieldRadius),
                border: Border.all(color: Palette.cardLine),
              ),
              child: QrImageView(
                data: code,
                size: 168,
                version: QrVersions.auto,
                backgroundColor: Colors.white,
                eyeStyle: const QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: Palette.ink,
                ),
                dataModuleStyle: const QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: Palette.ink,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SelectableText(
                  code,
                  style: Fonts.monoStyle(size: 10.5, color: Palette.ink2),
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: code));
                  ToastController.show(context, 'Код билета скопирован');
                },
                icon: const Icon(
                  Icons.copy_rounded,
                  size: 17,
                  color: Palette.muted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Покажи этот код волонтёру на входе — он отметит твой приход.',
            style: Fonts.sansStyle(
              size: 11.5,
              height: 1.4,
              color: Palette.muted,
            ),
          ),
          if (event.status == EventStatus.cancelled) ...[
            DividerLabel('Отменено'),
            Text(
              event.cancelledAt == null
                  ? 'Организатор отменил это событие.'
                  : 'Организатор отменил это событие ${DateFmt.full(event.cancelledAt!)}.',
              style: Fonts.sansStyle(
                size: 12,
                height: 1.4,
                color: Palette.rose,
              ),
            ),
          ],
          if (onOpen != null) ...[
            const SizedBox(height: 10),
            GhostButton(
              label: 'Открыть событие',
              expand: true,
              onPressed: onOpen,
            ),
          ],
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
