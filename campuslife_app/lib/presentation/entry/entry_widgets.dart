import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../shared/kit.dart';

class NoteBlock extends StatelessWidget {
  const NoteBlock({super.key, this.lead, required this.text});

  final String? lead;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(2, 10, 2, 0),
    child: RichText(
      text: TextSpan(
        style: Fonts.sansStyle(
          size: 11.5,
          height: 1.5,
          color: context.colors.muted,
        ),
        children: [
          if (lead != null)
            TextSpan(
              text: '$lead ',
              style: Fonts.sansStyle(
                size: 11.5,
                height: 1.5,
                weight: 600,
                color: context.colors.ink2,
              ),
            ),
          TextSpan(text: text),
        ],
      ),
    ),
  );
}

class RoleCard extends StatelessWidget {
  const RoleCard({
    super.key,
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  final String title;
  final String description;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 240),
            curve: AppMotion.ease,
            padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
            decoration: BoxDecoration(
              color: selected
                  ? context.colors.glassFieldFocus
                  : context.colors.glassField,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: selected
                    ? context.colors.accentLine
                    : context.colors.line,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: context.colors.accentSoft,
                        blurRadius: 0,
                        spreadRadius: 3,
                      ),
                      BoxShadow(
                        color: Color(0x660D1117),
                        blurRadius: 22,
                        offset: Offset(0, -14),
                      ),
                    ]
                  : const [],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 14, color: context.colors.ink),
                      const SizedBox(width: 6),
                    ],
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Fonts.sansStyle(
                          size: 13,
                          weight: 600,
                          letterSpacing: -0.13,
                          color: context.colors.ink,
                        ),
                      ),
                    ),
                    if (selected) ...[
                      const SizedBox(width: 6),
                      Icon(
                        Icons.check_rounded,
                        size: 14,
                        color: context.colors.accent,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: Fonts.sansStyle(
                    size: 11,
                    height: 1.4,
                    color: selected
                        ? context.colors.ink2
                        : context.colors.muted,
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

class MiniTabs extends StatelessWidget {
  const MiniTabs({
    super.key,
    required this.items,
    required this.index,
    required this.onSelect,
  });

  final List<String> items;
  final int index;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(0, 11, 0, 12),
    child: Row(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const SizedBox(width: 6),
          Expanded(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(11),
                child: InkWell(
                  borderRadius: BorderRadius.circular(11),
                  onTap: () => onSelect(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: i == index
                          ? context.colors.glassFieldFocus
                          : context.colors.wash,
                      borderRadius: BorderRadius.circular(11),
                      border: Border.all(
                        color: i == index
                            ? context.colors.line
                            : Colors.transparent,
                      ),
                    ),
                    child: Text(
                      items[i],
                      textAlign: TextAlign.center,
                      style: Fonts.sansStyle(
                        size: 12,
                        weight: 500,
                        color: i == index
                            ? context.colors.ink
                            : context.colors.muted,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    ),
  );
}

class WizardSteps extends StatelessWidget {
  const WizardSteps({super.key, required this.step, required this.total});

  final int step;
  final int total;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(2, 2, 2, 12),
    child: Row(
      children: [
        for (var i = 0; i < total; i++) ...[
          _StepDot(index: i, step: step),
          if (i != total - 1) ...[
            const SizedBox(width: 9),
            Expanded(child: _Rail(fill: i < step ? 1 : (i == step ? 0.5 : 0))),
            const SizedBox(width: 9),
          ],
        ],
        const SizedBox(width: 9),
        Text(
          '${step + 1} из $total',
          style: Fonts.monoStyle(
            size: 10,
            letterSpacing: 0.1 * 10,
            color: context.colors.muted,
          ),
        ),
      ],
    ),
  );
}

class _StepDot extends StatelessWidget {
  const _StepDot({required this.index, required this.step});

  final int index;
  final int step;

  @override
  Widget build(BuildContext context) {
    final done = index < step;
    final current = index == step;
    return Container(
      width: 21,
      height: 21,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: done
            ? context.colors.accent
            : current
            ? context.colors.ink
            : context.colors.washDeep,
      ),
      child: done
          ? const _Checkmark()
          : Text(
              '${index + 1}',
              style: Fonts.monoStyle(
                size: 10,
                letterSpacing: 0,
                color: current ? context.colors.paper : context.colors.muted,
              ),
            ),
    );
  }
}

class _Checkmark extends StatelessWidget {
  const _Checkmark();

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: const Size(9, 7), painter: _CheckPainter());
}

class _CheckPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(
      Path()
        ..moveTo(0.8, size.height * 0.55)
        ..lineTo(size.width * 0.38, size.height - 0.6)
        ..lineTo(size.width - 0.4, 0.6),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _CheckPainter oldDelegate) => false;
}

class _Rail extends StatelessWidget {
  const _Rail({required this.fill});

  final double fill;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(2),
    child: SizedBox(
      height: 2,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const ColoredBox(color: Color(0x170D1117)),
          Align(
            alignment: Alignment.centerLeft,
            child: LayoutBuilder(
              builder: (context, box) => TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: fill),
                duration: const Duration(milliseconds: 450),
                curve: AppMotion.ease,
                builder: (context, value, _) => Container(
                  width: box.maxWidth * value,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [context.colors.accent, context.colors.ink],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class GlassSelect extends StatelessWidget {
  const GlassSelect({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.icon = Icons.category_outlined,
    this.placeholder = 'Выбери тип',
  });

  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final IconData icon;
  final String placeholder;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      MicroLabel(label),
      Container(
        decoration: BoxDecoration(
          color: context.colors.glassField,
          borderRadius: BorderRadius.circular(Scale.fieldRadius),
          border: Border.all(color: context.colors.line),
        ),
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 37),
              child: DropdownButton<String?>(
                value: value,
                isExpanded: true,
                underline: const SizedBox.shrink(),
                borderRadius: BorderRadius.circular(Scale.fieldRadius),
                dropdownColor: context.colors.paper,
                icon: Icon(
                  Icons.expand_more_rounded,
                  size: 18,
                  color: context.colors.icon,
                ),
                style: Fonts.sansStyle(size: 14, color: context.colors.ink),
                items: [
                  if (value == null)
                    DropdownMenuItem<String?>(
                      value: null,
                      child: Text(
                        placeholder,
                        style: Fonts.sansStyle(
                          size: 14,
                          color: context.colors.placeholder,
                        ),
                      ),
                    ),
                  for (final item in items)
                    DropdownMenuItem<String?>(value: item, child: Text(item)),
                ],
                onChanged: onChanged,
              ),
            ),
            Positioned(
              left: 12,
              child: Icon(icon, size: 16, color: context.colors.icon),
            ),
          ],
        ),
      ),
      const SizedBox(height: 10),
    ],
  );
}

class VeilLayer extends StatelessWidget {
  const VeilLayer({super.key});

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: RepaintBoundary(
      child: CustomPaint(
        painter: VeilPainter(context.colors.paper),
        size: Size.infinite,
      ),
    ),
  );
}

class VeilPainter extends CustomPainter {
  const VeilPainter(this.paper);

  final Color paper;

  @override
  void paint(Canvas canvas, Size size) {
    final rx = size.width * 1.18;
    final ry = size.height * 0.74;
    final center = Offset(size.width * 0.5, size.height * 0.44);
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.scale(rx / ry, 1);
    final shader = RadialGradient(
      center: Alignment.center,
      radius: 1,
      colors: [
        paper.withValues(alpha: 0.8),
        paper.withValues(alpha: 0.56),
        paper.withValues(alpha: 0.22),
        paper.withValues(alpha: 0),
      ],
      stops: [0, 0.26, 0.52, 0.74],
    ).createShader(Rect.fromCircle(center: Offset.zero, radius: ry));
    final k = rx / ry;
    canvas.drawRect(
      Rect.fromLTRB(
        -center.dx / k,
        -center.dy,
        (size.width - center.dx) / k,
        size.height - center.dy,
      ),
      Paint()..shader = shader,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant VeilPainter oldDelegate) =>
      oldDelegate.paper != paper;
}

class BrandLockup extends StatelessWidget {
  const BrandLockup({super.key, required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 34,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: context.colors.ink,
          borderRadius: BorderRadius.circular(11),
          boxShadow: const [
            BoxShadow(
              color: Color(0x8C0D1117),
              blurRadius: 16,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Transform.rotate(
          angle: -8 * math.pi / 180 * scale,
          child: Text(
            '</>',
            style: Fonts.monoStyle(
              size: 12,
              weight: 500,
              letterSpacing: -0.48,
              color: context.colors.paper,
            ),
          ),
        ),
      ),
      const SizedBox(width: 11),
      RichText(
        text: TextSpan(
          style: Fonts.sansStyle(
            size: 16,
            letterSpacing: -0.4,
            color: context.colors.ink,
          ),
          children: [
            const TextSpan(
              text: 'Campus',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            TextSpan(
              text: 'Life',
              style: TextStyle(
                fontWeight: FontWeight.w300,
                color: context.colors.accent,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class LiveBadge extends StatefulWidget {
  const LiveBadge({super.key, required this.text});

  final String text;

  @override
  State<LiveBadge> createState() => _LiveBadgeState();
}

class _LiveBadgeState extends State<LiveBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: AppMotion.ambient,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _pulse.stop();
      _pulse.value = 1;
    } else if (!_pulse.isAnimating) {
      _pulse.repeat();
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(10, 7, 12, 7),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(Scale.chipRadius),
      border: Border.all(color: context.colors.line2),
      color: context.colors.glass,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _pulse,
          builder: (context, child) {
            final t = _pulse.value;
            final ring = t < 0.27 ? t / 0.27 : 1.0;
            return SizedBox(
              width: 6,
              height: 6,
              child: Center(
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.colors.accent,
                    boxShadow: [
                      BoxShadow(
                        color: context.colors.accent.withValues(
                          alpha: 0.5 * (1 - ring),
                        ),
                        spreadRadius: 9 * ring,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 7),
        Text(
          widget.text.toUpperCase(),
          style: Fonts.monoStyle(
            size: 10.5,
            letterSpacing: 0.06 * 10.5,
            color: context.colors.muted,
          ),
        ),
      ],
    ),
  );
}

class TopPill extends StatelessWidget {
  const TopPill({super.key, required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.click,
    child: Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(Scale.chipRadius),
      child: InkWell(
        borderRadius: BorderRadius.circular(Scale.chipRadius),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Scale.chipRadius),
            border: Border.all(color: context.colors.line),
            color: context.colors.glass,
          ),
          child: Text(
            label,
            style: Fonts.sansStyle(size: 12.5, color: context.colors.ink2),
          ),
        ),
      ),
    ),
  );
}
