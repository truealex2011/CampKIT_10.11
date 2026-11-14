library;

import 'package:flutter/material.dart';

import '../domain/entities.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.paper,
    required this.ink,
    required this.ink2,
    required this.muted,
    required this.accent,
    required this.gold,
    required this.rose,
    required this.mint,
    required this.icon,
    required this.placeholder,
    required this.footer,
    required this.toastText,
    required this.line,
    required this.line2,
    required this.cardLine,
    required this.lineStrong,
    required this.accentSoft,
    required this.accentLine,
    required this.roseLine,
    required this.roseSoft,
    required this.glass,
    required this.glassField,
    required this.glassFieldFocus,
    required this.wash,
    required this.washDeep,
  });

  final Color paper;
  final Color ink;
  final Color ink2;
  final Color muted;
  final Color accent;
  final Color gold;
  final Color rose;
  final Color mint;
  final Color icon;
  final Color placeholder;
  final Color footer;
  final Color toastText;
  final Color line;
  final Color line2;
  final Color cardLine;
  final Color lineStrong;
  final Color accentSoft;
  final Color accentLine;
  final Color roseLine;
  final Color roseSoft;
  final Color glass;
  final Color glassField;
  final Color glassFieldFocus;
  final Color wash;
  final Color washDeep;

  Color roleDot(UserRole role) => switch (role) {
    UserRole.participant => accent,
    UserRole.organizer => gold,
    UserRole.admin => ink,
  };

  static const light = AppColors(
    paper: Color(0xFFF6F6F3),
    ink: Color(0xFF0D1117),
    ink2: Color(0xFF39424F),
    muted: Color(0xFF7B8798),
    accent: Color(0xFF0E6B76),
    gold: Color(0xFFA97F31),
    rose: Color(0xFFB04A55),
    mint: Color(0xFF0B7A5E),
    icon: Color(0xFF9AA5B4),
    placeholder: Color(0xFFA5AEB9),
    footer: Color(0xFF8B95A3),
    toastText: Color(0xFFEEF2F6),
    line: Color(0x1C0D1117),
    line2: Color(0x0F0D1117),
    cardLine: Color(0x210D1117),
    lineStrong: Color(0x470D1117),
    accentSoft: Color(0x210E6B76),
    accentLine: Color(0x8C0E6B76),
    roseLine: Color(0x9E504A55),
    roseSoft: Color(0x24B04A55),
    glass: Color(0x94FFFFFF),
    glassField: Color(0x80FFFFFF),
    glassFieldFocus: Color(0xE0FFFFFF),
    wash: Color(0x0D0D1117),
    washDeep: Color(0x120D1117),
  );

  static const dark = AppColors(
    paper: Color(0xFF0B0F14),
    ink: Color(0xFFE9EDF2),
    ink2: Color(0xFFB9C3CF),
    muted: Color(0xFF8C97A6),
    accent: Color(0xFF5FD4DE),
    gold: Color(0xFFD8AE5B),
    rose: Color(0xFFE0808C),
    mint: Color(0xFF62C6A4),
    icon: Color(0xFF788899),
    placeholder: Color(0xFF5E6B78),
    footer: Color(0xFF738091),
    toastText: Color(0xFFEEF2F6),
    line: Color(0x2BFFFFFF),
    line2: Color(0x16FFFFFF),
    cardLine: Color(0x30FFFFFF),
    lineStrong: Color(0x60FFFFFF),
    accentSoft: Color(0x285FD4DE),
    accentLine: Color(0x9E5FD4DE),
    roseLine: Color(0x9EE0808C),
    roseSoft: Color(0x2BE0808C),
    glass: Color(0x94111720),
    glassField: Color(0x80111720),
    glassFieldFocus: Color(0xE017222D),
    wash: Color(0x0DFFFFFF),
    washDeep: Color(0x16FFFFFF),
  );

  @override
  AppColors copyWith({
    Color? paper,
    Color? ink,
    Color? ink2,
    Color? muted,
    Color? accent,
    Color? gold,
    Color? rose,
    Color? mint,
    Color? icon,
    Color? placeholder,
    Color? footer,
    Color? toastText,
    Color? line,
    Color? line2,
    Color? cardLine,
    Color? lineStrong,
    Color? accentSoft,
    Color? accentLine,
    Color? roseLine,
    Color? roseSoft,
    Color? glass,
    Color? glassField,
    Color? glassFieldFocus,
    Color? wash,
    Color? washDeep,
  }) => AppColors(
    paper: paper ?? this.paper,
    ink: ink ?? this.ink,
    ink2: ink2 ?? this.ink2,
    muted: muted ?? this.muted,
    accent: accent ?? this.accent,
    gold: gold ?? this.gold,
    rose: rose ?? this.rose,
    mint: mint ?? this.mint,
    icon: icon ?? this.icon,
    placeholder: placeholder ?? this.placeholder,
    footer: footer ?? this.footer,
    toastText: toastText ?? this.toastText,
    line: line ?? this.line,
    line2: line2 ?? this.line2,
    cardLine: cardLine ?? this.cardLine,
    lineStrong: lineStrong ?? this.lineStrong,
    accentSoft: accentSoft ?? this.accentSoft,
    accentLine: accentLine ?? this.accentLine,
    roseLine: roseLine ?? this.roseLine,
    roseSoft: roseSoft ?? this.roseSoft,
    glass: glass ?? this.glass,
    glassField: glassField ?? this.glassField,
    glassFieldFocus: glassFieldFocus ?? this.glassFieldFocus,
    wash: wash ?? this.wash,
    washDeep: washDeep ?? this.washDeep,
  );

  @override
  AppColors lerp(covariant AppColors? other, double t) => other == null
      ? this
      : AppColors(
          paper: Color.lerp(paper, other.paper, t)!,
          ink: Color.lerp(ink, other.ink, t)!,
          ink2: Color.lerp(ink2, other.ink2, t)!,
          muted: Color.lerp(muted, other.muted, t)!,
          accent: Color.lerp(accent, other.accent, t)!,
          gold: Color.lerp(gold, other.gold, t)!,
          rose: Color.lerp(rose, other.rose, t)!,
          mint: Color.lerp(mint, other.mint, t)!,
          icon: Color.lerp(icon, other.icon, t)!,
          placeholder: Color.lerp(placeholder, other.placeholder, t)!,
          footer: Color.lerp(footer, other.footer, t)!,
          toastText: Color.lerp(toastText, other.toastText, t)!,
          line: Color.lerp(line, other.line, t)!,
          line2: Color.lerp(line2, other.line2, t)!,
          cardLine: Color.lerp(cardLine, other.cardLine, t)!,
          lineStrong: Color.lerp(lineStrong, other.lineStrong, t)!,
          accentSoft: Color.lerp(accentSoft, other.accentSoft, t)!,
          accentLine: Color.lerp(accentLine, other.accentLine, t)!,
          roseLine: Color.lerp(roseLine, other.roseLine, t)!,
          roseSoft: Color.lerp(roseSoft, other.roseSoft, t)!,
          glass: Color.lerp(glass, other.glass, t)!,
          glassField: Color.lerp(glassField, other.glassField, t)!,
          glassFieldFocus: Color.lerp(
            glassFieldFocus,
            other.glassFieldFocus,
            t,
          )!,
          wash: Color.lerp(wash, other.wash, t)!,
          washDeep: Color.lerp(washDeep, other.washDeep, t)!,
        );
}

extension AppColorsContext on BuildContext {
  AppColors get colors =>
      Theme.of(this).extension<AppColors>() ?? AppColors.light;
}

abstract final class AppMotion {
  static const fast = Duration(milliseconds: 120);
  static const normal = Duration(milliseconds: 220);
  static const slow = Duration(milliseconds: 360);
  static const scene = Duration(milliseconds: 600);
  static const ambient = Duration(milliseconds: 2600);
  static const hold = Duration(seconds: 1);
  static const ease = Cubic(0.2, 0.8, 0.2, 1);
  static const spring = Curves.elasticOut;
  static const emphasized = Curves.easeOutBack;

  static Duration duration(BuildContext context, Duration value) =>
      MediaQuery.maybeDisableAnimationsOf(context) == true
          ? Duration.zero
          : value;
}

abstract final class AppRadius {
  static const pixel = 2.0;
  static const field = 14.0;
  static const card = 22.0;
  static const cardWide = 26.0;
  static const sheet = 30.0;
  static const chip = 999.0;
}

abstract final class AppShadows {
  static List<Shadow> textHalo(Color surface) => [
    Shadow(color: surface.withValues(alpha: 0.92), blurRadius: 26),
    Shadow(color: surface.withValues(alpha: 0.8), blurRadius: 7),
  ];

  static const card = [
    BoxShadow(color: Color(0x140D1117), blurRadius: 28, offset: Offset(0, 12)),
  ];
  static const floating = [
    BoxShadow(color: Color(0x260D1117), blurRadius: 42, offset: Offset(0, 18)),
  ];
  static const glow = [
    BoxShadow(color: Color(0x385FD4DE), blurRadius: 28, spreadRadius: -8),
  ];
}

abstract final class Palette {
  static const paper = Color(0xFFF6F6F3);
  static const ink = Color(0xFF0D1117);
  static const ink2 = Color(0xFF39424F);
  static const muted = Color(0xFF7B8798);
  static const accent = Color(0xFF0E6B76);
  static const gold = Color(0xFFA97F31);
  static const rose = Color(0xFFB04A55);
  static const mint = Color(0xFF0B7A5E);
  static const icon = Color(0xFF9AA5B4);
  static const placeholder = Color(0xFFA5AEB9);
  static const footer = Color(0xFF8B95A3);
  static const toastText = Color(0xFFEEF2F6);
  static const line = Color(0x1C0D1117);
  static const line2 = Color(0x0F0D1117);
  static const cardLine = Color(0x210D1117);
  static const lineStrong = Color(0x470D1117);
  static const accentSoft = Color(0x210E6B76);
  static const accentLine = Color(0x8C0E6B76);
  static const roseLine = Color(0x9E504A55);
  static const roseSoft = Color(0x24B04A55);
  static const glass = Color(0x94FFFFFF);
  static const glassField = Color(0x80FFFFFF);
  static const glassFieldFocus = Color(0xE0FFFFFF);
  static const wash = Color(0x0D0D1117);
  static const washDeep = Color(0x120D1117);
  static const darkPaper = Color(0xFF0B0F14);
  static const darkInk = Color(0xFFE9EDF2);
  static const darkInk2 = Color(0xFFB9C3CF);
  static const darkMuted = Color(0xFF8C97A6);
  static const darkAccent = Color(0xFF5FD4DE);
  static const darkLine = Color(0x2BFFFFFF);
  static const ease = AppMotion.ease;

  static Color roleDot(UserRole role) => switch (role) {
    UserRole.participant => accent,
    UserRole.organizer => gold,
    UserRole.admin => ink,
  };
}

abstract final class Fonts {
  static const mono = 'OceanMono';
  static const monoFallback = [
    'Cascadia Mono',
    'Consolas',
    'Menlo',
    'Courier New',
    'monospace',
  ];
  static const serif = 'Georgia';
  static const serifFallback = ['Times New Roman', 'serif'];
  static const sans = 'Manrope';
  static const sansFallback = [
    'Segoe UI',
    'Helvetica Neue',
    'Arial',
    'sans-serif',
  ];

  static TextStyle monoStyle({
    double size = 10,
    double weight = 400,
    double letterSpacing = 0.1,
    Color color = Palette.muted,
  }) => TextStyle(
    fontFamily: mono,
    fontFamilyFallback: monoFallback,
    fontSize: size,
    fontWeight: _weight(weight),
    letterSpacing: letterSpacing,
    color: color,
  );

  static TextStyle sansStyle({
    double size = 14,
    double weight = 400,
    double? letterSpacing,
    double? height,
    Color? color,
    FontStyle? style,
    String? family,
    List<String>? fallback,
  }) => TextStyle(
    fontFamily: family ?? sans,
    fontFamilyFallback: fallback ?? sansFallback,
    fontSize: size,
    fontWeight: _weight(weight),
    letterSpacing: letterSpacing,
    height: height,
    color: color,
    fontStyle: style,
  );

  static FontWeight _weight(double css) => switch (css.round()) {
    <= 100 => FontWeight.w100,
    200 => FontWeight.w200,
    300 => FontWeight.w300,
    400 => FontWeight.w400,
    500 => FontWeight.w500,
    600 => FontWeight.w600,
    700 => FontWeight.w700,
    800 => FontWeight.w800,
    _ => FontWeight.w900,
  };

  static double heroSize(double viewportWidth) =>
      (viewportWidth * 0.06).clamp(30.0, 50.0);
}

abstract final class Scale {
  static const railWidth = 74.0;
  static const railCell = 74.0;
  static const railIcon = 50.0;
  static const railGap = 8.0;
  static const railBottom = 111.0;
  static const railInset = 8.0;
  static const registrationReach = 153.0;
  static const captionInset = 20.0;
  static const cardWidth = 384.0;
  static const cardRadiusWide = AppRadius.cardWide;
  static const cardRadiusNarrow = AppRadius.card;
  static const fieldRadius = AppRadius.field;
  static const chipRadius = AppRadius.chip;

  static EdgeInsets cardPadding(double width) => width <= 420
      ? const EdgeInsets.fromLTRB(13, 13, 13, 15)
      : const EdgeInsets.fromLTRB(16, 15, 16, 17);

  static double cardRadius(double width) =>
      width <= 420 ? cardRadiusNarrow : cardRadiusWide;

  static double gutter(double width) => (width * 0.044).clamp(16.0, 40.0);

  static double stageTop(double height) => (height * 0.018).clamp(2.0, 20.0);

  static const eyebrowDelay = 0.05;
  static const heroDelay = 0.12;
  static const subDelay = 0.2;
  static const cardDelay = 0.28;
}

ThemeData buildTheme() {
  final base = ThemeData.light(useMaterial3: true);
  return base.copyWith(
    extensions: const [AppColors.light],
    scaffoldBackgroundColor: AppColors.light.paper,
    canvasColor: AppColors.light.paper,
    colorScheme: base.colorScheme.copyWith(
      primary: AppColors.light.ink,
      secondary: AppColors.light.accent,
      surface: AppColors.light.paper,
      onSurface: AppColors.light.ink,
      error: AppColors.light.rose,
    ),
    textTheme: base.textTheme.apply(
      bodyColor: AppColors.light.ink,
      displayColor: AppColors.light.ink,
      fontFamily: Fonts.sans,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.light.ink,
      selectionColor: AppColors.light.accentSoft,
      selectionHandleColor: AppColors.light.accent,
    ),
  );
}

ThemeData buildDarkTheme() {
  final base = ThemeData.dark(useMaterial3: true);
  return base.copyWith(
    extensions: const [AppColors.dark],
    scaffoldBackgroundColor: AppColors.dark.paper,
    canvasColor: AppColors.dark.paper,
    colorScheme: base.colorScheme.copyWith(
      primary: AppColors.dark.ink,
      secondary: AppColors.dark.accent,
      surface: AppColors.dark.paper,
      onSurface: AppColors.dark.ink,
      error: AppColors.dark.rose,
    ),
    textTheme: base.textTheme.apply(
      bodyColor: AppColors.dark.ink,
      displayColor: AppColors.dark.ink,
      fontFamily: Fonts.sans,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.dark.accent,
      selectionColor: AppColors.dark.accentSoft,
      selectionHandleColor: AppColors.dark.accent,
    ),
  );
}
