import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/di.dart';
import '../../app/theme.dart';
import '../../domain/entities.dart';
import '../entry/entry_widgets.dart';
import '../shared/fish.dart';
import '../shared/kit.dart';
import 'organizer_common.dart';

class StatsView extends ConsumerStatefulWidget {
  const StatsView({super.key, required this.orgId});

  final String orgId;

  @override
  ConsumerState<StatsView> createState() => _StatsViewState();
}

class _StatsViewState extends ConsumerState<StatsView> {
  String? _eventId;

  @override
  Widget build(BuildContext context) {
    final events = ref.watch(organizerEventsProvider(widget.orgId));
    return switch (events) {
      AsyncData(:final value) =>
        value.isEmpty
            ? const EmptyPlate(
                lead: 'Пусто.',
                text: 'Статистика появится, когда создашь первое событие.',
              )
            : _buildWithData(value),
      AsyncError() => const EmptyPlate(
        lead: 'Сбой.',
        text: 'Не удалось загрузить события для статистики.',
      ),
      _ => const Center(child: FishLoader(size: 40)),
    };
  }

  Widget _buildWithData(List<CampusEvent> events) {
    final selected = events.any((e) => e.id == _eventId)
        ? _eventId!
        : events.first.id;
    final titles = [
      for (var i = 0; i < events.length; i++) '${i + 1}. ${events[i].title}',
    ];
    return ListView(
      padding: const EdgeInsets.only(top: 2, bottom: 8),
      children: [
        GlassSelect(
          label: 'событие для графика по дням',
          value: titles[events.indexWhere((e) => e.id == selected)],
          items: titles,
          icon: Icons.query_stats_rounded,
          onChanged: (title) {
            if (title == null) return;
            final index = titles.indexOf(title);
            if (index >= 0) setState(() => _eventId = events[index].id);
          },
        ),
        const SizedBox(height: 4),
        MicroLabel('заявки по дням'),
        _ChartFrame(child: _DailyChart(eventId: selected)),
        const SizedBox(height: 14),
        MicroLabel('сравнение событий'),
        _ChartFrame(child: _EventsCompareChart(orgId: widget.orgId)),
        const SizedBox(height: 14),
        MicroLabel('пришли и не пришли'),
        _ChartFrame(child: _AttendanceShareChart(orgId: widget.orgId)),
      ],
    );
  }
}

class _ChartFrame extends StatelessWidget {
  const _ChartFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => GlassCard(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 6),
        SizedBox(height: 180, child: child),
        const SizedBox(height: 6),
      ],
    ),
  );
}

class _NoData extends StatelessWidget {
  const _NoData({this.text = 'Пока нет данных'});

  final String text;

  @override
  Widget build(BuildContext context) => Center(
    child: Text(text, style: Fonts.monoStyle(size: 10.5, color: Palette.muted)),
  );
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      const SizedBox(width: 6),
      Text(label, style: Fonts.monoStyle(size: 9.5, color: Palette.muted)),
    ],
  );
}

TextStyle get _axisStyle => Fonts.monoStyle(size: 8.5, color: Palette.muted);

class _DailyChart extends ConsumerWidget {
  const _DailyChart({required this.eventId});

  final String eventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final daily = ref.watch(eventDailyProvider(eventId));
    return switch (daily) {
      AsyncData(:final value) =>
        value.isEmpty ? const _NoData() : _lineChart(value),
      AsyncError() => const _NoData(text: 'Данные недоступны'),
      _ => const Center(child: FishLoader(size: 40)),
    };
  }

  Widget _lineChart(List<DayCount> days) {
    var maxY = 1.0;
    for (final d in days) {
      if (d.registrations > maxY) maxY = d.registrations.toDouble();
    }
    maxY += 1;
    final yInterval = (maxY / 4).ceilToDouble();
    final xInterval = days.length <= 5 ? 1.0 : (days.length / 5).ceilToDouble();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: LineChart(
            LineChartData(
              minY: 0,
              maxY: maxY,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: yInterval,
                getDrawingHorizontalLine: (value) =>
                    const FlLine(color: Palette.line2, strokeWidth: 1),
              ),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(),
                rightTitles: const AxisTitles(),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: yInterval,
                    reservedSize: 28,
                    getTitlesWidget: (value, meta) =>
                        Text(value.toInt().toString(), style: _axisStyle),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: xInterval,
                    reservedSize: 24,
                    getTitlesWidget: (value, meta) {
                      final index = value.round();
                      if (index != value ||
                          index < 0 ||
                          index >= days.length ||
                          index % xInterval.toInt() != 0) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: SizedBox(
                          width: 44,
                          child: Text(
                            RuFmt.dayShort(days[index].date),
                            style: _axisStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              lineTouchData: const LineTouchData(enabled: false),
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    for (var i = 0; i < days.length; i++)
                      FlSpot(i.toDouble(), days[i].registrations.toDouble()),
                  ],
                  color: Palette.accent,
                  barWidth: 2.4,
                  isCurved: true,
                  dotData: const FlDotData(show: true),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
        const Align(
          alignment: Alignment.centerLeft,
          child: _LegendDot(color: Palette.accent, label: 'заявки по дням'),
        ),
      ],
    );
  }
}

class _EventsCompareChart extends ConsumerWidget {
  const _EventsCompareChart({required this.orgId});

  final String orgId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(orgStatsProvider(orgId));
    return switch (stats) {
      AsyncData(:final value) =>
        value.isEmpty ? const _NoData() : _barChart(value, ref),
      AsyncError() => const _NoData(text: 'Данные недоступны'),
      _ => const Center(child: FishLoader(size: 40)),
    };
  }

  Widget _barChart(List<EventStats> stats, WidgetRef ref) {
    final shown = stats.take(8).toList(growable: false);
    var maxY = 1.0;
    for (final s in shown) {
      if (s.registrations > maxY) maxY = s.registrations.toDouble();
    }
    maxY += 1;
    final yInterval = (maxY / 4).ceilToDouble();
    final rodWidth = shown.length <= 4 ? 26.0 : 14.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: BarChart(
            BarChartData(
              maxY: maxY,
              alignment: BarChartAlignment.spaceAround,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: yInterval,
                getDrawingHorizontalLine: (value) =>
                    const FlLine(color: Palette.line2, strokeWidth: 1),
              ),
              borderData: FlBorderData(show: false),
              barTouchData: const BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(),
                rightTitles: const AxisTitles(),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: yInterval,
                    reservedSize: 28,
                    getTitlesWidget: (value, meta) =>
                        Text(value.toInt().toString(), style: _axisStyle),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 24,
                    getTitlesWidget: (value, meta) {
                      final index = value.round();
                      if (index != value ||
                          index < 0 ||
                          index >= shown.length) {
                        return const SizedBox.shrink();
                      }
                      final title = _shortTitle(shown[index].eventId, ref);
                      return Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: SizedBox(
                          width: 40,
                          child: Text(
                            title,
                            style: _axisStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              barGroups: [
                for (var i = 0; i < shown.length; i++)
                  BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: shown[i].registrations.toDouble(),
                        color: Palette.gold,
                        width: rodWidth,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
        const Align(
          alignment: Alignment.centerLeft,
          child: _LegendDot(
            color: Palette.gold,
            label: 'записалось на каждое событие',
          ),
        ),
      ],
    );
  }

  String _shortTitle(String eventId, WidgetRef ref) {
    var title = eventId;
    final events = ref.read(organizerEventsProvider(orgId)).value;
    if (events != null) {
      for (final e in events) {
        if (e.id == eventId) {
          title = e.title;
          break;
        }
      }
    }
    if (title.length <= 8) return title;
    return '${title.substring(0, 8)}…';
  }
}

class _AttendanceShareChart extends ConsumerWidget {
  const _AttendanceShareChart({required this.orgId});

  final String orgId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(orgStatsProvider(orgId));
    return switch (stats) {
      AsyncData(:final value) => _share(value),
      AsyncError() => const _NoData(text: 'Данные недоступны'),
      _ => const Center(child: FishLoader(size: 40)),
    };
  }

  Widget _share(List<EventStats> stats) {
    var registrations = 0;
    var checkedIn = 0;
    for (final s in stats) {
      registrations += s.registrations;
      checkedIn += s.checkedIn;
    }
    if (registrations == 0) return const _NoData();
    final came = checkedIn.clamp(0, registrations);
    final missed = registrations - came;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 34,
              startDegreeOffset: -90,
              sections: [
                PieChartSectionData(
                  value: came.toDouble(),
                  color: Palette.mint,
                  radius: 52,
                  title: '$came',
                  showTitle: true,
                  titleStyle: Fonts.sansStyle(
                    size: 13,
                    weight: 700,
                    color: Colors.white,
                  ),
                ),
                if (missed > 0)
                  PieChartSectionData(
                    value: missed.toDouble(),
                    color: Palette.rose,
                    radius: 52,
                    title: '$missed',
                    showTitle: true,
                    titleStyle: Fonts.sansStyle(
                      size: 13,
                      weight: 700,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _LegendDot(color: Palette.mint, label: 'пришло · $came'),
            if (missed > 0) ...[
              const SizedBox(width: 14),
              _LegendDot(color: Palette.rose, label: 'не пришло · $missed'),
            ],
          ],
        ),
      ],
    );
  }
}
