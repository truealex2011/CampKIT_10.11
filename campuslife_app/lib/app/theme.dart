library;

import 'package:flutter/material.dart';

import '../domain/entities.dart';

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

  static const ease = Cubic(0.2, 0.8, 0.2, 1);

  static Color roleDot(UserRole role) => switch (role) {
    UserRole.participant => accent,
    UserRole.organizer => gold,
    UserRole.admin => ink,
  };
}

abstract final class Fonts {
  static const mono = 'Consolas';
  static const monoFallback = [
    'Cascadia Mono',
    'Menlo',
    'Courier New',
    'monospace',
  ];
  static const serif = 'Georgia';
  static const serifFallback = ['Times New Roman', 'serif'];

  static const sans = 'Roboto';
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
    Color color = Palette.ink,
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
  static const cardWidth = 384.0;
  static const cardRadiusWide = 26.0;
  static const cardRadiusNarrow = 22.0;
  static const fieldRadius = 14.0;
  static const chipRadius = 999.0;

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
    scaffoldBackgroundColor: Palette.paper,
    canvasColor: Palette.paper,
    colorScheme: base.colorScheme.copyWith(
      primary: Palette.ink,
      secondary: Palette.accent,
      surface: Palette.paper,
      onSurface: Palette.ink,
      error: Palette.rose,
    ),
    textTheme: base.textTheme.apply(
      bodyColor: Palette.ink,
      displayColor: Palette.ink,
      fontFamily: Fonts.sans,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Palette.ink,
      selectionColor: Palette.accentSoft,
      selectionHandleColor: Palette.accent,
    ),
  );
}

ThemeData buildDarkTheme() {
  final base = ThemeData.dark(useMaterial3: true);
  return base.copyWith(
    scaffoldBackgroundColor: Palette.darkPaper,
    canvasColor: Palette.darkPaper,
    colorScheme: base.colorScheme.copyWith(
      primary: Palette.darkInk,
      secondary: Palette.darkAccent,
      surface: Palette.darkPaper,
      onSurface: Palette.darkInk,
      error: Palette.rose,
    ),
    textTheme: base.textTheme.apply(
      bodyColor: Palette.darkInk,
      displayColor: Palette.darkInk,
      fontFamily: Fonts.sans,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Palette.darkAccent,
      selectionColor: Palette.accentSoft,
      selectionHandleColor: Palette.darkAccent,
    ),
  );
}
