import 'package:flutter/widgets.dart';

/// Paths to PNG action icons and capsules extracted from the CampusLife sprite sheet.
///
/// Naming convention:
/// - `*_light`: bright glyph on dark frosted glass (for dark backgrounds / dark theme)
/// - `*_dark`: dark teal glyph on pearl glass (for light backgrounds / light theme)
abstract class AppIcons {
  static const String _basePath = 'assets/icons';

  // Main action circles
  static const String reminderLight = '$_basePath/reminder_light.png';
  static const String reminderDark = '$_basePath/reminder_dark.png';

  static const String likeLight = '$_basePath/like_light.png';
  static const String likeDark = '$_basePath/like_dark.png';

  static const String likeActiveLight = '$_basePath/like_active_light.png';
  static const String likeActiveDark = '$_basePath/like_active_dark.png';

  static const String descriptionLight = '$_basePath/description_light.png';
  static const String descriptionDark = '$_basePath/description_dark.png';

  static const String shareLight = '$_basePath/share_light.png';
  static const String shareDark = '$_basePath/share_dark.png';

  static const String bookmarkLight = '$_basePath/bookmark_light.png';
  static const String bookmarkDark = '$_basePath/bookmark_dark.png';

  static const String commentsLight = '$_basePath/comments_light.png';
  static const String commentsDark = '$_basePath/comments_dark.png';

  static const String repostLight = '$_basePath/repost_light.png';
  static const String repostDark = '$_basePath/repost_dark.png';

  // Secondary / utility circles
  static const String reportLight = '$_basePath/report_light.png';
  static const String reportDark = '$_basePath/report_dark.png';

  static const String categoriesLight = '$_basePath/categories_light.png';
  static const String categoriesDark = '$_basePath/categories_dark.png';

  static const String closeLight = '$_basePath/close_light.png';
  static const String closeDark = '$_basePath/close_dark.png';

  static const String checkLight = '$_basePath/check_light.png';
  static const String checkDark = '$_basePath/check_dark.png';

  static const String warningLight = '$_basePath/warning_light.png';
  static const String warningDark = '$_basePath/warning_dark.png';

  static const String playLight = '$_basePath/play_light.png';
  static const String playDark = '$_basePath/play_dark.png';

  // Swipe capsules
  static const String swipeLeftLight = '$_basePath/swipe_left_light.png';
  static const String swipeLeftDark = '$_basePath/swipe_left_dark.png';

  static const String swipeRightLight = '$_basePath/swipe_right_light.png';
  static const String swipeRightDark = '$_basePath/swipe_right_dark.png';

  // Standalone decorative glyphs
  static const String splashFishLight = '$_basePath/splash_fish_light.png';
  static const String splashFishDark = '$_basePath/splash_fish_dark.png';

  static const String heartGlyphLight = '$_basePath/heart_glyph_light.png';
  static const String heartGlyphDark = '$_basePath/heart_glyph_dark.png';

  static const String sparkleLight = '$_basePath/sparkle_light.png';
  static const String sparkleDark = '$_basePath/sparkle_dark.png';

  static const String fishHeartGlyphLight =
      '$_basePath/fish_heart_glyph_light.png';
  static const String fishHeartGlyphDark =
      '$_basePath/fish_heart_glyph_dark.png';

  static const String fishMiniLight = '$_basePath/fish_mini_light.png';
  static const String fishMiniDark = '$_basePath/fish_mini_dark.png';

  // Brightness selectors
  static String reminderFor(Brightness b) =>
      b == Brightness.dark ? reminderLight : reminderDark;

  static String likeFor(Brightness b, {bool active = false}) => active
      ? (b == Brightness.dark ? likeActiveLight : likeActiveDark)
      : (b == Brightness.dark ? likeLight : likeDark);

  static String descriptionFor(Brightness b) =>
      b == Brightness.dark ? descriptionLight : descriptionDark;

  static String shareFor(Brightness b) =>
      b == Brightness.dark ? shareLight : shareDark;

  static String reportFor(Brightness b) =>
      b == Brightness.dark ? reportLight : reportDark;

  static String categoriesFor(Brightness b) =>
      b == Brightness.dark ? categoriesLight : categoriesDark;

  static String closeFor(Brightness b) =>
      b == Brightness.dark ? closeLight : closeDark;

  static String checkFor(Brightness b) =>
      b == Brightness.dark ? checkLight : checkDark;

  static String warningFor(Brightness b) =>
      b == Brightness.dark ? warningLight : warningDark;

  static String playFor(Brightness b) =>
      b == Brightness.dark ? playLight : playDark;

  static String swipeLeftFor(Brightness b) =>
      b == Brightness.dark ? swipeLeftDark : swipeLeftLight;

  static String swipeRightFor(Brightness b) =>
      b == Brightness.dark ? swipeRightDark : swipeRightLight;

  static String fishHeartFor(Brightness b) =>
      b == Brightness.dark ? fishHeartGlyphLight : fishHeartGlyphDark;

  static const List<String> onboardingIcons = [
    reminderLight,
    likeLight,
    descriptionLight,
    shareLight,
    reportLight,
  ];
}

/// Displays a glass/action PNG sprite at its true rendered colors without tint clobbering.
class ActionIcon extends StatelessWidget {
  const ActionIcon({
    super.key,
    required this.path,
    this.size = 24,
    this.color,
    this.semanticLabel,
    this.fit = BoxFit.contain,
  });

  final String path;
  final double size;
  final Color? color;
  final String? semanticLabel;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) => Image.asset(
    path,
    width: size,
    height: size,
    fit: fit,
    color: color,
    colorBlendMode: color != null ? BlendMode.modulate : null,
    filterQuality: FilterQuality.high,
    semanticLabel: semanticLabel,
    excludeFromSemantics: semanticLabel == null,
  );
}
