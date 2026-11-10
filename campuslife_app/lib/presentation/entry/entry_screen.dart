import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../domain/entities.dart';
import '../shared/ocean/ocean_view.dart';
import '../shared/ocean/types.dart';
import '../shared/ocean/world.dart';
import '../shared/kit.dart';
import 'auth_card.dart';
import 'entry_widgets.dart';

class EntryScreen extends StatefulWidget {
  const EntryScreen({
    super.key,
    required this.world,
    required this.roster,
    required this.onLogin,
    required this.onParticipantSignup,
    required this.onOrganizerSignup,
    required this.onJoinRequest,
    this.onGuest,
    this.onForgot,
    this.onQuickLogin,
    this.onHistory,
  });

  final World world;
  final List<SharkSpec> roster;
  final LoginSubmit onLogin;
  final ParticipantSubmit onParticipantSignup;
  final OrganizerSubmit onOrganizerSignup;
  final JoinSubmit onJoinRequest;
  final VoidCallback? onGuest;
  final VoidCallback? onForgot;
  final void Function(UserRole role)? onQuickLogin;
  final VoidCallback? onHistory;

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  bool _registering = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Palette.paper,
      body: Stack(
        fit: StackFit.expand,
        children: [
          OceanView(scene: widget.world, onSplash: widget.world.splash),
          const VeilLayer(),
          SafeArea(
            child: Column(
              children: [
                _Topbar(gutter: Scale.gutter(size.width)),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      const pad = EdgeInsets.fromLTRB(16, 8, 16, 26);
                      return SingleChildScrollView(
                        padding: pad,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: (constraints.maxHeight - pad.vertical)
                                .clamp(0.0, double.infinity),
                          ),
                          child: Column(
                            // Keep tall mobile signup forms anchored while fields
                            // and validation messages change their height.
                            mainAxisAlignment: size.width < 720 && _registering
                                ? MainAxisAlignment.start
                                : MainAxisAlignment.center,
                            children: [
                              const RiseIn(
                                delay: Scale.eyebrowDelay,
                                child: Eyebrow(
                                  'TASKILLS · Мобильная разработка',
                                ),
                              ),
                              RiseIn(
                                delay: Scale.heroDelay,
                                child: HeroTitle(width: size.width),
                              ),
                              const RiseIn(
                                delay: Scale.subDelay,
                                child: Subtitle(),
                              ),
                              RiseIn(
                                delay: Scale.cardDelay,
                                distance: 18,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: (size.height * 0.03).clamp(16, 30),
                                  ),
                                  child: AuthCard(
                                    onTabChanged: (registering) => setState(
                                      () => _registering = registering,
                                    ),
                                    onLogin: widget.onLogin,
                                    onParticipantSignup:
                                        widget.onParticipantSignup,
                                    onOrganizerSignup: widget.onOrganizerSignup,
                                    onJoinRequest: widget.onJoinRequest,
                                    onGuest: widget.onGuest,
                                    onForgot: widget.onForgot,
                                    onQuickLogin: widget.onQuickLogin,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Topbar extends StatelessWidget {
  const _Topbar({required this.gutter});

  final double gutter;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(gutter, 16, gutter, 0),
    child: const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: BrandLockup(scale: 1),
          ),
        ),
      ],
    ),
  );
}

class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const _EmDash(),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            text.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Fonts.monoStyle(
              size: 10.5,
              weight: 500,
              letterSpacing: 0.16 * 10.5,
              color: Palette.accent,
            ),
          ),
        ),
        const SizedBox(width: 10),
        const _EmDash(),
      ],
    ),
  );
}

class _EmDash extends StatelessWidget {
  const _EmDash();

  @override
  Widget build(BuildContext context) => Container(
    width: 22,
    height: 1,
    color: Palette.accent.withValues(alpha: 0.4),
  );
}

class HeroTitle extends StatelessWidget {
  const HeroTitle({super.key, required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    final size = Fonts.heroSize(width);
    final shadowStyle =
        Fonts.sansStyle(
          size: size,
          weight: 500,
          letterSpacing: -0.036 * size,
          height: 1.04,
          color: Palette.ink,
        ).copyWith(
          shadows: const [
            Shadow(color: Color(0xEAF6F6F3), blurRadius: 26),
            Shadow(color: Color(0xCCF6F6F3), blurRadius: 7),
          ],
        );
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: size * 9),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: shadowStyle,
          children: [
            const TextSpan(text: "what's on your "),
            TextSpan(
              text: 'mind',
              style: Fonts.sansStyle(
                size: size,
                weight: 400,
                letterSpacing: -0.01 * size,
                height: 1.04,
                color: Palette.accent,
                style: FontStyle.italic,
                family: Fonts.serif,
                fallback: Fonts.serifFallback,
              ).copyWith(shadows: shadowStyle.shadows),
            ),
            const TextSpan(text: '?'),
          ],
        ),
      ),
    );
  }
}

class Subtitle extends StatelessWidget {
  const Subtitle({super.key});

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 46 * 6.75),
    child: Text(
      'Афиша школьных событий в одной ленте: находи встречи и вступай в организации по id.',
      textAlign: TextAlign.center,
      style: Fonts.sansStyle(size: 13.5, height: 1.5, color: Palette.ink2)
          .copyWith(
            shadows: const [
              Shadow(color: Color(0xF2F6F6F3), blurRadius: 18),
              Shadow(color: Color(0xE6F6F6F3), blurRadius: 5),
            ],
          ),
    ),
  );
}
