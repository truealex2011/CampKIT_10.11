import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities.dart';
import '../presentation/admin/admin_home.dart';
import '../presentation/entry/entry_screen.dart';
import '../presentation/feed/feed_screen.dart';
import '../presentation/feed/search_screen.dart';
import '../presentation/organizer/event_wizard.dart';
import '../presentation/organizer/organizer_home.dart';
import '../presentation/profile/profile_screen.dart';
import '../presentation/shared/app_routes.dart';
import '../presentation/shared/kit.dart';
import '../presentation/shared/ocean/ocean_providers.dart';
import 'di.dart';
import 'theme.dart';

class CampusLifeApp extends ConsumerStatefulWidget {
  const CampusLifeApp({super.key});

  @override
  ConsumerState<CampusLifeApp> createState() => _CampusLifeAppState();
}

class _CampusLifeAppState extends ConsumerState<CampusLifeApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(sessionProvider.notifier).bootstrap();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(themeModeProvider);
    return MaterialApp(
      title: 'CampusLife',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ru'),
      supportedLocales: const [Locale('ru'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: buildTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: mode,
      initialRoute: AppRoutes.gate,
      routes: {
        AppRoutes.gate: (_) => const SessionGate(),
        AppRoutes.entry: (_) => const EntryRoute(),
        AppRoutes.feed: (_) => const FeedScreen(),
        AppRoutes.search: (_) => const SearchScreen(),
        AppRoutes.profile: (_) => const ProfileScreen(),
        AppRoutes.organizer: (_) => const OrganizerHomeScreen(),
        AppRoutes.admin: (_) => const AdminHomeScreen(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case AppRoutes.wizard:
            final args =
                settings.arguments as WizardArgs? ?? WizardArgs(orgId: '');
            return MaterialPageRoute(
              builder: (_) =>
                  EventWizard(orgId: args.orgId, eventId: args.eventId),
              settings: settings,
            );
          default:
            return MaterialPageRoute(
              builder: (_) => const SessionGate(),
              settings: settings,
            );
        }
      },
    );
  }
}

class SessionGate extends ConsumerWidget {
  const SessionGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(sessionProvider);
    if (user == null) return const EntryRoute();
    return switch (user.role) {
      UserRole.participant => const FeedScreen(),
      UserRole.organizer => const OrganizerHomeScreen(),
      UserRole.admin => const AdminHomeScreen(),
    };
  }
}

class EntryRoute extends ConsumerWidget {
  const EntryRoute({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return EntryScreen(
      world: ref.watch(oceanWorldProvider),
      roster: ref.watch(oceanRosterProvider),
      onLogin: (intent) async {
        try {
          await ref
              .read(sessionProvider.notifier)
              .signIn(intent.account, intent.password);
          if (!context.mounted) return null;
          Navigator.of(context).pushReplacementNamed(AppRoutes.gate);
          return null;
        } on AppException catch (e) {
          return e.message;
        }
      },
      onParticipantSignup: (signup) async {
        try {
          await ref
              .read(sessionProvider.notifier)
              .registerParticipant(
                name: signup.name,
                email: signup.email,
                phone: signup.phone,
                password: signup.password,
              );
          if (!context.mounted) return null;
          Navigator.of(context).pushReplacementNamed(AppRoutes.gate);
          return null;
        } on AppException catch (e) {
          return e.message;
        }
      },
      onOrganizerSignup: (signup) async {
        try {
          await ref.read(sessionProvider.notifier).registerOrganizer(signup);
          if (!context.mounted) return null;
          Navigator.of(context).pushReplacementNamed(AppRoutes.gate);
          return null;
        } on AppException catch (e) {
          return e.message;
        }
      },
      onJoinRequest: (intent) async {
        final user = ref.read(sessionProvider);
        if (user == null) return 'Сначала войди в аккаунт';
        try {
          await ref
              .read(repositoryProvider)
              .requestMembership(intent.orgId, user.id);
          return 'Заявка отправлена владельцу организации';
        } on AppException catch (e) {
          return e.message;
        }
      },
      onQuickLogin: (role) async {
        try {
          await ref.read(sessionProvider.notifier).signInAs(role);
          if (!context.mounted) return;
          Navigator.of(context).pushReplacementNamed(AppRoutes.gate);
        } on AppException catch (e) {
          if (context.mounted) _toast(context, e.message, error: true);
        }
      },
      onGuest: () => Navigator.of(context).pushReplacementNamed(AppRoutes.feed),
      onForgot: () =>
          _toast(context, 'Восстановлением пароля занимается сервер'),
    );
  }

  static void _toast(
    BuildContext context,
    String message, {
    bool error = false,
  }) => ToastController.show(context, message, error: error);
}
