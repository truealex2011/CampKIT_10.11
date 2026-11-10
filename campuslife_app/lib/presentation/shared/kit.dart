library;

import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme.dart';
import 'fish.dart';

class RiseIn extends StatefulWidget {
  const RiseIn({
    super.key,
    required this.child,
    this.delay = 0,
    this.distance = 14,
  });

  final Widget child;
  final double delay;
  final double distance;

  @override
  State<RiseIn> createState() => _RiseInState();
}

class _RiseInState extends State<RiseIn> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  );
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.delay <= 0) {
      _controller.forward();
    } else {
      _timer = Timer(Duration(milliseconds: (widget.delay * 1000).round()), () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.maybeOf(context)?.disableAnimations == true) {
      _timer?.cancel();
      _controller.value = 1;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _controller,
    child: widget.child,
    builder: (context, child) => Opacity(
      opacity: Curves.easeOut.transform(_controller.value),
      child: Transform.translate(
        offset: Offset(0, widget.distance * (1 - _controller.value)),
        child: child,
      ),
    ),
  );
}

class MicroLabel extends StatelessWidget {
  const MicroLabel(
    this.text, {
    super.key,
    this.focused = false,
    this.invalid = false,
    this.size = 10,
  });

  final String text;
  final bool focused;
  final bool invalid;
  final double size;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 2, right: 2, bottom: 6),
    child: AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 240),
      style: Fonts.monoStyle(
        size: size,
        weight: 500,
        letterSpacing: size * 0.011,
        color: invalid
            ? Palette.rose
            : focused
            ? Palette.accent
            : Palette.muted,
      ),
      child: Text(text.toUpperCase()),
    ),
  );
}

class GlassField extends StatefulWidget {
  const GlassField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.icon = Icons.tag,
    this.obscure = false,
    this.keyboardType,
    this.maxLength,
    this.maxLines = 1,
    this.onChanged,
    this.textCapitalization = TextCapitalization.none,
    this.suffixIcon,
    this.onSuffixTap,
    this.uppercase = false,
    this.enabled = true,
    this.error,
    this.autofocus = false,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final IconData icon;
  final bool obscure;
  final TextInputType? keyboardType;
  final int? maxLength;
  final int maxLines;
  final ValueChanged<String>? onChanged;
  final TextCapitalization textCapitalization;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final bool uppercase;
  final bool enabled;

  final String? error;
  final bool autofocus;

  @override
  State<GlassField> createState() => _GlassFieldState();
}

class _GlassFieldState extends State<GlassField> {
  final FocusNode _focus = FocusNode();
  bool _masked = true;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _masked = widget.obscure;
    _focused = widget.autofocus;
    _focus.addListener(_onFocus);
  }

  void _onFocus() {
    if (_focused != _focus.hasFocus) setState(() => _focused = _focus.hasFocus);
  }

  @override
  void dispose() {
    _focus
      ..removeListener(_onFocus)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bad = (widget.error ?? '').isNotEmpty;
    final borderColor = bad
        ? Palette.roseLine
        : _focused
        ? Palette.accent.withValues(alpha: 0.6)
        : Palette.line;
    final background = bad
        ? Palette.rose.withValues(alpha: 0.045)
        : _focused
        ? Palette.glassFieldFocus
        : Palette.glassField;

    return Opacity(
      opacity: widget.enabled ? 1 : 0.45,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MicroLabel(widget.label, focused: _focused, invalid: bad),
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Palette.ease,
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(Scale.fieldRadius),
              border: Border.all(color: borderColor),
              boxShadow: bad
                  ? const [
                      BoxShadow(
                        color: Palette.roseSoft,
                        blurRadius: 0,
                        spreadRadius: 3.5,
                      ),
                    ]
                  : _focused
                  ? const [
                      BoxShadow(
                        color: Palette.accentSoft,
                        blurRadius: 0,
                        spreadRadius: 3.5,
                      ),
                    ]
                  : const [],
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 220),
                  style: TextStyle(
                    color: _focused ? Palette.accent : Palette.icon,
                    fontSize: 16,
                  ),
                  child: Icon(
                    widget.icon,
                    size: 16,
                    color: _focused ? Palette.accent : Palette.icon,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    focusNode: _focus,
                    enabled: widget.enabled,
                    obscureText: _masked,
                    keyboardType: widget.keyboardType,
                    maxLength: widget.maxLength,
                    maxLines: widget.maxLines,
                    minLines: widget.maxLines > 1 ? 3 : 1,
                    onChanged: (value) {
                      if (widget.uppercase) {
                        final upper = value.toUpperCase();
                        if (upper != value) {
                          widget.controller.text = upper;
                          widget.controller.selection = TextSelection.collapsed(
                            offset: upper.length,
                          );
                        }
                      }
                      widget.onChanged?.call(widget.controller.text);
                    },
                    textCapitalization: widget.textCapitalization,
                    autofocus: widget.autofocus,
                    inputFormatters: widget.uppercase
                        ? [
                            UpperCaseFormatter(),
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[A-Z0-9-]'),
                            ),
                          ]
                        : null,
                    style: Fonts.sansStyle(size: 14),
                    cursorColor: Palette.ink,
                    decoration: InputDecoration(
                      hintText: widget.hint,
                      hintStyle: Fonts.sansStyle(
                        size: 14,
                        color: Palette.placeholder,
                      ),
                      counterText: '',
                      isDense: true,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.fromLTRB(
                        13,
                        10.5,
                        widget.onSuffixTap != null || widget.suffixIcon != null
                            ? 34
                            : 12,
                        10.5,
                      ),
                    ),
                  ),
                ),
                if (widget.suffixIcon != null || widget.obscure)
                  _SuffixButton(
                    icon: widget.obscure
                        ? (_masked
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined)
                        : widget.suffixIcon!,
                    onTap: widget.obscure
                        ? () => setState(() => _masked = !_masked)
                        : widget.onSuffixTap,
                  ),
                const SizedBox(width: 8),
              ],
            ),
          ),

          if (bad)
            Padding(
              padding: const EdgeInsets.fromLTRB(2, 6, 2, 0),
              child: Row(
                children: [
                  const _Dot(size: 3, color: Palette.rose),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      widget.error!,
                      style: Fonts.sansStyle(
                        size: 11,
                        color: Palette.rose,
                        height: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class _SuffixButton extends StatelessWidget {
  const _SuffixButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.click,
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: 26,
        height: 26,
        child: Center(child: Icon(icon, size: 15, color: Palette.icon)),
      ),
    ),
  );
}

class _Dot extends StatelessWidget {
  const _Dot({this.size = 6, this.color = Palette.accent, this.glow = false});

  final double size;
  final Color color;
  final bool glow;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.circle,
      boxShadow: glow
          ? [BoxShadow(color: color.withValues(alpha: 0.9), blurRadius: 8)]
          : null,
    ),
  );
}

class PasswordStrength extends StatefulWidget {
  const PasswordStrength({
    super.key,
    required this.score,
    required this.focused,
  });

  final int score;
  final bool focused;

  @override
  State<PasswordStrength> createState() => _PasswordStrengthState();
}

class _PasswordStrengthState extends State<PasswordStrength> {
  static const _colors = [
    Palette.rose,
    Palette.gold,
    Palette.accent,
    Palette.mint,
  ];
  static const _labels = ['слабый', 'средний', 'хороший', 'надёжный'];

  @override
  Widget build(BuildContext context) {
    final active = widget.score.clamp(0, 4);
    return Opacity(
      opacity: widget.focused ? 1 : 0.45,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
        child: Row(
          children: [
            for (var i = 0; i < 4; i++) ...[
              if (i > 0) const SizedBox(width: 5),
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 3,
                  decoration: BoxDecoration(
                    color: i < active
                        ? _colors[active - 1]
                        : const Color(0x170D1117),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ],
            const SizedBox(width: 8),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: Fonts.monoStyle(
                size: 9.5,
                weight: 500,
                letterSpacing: 0.08 * 9.5,
                color: active == 0 ? Palette.muted : _colors[active - 1],
              ),
              child: Text(
                (active == 0 ? 'пароль' : _labels[active - 1]).toUpperCase(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PrimaryButton extends StatefulWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.busy = false,
    this.arrow = true,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool busy;
  final bool arrow;
  final IconData? icon;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null && !widget.busy;
    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 180),
        curve: Palette.ease,
        offset: _hover && enabled ? const Offset(0, -0.06) : Offset.zero,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          decoration: BoxDecoration(
            color: Palette.ink.withValues(alpha: enabled ? 1 : 0.34),
            borderRadius: BorderRadius.circular(Scale.fieldRadius),
            boxShadow: [
              BoxShadow(
                color: Palette.ink.withValues(
                  alpha: !enabled ? 0.08 : (_hover ? 0.42 : 0.3),
                ),
                blurRadius: 16,
                offset: Offset(0, _hover ? -10 : -8).translate(0, 12),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(Scale.fieldRadius),
            child: InkWell(
              borderRadius: BorderRadius.circular(Scale.fieldRadius),
              onTap: enabled ? widget.onPressed : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(widget.icon, size: 15, color: Palette.paper),
                      const SizedBox(width: 8),
                    ],
                    if (widget.busy)
                      const FishLoader(size: 14, color: Palette.paper)
                    else
                      Flexible(
                        child: Text(
                          widget.label,
                          textAlign: TextAlign.center,
                          style: Fonts.sansStyle(
                            size: 14,
                            weight: 600,
                            letterSpacing: -0.07,
                            color: Palette.paper,
                          ),
                        ),
                      ),
                    if (widget.arrow && !widget.busy) ...[
                      const SizedBox(width: 8),
                      AnimatedSlide(
                        duration: const Duration(milliseconds: 300),
                        curve: Palette.ease,
                        offset: _hover ? const Offset(0.25, 0) : Offset.zero,
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          size: 15,
                          color: Palette.paper,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GhostButton extends StatefulWidget {
  const GhostButton({
    super.key,
    required this.label,
    this.onPressed,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool expand;

  static List<Widget> pair(Widget a, Widget b) => [
    Expanded(child: a),
    const SizedBox(width: 8),
    Expanded(child: b),
  ];

  @override
  State<GhostButton> createState() => _GhostButtonState();
}

class _GhostButtonState extends State<GhostButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
    cursor: widget.onPressed == null
        ? SystemMouseCursors.basic
        : SystemMouseCursors.click,
    onEnter: (_) => setState(() => _hover = true),
    onExit: (_) => setState(() => _hover = false),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: _hover ? 0.9 : 0.5),
        borderRadius: BorderRadius.circular(Scale.fieldRadius),
        border: Border.all(color: _hover ? Palette.lineStrong : Palette.line),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(Scale.fieldRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(Scale.fieldRadius),
          onTap: widget.onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: Text(
              widget.label,
              style: Fonts.sansStyle(
                size: 13,
                weight: 500,
                color: Palette.ink2,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class TextLink extends StatefulWidget {
  const TextLink(this.label, {super.key, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  State<TextLink> createState() => _TextLinkState();
}

class _TextLinkState extends State<TextLink> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final style = Fonts.sansStyle(
      size: 12.5,
      color: _hover ? Palette.ink : Palette.muted,
    );
    final painter = TextPainter(
      text: TextSpan(text: widget.label, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    final width = painter.width;
    painter.dispose();
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.label,
              style: style,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Palette.ease,
              width: _hover ? width : 0,
              height: 1,
              color: _hover ? Palette.ink : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}

class DividerLabel extends StatelessWidget {
  const DividerLabel(this.text, {super.key, this.top = 16, this.bottom = 11});

  final String text;
  final double top;
  final double bottom;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(top: top, bottom: bottom),
    child: Row(
      children: [
        const Expanded(
          child: ColoredBox(color: Palette.line2, child: SizedBox(height: 1)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            text.toUpperCase(),
            style: Fonts.monoStyle(
              size: 9.5,
              letterSpacing: 0.13 * 9.5,
              color: Palette.icon,
            ),
          ),
        ),
        const Expanded(
          child: ColoredBox(color: Palette.line2, child: SizedBox(height: 1)),
        ),
      ],
    ),
  );
}

class RoleChip extends StatefulWidget {
  const RoleChip({
    super.key,
    required this.label,
    required this.dot,
    this.onTap,
  });

  final String label;
  final Color dot;
  final VoidCallback? onTap;

  @override
  State<RoleChip> createState() => _RoleChipState();
}

class _RoleChipState extends State<RoleChip> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.click,
    onEnter: (_) => setState(() => _hover = true),
    onExit: (_) => setState(() => _hover = false),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: _hover ? 0.92 : 0.5),
        borderRadius: BorderRadius.circular(Scale.chipRadius),
        border: Border.all(color: _hover ? Palette.lineStrong : Palette.line),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(Scale.chipRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(Scale.chipRadius),
          onTap: widget.onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(9, 7, 11, 7),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Dot(color: widget.dot),
                const SizedBox(width: 6),
                Text(
                  widget.label,
                  style: Fonts.sansStyle(
                    size: 12,
                    color: _hover ? Palette.ink : Palette.ink2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class SegTabs extends StatelessWidget {
  const SegTabs({
    super.key,
    required this.items,
    required this.index,
    required this.onSelect,
  });

  final List<String> items;
  final int index;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Palette.wash,
      borderRadius: BorderRadius.circular(Scale.chipRadius),
    ),
    padding: const EdgeInsets.all(4),
    child: LayoutBuilder(
      builder: (context, box) {
        final step = (box.maxWidth - 8) / items.length;
        return Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              curve: Palette.ease,
              top: 0,
              bottom: 0,
              left: step * index,
              width: step,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.94),
                  borderRadius: BorderRadius.circular(Scale.chipRadius),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A0D1117),
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                    BoxShadow(
                      color: Color(0x2E0D1117),
                      blurRadius: 12,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: const SizedBox.expand(),
              ),
            ),
            Row(
              children: [
                for (var i = 0; i < items.length; i++)
                  Expanded(
                    child: _SegButton(
                      label: items[i],
                      selected: i == index,
                      onTap: () => onSelect(i),
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    ),
  );
}

class _SegButton extends StatelessWidget {
  const _SegButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    borderRadius: BorderRadius.circular(Scale.chipRadius),
    child: InkWell(
      borderRadius: BorderRadius.circular(Scale.chipRadius),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 9),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 280),
          style: Fonts.sansStyle(
            size: 13,
            weight: 500,
            color: selected ? Palette.ink : Palette.muted,
          ),
          textAlign: TextAlign.center,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(label, maxLines: 1, softWrap: false),
          ),
        ),
      ),
    ),
  );
}

class GlassCard extends StatelessWidget {
  const GlassCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final viewport = MediaQuery.sizeOf(context).width;
    final radius = Scale.cardRadius(viewport);
    final cardWidth = viewport < 420 ? null : Scale.cardWidth;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: cardWidth,
          decoration: BoxDecoration(
            color: Palette.glass,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: Palette.cardLine),
          ),
          padding: Scale.cardPadding(viewport),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 1,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0x00FFFFFF),
                      Color(0xF2FFFFFF),
                      Color(0x00FFFFFF),
                    ],
                  ),
                ),
              ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class ToastController {
  ToastController._(this._entry);

  final OverlayEntry _entry;

  static ToastController? _current;

  static void show(
    BuildContext context,
    String message, {
    bool error = false,
    int millis = 2600,
  }) {
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) return;
    _current?.dismiss();

    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => _ToastView(message: message, error: error),
    );
    overlay.insert(entry);
    final controller = ToastController._(entry);
    _current = controller;
    Timer(Duration(milliseconds: millis), () {
      if (_current == controller) _current = null;
      controller.dismiss();
    });
  }

  void dismiss() {
    _entry.markNeedsBuild();
    _entry.remove();
  }
}

class _ToastView extends StatefulWidget {
  const _ToastView({required this.message, required this.error});

  final String message;
  final bool error;

  @override
  State<_ToastView> createState() => _ToastViewState();
}

class _ToastViewState extends State<_ToastView> {
  bool _shown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _shown = true);
    });
  }

  @override
  Widget build(BuildContext context) => Positioned(
    left: 0,
    right: 0,
    bottom: 24,
    child: IgnorePointer(
      child: Center(
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 260),
          opacity: _shown ? 1 : 0,
          child: AnimatedSlide(
            duration: const Duration(milliseconds: 340),
            curve: Palette.ease,
            offset: _shown ? Offset.zero : const Offset(0, 0.12),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.sizeOf(context).width * 0.9,
              ),
              padding: const EdgeInsets.fromLTRB(13, 11, 16, 11),
              decoration: BoxDecoration(
                color: Palette.ink.withValues(alpha: 0.94),
                borderRadius: BorderRadius.circular(Scale.chipRadius),
                border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xB30D1117),
                    blurRadius: 40,
                    offset: Offset(0, 18),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _Dot(
                    size: 6,
                    color: widget.error ? Palette.rose : Palette.accent,
                    glow: true,
                  ),
                  const SizedBox(width: 9),
                  Flexible(
                    child: Text(
                      widget.message,
                      style: Fonts.sansStyle(
                        size: 12.5,
                        color: Palette.toastText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class UpperCaseFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final upper = newValue.text.toUpperCase();
    return newValue.copyWith(
      text: upper,
      selection: newValue.selection.isValid
          ? TextSelection.collapsed(offset: upper.length).extendTo(
              TextPosition(
                offset: (newValue.selection.end).clamp(0, upper.length),
              ),
            )
          : newValue.selection,
    );
  }
}
