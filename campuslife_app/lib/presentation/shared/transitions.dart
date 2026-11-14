import 'package:flutter/material.dart';

import '../../app/theme.dart';

PageRoute<T> sharedAxisRoute<T>({
  required Widget child,
  RouteSettings? settings,
  bool forward = true,
}) => PageRouteBuilder<T>(
  settings: settings,
  pageBuilder: (context, animation, secondaryAnimation) => child,
  transitionDuration: AppMotion.slow,
  reverseTransitionDuration: AppMotion.normal,
  transitionsBuilder: (context, animation, secondaryAnimation, child) {
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) return child;
    final curved = CurvedAnimation(parent: animation, curve: AppMotion.ease);
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(forward ? 0.055 : -0.055, 0),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  },
);

class HeroCorner extends StatelessWidget {
  const HeroCorner({super.key, required this.tag, required this.child});

  final String tag;
  final Widget child;

  @override
  Widget build(BuildContext context) => Hero(
    tag: tag,
    flightShuttleBuilder: (context, animation, direction, from, to) =>
        ScaleTransition(scale: animation, child: to.widget),
    child: Material(color: Colors.transparent, child: child),
  );
}
