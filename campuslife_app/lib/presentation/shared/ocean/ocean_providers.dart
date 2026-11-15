import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../onboarding.dart';
import 'ocean_view.dart';
import 'types.dart';
import 'world.dart';

abstract final class OceanRoster {
  static const List<SharkSpec> defaultSpecs = [
    SharkSpec(SharkKind.classic, 1.5),
    SharkSpec(SharkKind.tiger, 1.18),
    SharkSpec(SharkKind.mako, 1.02),
    SharkSpec(SharkKind.hammerhead, 0.88),
    SharkSpec(SharkKind.zebra, 0.78),
    SharkSpec(SharkKind.nurse, 0.72),
    SharkSpec(SharkKind.mako, 0.66),
  ];
}

final oceanRosterProvider = Provider<List<SharkSpec>>(
  (ref) => OceanRoster.defaultSpecs,
);

final oceanWorldProvider = Provider<World>(
  (ref) => World(sharkSpecs: OceanRoster.defaultSpecs),
);

/// Отдельный медленный мир для фоновых слоёв внутри приложения.
final ambientOceanProvider = Provider<World>(
  (ref) => World(
    sharkSpecs: OceanRoster.defaultSpecs,
    timeScale: 0.16,
    fishCount: 50,
  ),
);

/// Фоновый слой с акулами для внутренних экранов: не ловит клики,
/// прикрыт вуалью, чтобы контент оставался читаемым.
class OceanBackdrop extends ConsumerWidget {
  const OceanBackdrop({super.key, this.veil = 1.0});

  /// Множитель плотности вуали: 1 — как на заставке, больше — глуше.
  final double veil;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fishEnabled = ref.watch(fishEnabledProvider);
    return IgnorePointer(
      child: RepaintBoundary(
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (fishEnabled)
              OceanView(scene: ref.watch(ambientOceanProvider))
            else
              Container(color: Palette.ink),
            _Veil(paper: context.colors.paper, factor: veil),
          ],
        ),
      ),
    );
  }
}

class _Veil extends StatelessWidget {
  const _Veil({required this.paper, required this.factor});

  final Color paper;
  final double factor;

  @override
  Widget build(BuildContext context) => CustomPaint(
    painter: _VeilPainter(paper, factor),
    size: Size.infinite,
  );
}

class _VeilPainter extends CustomPainter {
  const _VeilPainter(this.paper, this.factor);

  final Color paper;
  final double factor;

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
        paper.withValues(alpha: 0.8 * factor),
        paper.withValues(alpha: 0.56 * factor),
        paper.withValues(alpha: 0.26 * factor),
        paper.withValues(alpha: 0),
      ],
      stops: const [0, 0.26, 0.52, 0.74],
    ).createShader(Rect.fromCircle(center: Offset.zero, radius: ry));
    final paint = Paint()..shader = shader;
    final k = rx / ry;
    canvas.drawRect(
      Rect.fromLTRB(
        -center.dx / k,
        -center.dy / k,
        center.dx / k,
        center.dy / k,
      ),
      paint,
    );
    canvas.restore();
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = paper.withValues(alpha: 0.16 * factor),
    );
  }

  @override
  bool shouldRepaint(covariant _VeilPainter old) =>
      old.paper != paper || old.factor != factor;
}
