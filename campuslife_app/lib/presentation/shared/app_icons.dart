import 'package:flutter/widgets.dart';

/// Paths to PNG action icons used in the feed rail and onboarding.
///
/// Each action has a light variant (for dark backgrounds) and a dark variant
/// (for light backgrounds). The feed screen uses light icons on the dark
/// ocean backdrop.
abstract class AppIcons {
  static const String _basePath = 'assets/icons';

  /// Reminder bell icon (light variant for dark backgrounds)
  static const String reminderLight = '$_basePath/reminder_light.png';

  /// Reminder bell icon (dark variant for light backgrounds)
  static const String reminderDark = '$_basePath/reminder_dark.png';

  /// Heart/like icon (light variant for dark backgrounds)
  static const String likeLight = '$_basePath/like_light.png';

  /// Heart/like icon (dark variant for light backgrounds)
  static const String likeDark = '$_basePath/like_dark.png';

  /// Description/article icon (light variant for dark backgrounds)
  static const String descriptionLight = '$_basePath/description_light.png';

  /// Description/article icon (dark variant for light backgrounds)
  static const String descriptionDark = '$_basePath/description_dark.png';

  /// Share icon (light variant for dark backgrounds)
  static const String shareLight = '$_basePath/share_light.png';

  /// Share icon (dark variant for light backgrounds)
  static const String shareDark = '$_basePath/share_dark.png';

  /// Report/flag icon (light variant for dark backgrounds)
  static const String reportLight = '$_basePath/report_light.png';

  /// Report/flag icon (dark variant for light backgrounds)
  static const String reportDark = '$_basePath/report_dark.png';

  /// Returns the appropriate icon path for the given brightness.
  static String reminderFor(Brightness b) =>
      b == Brightness.dark ? reminderLight : reminderDark;

  static String likeFor(Brightness b) =>
      b == Brightness.dark ? likeLight : likeDark;

  static String descriptionFor(Brightness b) =>
      b == Brightness.dark ? descriptionLight : descriptionDark;

  static String shareFor(Brightness b) =>
      b == Brightness.dark ? shareLight : shareDark;

  static String reportFor(Brightness b) =>
      b == Brightness.dark ? reportLight : reportDark;

  /// All five action icons for onboarding (light variants).
  static const List<String> onboardingIcons = [
    reminderLight,
    likeLight,
    descriptionLight,
    shareLight,
    reportLight,
  ];
}

/// A widget that displays an action icon from a PNG asset.
class ActionIcon extends StatelessWidget {
  const ActionIcon({
    super.key,
    required this.path,
    this.size = 24,
    this.color,
    this.semanticLabel,
  });

  final String path;
  final double size;
  final Color? color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) => Image.asset(
        path,
        width: size,
        height: size,
        color: color,
        colorBlendMode: color != null ? BlendMode.srcIn : null,
        semanticLabel: semanticLabel,
        excludeFromSemantics: semanticLabel == null,
      );
}
