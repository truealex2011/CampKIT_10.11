import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/di.dart';
import '../../app/theme.dart';
import '../../domain/entities.dart';
import '../entry/entry_widgets.dart';
import '../shared/fish.dart';
import '../shared/kit.dart';
import 'admin_common.dart';

class ReportsTab extends ConsumerStatefulWidget {
  const ReportsTab({super.key});

  @override
  ConsumerState<ReportsTab> createState() => _ReportsTabState();
}

class _ReportsTabState extends ConsumerState<ReportsTab> {
  String? _busyId;

  Future<void> _resolve(Report report, ReportStatus action) async {
    if (action == ReportStatus.organizerBlocked) {
      final ok = await adminConfirm(
        context,
        title: 'Заблокировать организатора?',
        body:
            'Организатор потеряет доступ к панели и публикации событий, а все его события '
            'скроются из афиши — в разделе «Управление» они получат метку «Скрыто из афиши». '
            'Жалоба будет закрыта.',
        confirmLabel: 'Заблокировать',
      );
      if (!ok || !mounted) return;
    }
    setState(() => _busyId = report.id);
    try {
      await ref.read(repositoryProvider).resolveReport(report.id, action);
      ref.read(revisionProvider.notifier).bump();
      if (!mounted) return;
      ToastController.show(context, AdminUi.reportDoneLabel(action));
    } on Object catch (error) {
      if (mounted) {
        ToastController.show(
          context,
          AdminUi.failureMessage(error),
          error: true,
        );
      }
    } finally {
      if (mounted) setState(() => _busyId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final reports = ref.watch(openReportsProvider);
    return ListView(
      padding: AdminUi.page(context),
      children: [
        const AdminHint(
          title: 'Жалобы участников',
          text:
              'Каждую жалобу нужно разобрать и закрыть одним из четырёх решений. '
              'Открытая жалоба остаётся в этом списке, решённая уходит в журнал модерации.',
        ),
        reports.when(
          loading: () => const AdminLoading(text: 'Открываем жалобы…'),
          error: (error, _) => AdminFailure(
            message: AdminUi.failureMessage(error),
            onRetry: () => ref.invalidate(openReportsProvider),
          ),
          data: (list) {
            final open = list
                .where((r) => r.status == ReportStatus.open)
                .toList(growable: false);
            if (open.isEmpty) {
              return const AdminEmpty(
                icon: Icons.verified_user_outlined,
                text: 'Открытых жалоб нет',
                hint:
                    'Жалобы участников на события и организаторов приходят сюда — реагируй на них в течение дня.',
              );
            }
            final sorted = [...open]
              ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DividerLabel('открытые жалобы · ${sorted.length}'),
                for (final report in sorted)
                  _ReportCard(
                    report: report,
                    busy: _busyId == report.id,
                    locked: _busyId != null,
                    onResolve: (action) => _resolve(report, action),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({
    required this.report,
    required this.busy,
    required this.locked,
    required this.onResolve,
  });

  final Report report;
  final bool busy;
  final bool locked;
  final ValueChanged<ReportStatus> onResolve;

  @override
  Widget build(BuildContext context) {
    final isEvent = report.target == ReportTarget.event;
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              AdminTag(
                text: AdminUi.targetLabel(report.target).toUpperCase(),
                color: isEvent ? Palette.accent : Palette.gold,
                icon: isEvent
                    ? Icons.event_note_rounded
                    : Icons.campaign_outlined,
                strong: true,
              ),
              const Spacer(),
              Text(
                AdminDate.stamp(report.createdAt),
                style: Fonts.monoStyle(size: 9, color: Palette.placeholder),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            report.reason,
            style: Fonts.sansStyle(
              size: 14.5,
              weight: 600,
              height: 1.25,
              color: Palette.ink,
            ),
          ),
          if (report.comment.isNotEmpty) ...[
            const SizedBox(height: 6),
            NoteBlock(lead: 'Комментарий:', text: report.comment),
          ],
          const SizedBox(height: 8),
          AdminKeyValue(label: 'Жалоба от', value: 'id ${report.reporterId}'),
          if (report.eventId != null)
            AdminKeyValue(label: 'Событие', value: report.eventId!),
          if (report.organizerId != null)
            AdminKeyValue(
              label: 'Организатор',
              value: 'id ${report.organizerId}',
              color: Palette.ink2,
            ),
          const DividerLabel('решение', top: 12, bottom: 8),
          Row(
            children: GhostButton.pair(
              _Action(
                label: AdminUi.reportActionLabel(ReportStatus.eventHidden),
                color: Palette.rose,
                icon: Icons.visibility_off_rounded,
                busy: busy,
                locked: locked,
                onTap: () => onResolve(ReportStatus.eventHidden),
              ),
              _Action(
                label: AdminUi.reportActionLabel(ReportStatus.organizerWarned),
                color: Palette.gold,
                icon: Icons.notifications_active_outlined,
                busy: busy,
                locked: locked,
                onTap: () => onResolve(ReportStatus.organizerWarned),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: GhostButton.pair(
              _Action(
                label: AdminUi.reportActionLabel(ReportStatus.organizerBlocked),
                color: Palette.rose,
                icon: Icons.block_rounded,
                busy: busy,
                locked: locked,
                onTap: () => onResolve(ReportStatus.organizerBlocked),
              ),
              _Action(
                label: AdminUi.reportActionLabel(ReportStatus.dismissed),
                color: Palette.muted,
                icon: Icons.thumb_down_outlined,
                busy: busy,
                locked: locked,
                onTap: () => onResolve(ReportStatus.dismissed),
              ),
            ),
          ),
          if (busy) ...[
            const SizedBox(height: 10),
            const Center(
              child: SizedBox(
                width: 16,
                height: 16,
                child: FishLoader(size: 16, color: Palette.accent),
              ),
            ),
          ],
          const SizedBox(height: 8),
          const NoteBlock(
            text:
                'Блокировка организатора скрывает из афиши все его события — '
                'в разделе «Управление» они помечаются как скрытые.',
          ),
        ],
      ),
    );
  }
}

class _Action extends StatelessWidget {
  const _Action({
    required this.label,
    required this.color,
    required this.icon,
    required this.busy,
    required this.locked,
    required this.onTap,
  });

  final String label;
  final Color color;
  final IconData icon;
  final bool busy;
  final bool locked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (busy) {
      return const Center(
        child: SizedBox(
          width: 18,
          height: 18,
          child: FishLoader(size: 18, color: Palette.accent),
        ),
      );
    }
    return MouseRegion(
      cursor: locked ? SystemMouseCursors.basic : SystemMouseCursors.click,
      child: Material(
        color: color.withValues(alpha: locked ? 0.03 : 0.08),
        borderRadius: BorderRadius.circular(Scale.fieldRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(Scale.fieldRadius),
          onTap: locked ? null : onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 46),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Scale.fieldRadius),
              border: Border.all(
                color: color.withValues(alpha: locked ? 0.16 : 0.36),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 15,
                  color: locked ? Palette.placeholder : color,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: Fonts.sansStyle(
                      size: 12,
                      weight: 500,
                      height: 1.25,
                      color: locked ? Palette.placeholder : Palette.ink,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
