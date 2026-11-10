import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities.dart';
import '../domain/repositories.dart';

final repositoryProvider = Provider<CampusLifeRepository>(
  (ref) => throw UnimplementedError(
    'repositoryProvider must be overridden in main()',
  ),
);

class Session extends Notifier<User?> {
  @override
  User? build() => null;

  Future<void> bootstrap() async {
    state = await ref.read(repositoryProvider).restoreSession();
  }

  Future<User> signIn(String account, String password) async {
    final user = await ref.read(repositoryProvider).signIn(account, password);
    state = user;
    return user;
  }

  Future<User> signInAs(UserRole role) async {
    final user = await ref.read(repositoryProvider).signInAs(role);
    state = user;
    return user;
  }

  Future<User> registerParticipant({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final user = await ref
        .read(repositoryProvider)
        .registerParticipant(
          name: name,
          email: email,
          phone: phone,
          password: password,
        );
    state = user;
    return user;
  }

  Future<User> registerOrganizer(OrganizerSignup signup) async {
    final user = await ref.read(repositoryProvider).registerOrganizer(signup);
    state = user;
    return user;
  }

  Future<void> signOut() async {
    await ref.read(repositoryProvider).signOut();
    state = null;
  }

  void replace(User? user) => state = user;
}

final sessionProvider = NotifierProvider<Session, User?>(Session.new);

final currentRoleProvider = Provider<UserRole?>(
  (ref) => ref.watch(sessionProvider)?.role,
);

class ThemeModeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.light;

  void set(ThemeMode mode) => state = mode;

  void toggle() => state = switch (state) {
    ThemeMode.light => ThemeMode.dark,
    ThemeMode.dark => ThemeMode.light,
    ThemeMode.system => ThemeMode.light,
  };
}

final themeModeProvider = NotifierProvider<ThemeModeController, ThemeMode>(
  ThemeModeController.new,
);

final revisionProvider = NotifierProvider<Revision, int>(Revision.new);

class Revision extends Notifier<int> {
  @override
  int build() => 0;

  void bump() => state = state + 1;
}

final feedProvider = FutureProvider<List<CampusEvent>>((ref) async {
  ref.watch(revisionProvider);
  return ref.watch(repositoryProvider).feed();
});

final searchResultsProvider =
    FutureProvider.family<List<CampusEvent>, FeedFilter>((ref, filter) async {
      ref.watch(revisionProvider);
      return ref
          .watch(repositoryProvider)
          .search(
            query: filter.query,
            categories: filter.categories,
            from: filter.from,
            to: filter.to,
          );
    });

class FeedFilter {
  const FeedFilter({
    this.query = '',
    this.categories = const {},
    this.from,
    this.to,
  });

  final String query;
  final Set<EventCategory> categories;
  final DateTime? from;
  final DateTime? to;
}

final eventProvider = FutureProvider.family<CampusEvent?, String>((
  ref,
  id,
) async {
  ref.watch(revisionProvider);
  return ref.watch(repositoryProvider).eventById(id);
});

final favoritesProvider = FutureProvider<List<CampusEvent>>((ref) async {
  ref.watch(revisionProvider);
  final user = ref.watch(sessionProvider);
  if (user == null) return const [];
  return ref.watch(repositoryProvider).favorites(user.id);
});

final favoriteIdsProvider = FutureProvider<Set<String>>((ref) async {
  ref.watch(revisionProvider);
  final user = ref.watch(sessionProvider);
  if (user == null) return const {};
  return (await ref.watch(repositoryProvider).favoriteEventIds(user.id))
      .toSet();
});

final ticketsProvider = FutureProvider<List<TicketBundle>>((ref) async {
  ref.watch(revisionProvider);
  final user = ref.watch(sessionProvider);
  if (user == null) return const [];
  return ref.watch(repositoryProvider).myTickets(user.id);
});

final organizerEventsProvider =
    FutureProvider.family<List<CampusEvent>, String>((ref, orgId) async {
      ref.watch(revisionProvider);
      return ref.watch(repositoryProvider).eventsOf(orgId);
    });

final organizerOrgsProvider = FutureProvider<List<Organization>>((ref) async {
  ref.watch(revisionProvider);
  final user = ref.watch(sessionProvider);
  if (user == null || user.role == UserRole.participant) return const [];
  return ref
      .watch(repositoryProvider)
      .organizations()
      .then(
        (all) => all.where((o) => o.ownerId == user.id).toList(growable: false),
      );
});

final moderationQueueProvider = FutureProvider<List<CampusEvent>>((ref) async {
  ref.watch(revisionProvider);
  return ref.watch(repositoryProvider).moderationQueue();
});

final inviteKeysProvider = FutureProvider<List<InviteKey>>((ref) async {
  ref.watch(revisionProvider);
  return ref.watch(repositoryProvider).inviteKeys();
});

final openReportsProvider = FutureProvider<List<Report>>((ref) async {
  ref.watch(revisionProvider);
  return ref.watch(repositoryProvider).openReports();
});

final adminCountersProvider = FutureProvider<AppCounters?>((ref) async {
  ref.watch(revisionProvider);
  return ref.watch(repositoryProvider).counters();
});
