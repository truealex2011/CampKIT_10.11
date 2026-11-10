abstract final class AppRoutes {
  static const gate = '/';
  static const entry = '/entry';
  static const feed = '/feed';
  static const search = '/search';
  static const profile = '/profile';
  static const organizer = '/organizer';
  static const admin = '/admin';
  static const wizard = '/wizard';
}

class WizardArgs {
  const WizardArgs({required this.orgId, this.eventId});

  final String orgId;
  final String? eventId;
}
