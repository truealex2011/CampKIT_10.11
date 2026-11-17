import 'dart:ui';

import 'package:flutter/material.dart';

import '../../app/theme.dart';

class GlassSheet extends StatelessWidget {
  const GlassSheet({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(20, 8, 20, 24),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark
        ? Color.alphaBlend(colors.glass, Palette.darkPaper)
        : Color.alphaBlend(colors.glass, Palette.paper);
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppRadius.sheet),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: sheetBg,
            border: Border(
              top: BorderSide(color: colors.lineStrong),
              left: BorderSide(color: colors.line),
              right: BorderSide(color: colors.line),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: padding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 18),
                      decoration: BoxDecoration(
                        color: colors.lineStrong,
                        borderRadius: BorderRadius.circular(AppRadius.chip),
                      ),
                    ),
                  ),
                  Flexible(child: child),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<T?> showGlassSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isScrollControlled = true,
}) => showModalBottomSheet<T>(
  context: context,
  isScrollControlled: isScrollControlled,
  useSafeArea: true,
  backgroundColor: Colors.transparent,
  barrierColor: context.colors.ink.withValues(alpha: 0.46),
  builder: (context) => GlassSheet(child: Builder(builder: builder)),
);
