import 'entities.dart';

abstract interface class AuthRepository {
  Future<User> signIn(String account, String password);

  Future<User> signInAs(UserRole role);

  Future<User> registerParticipant({
    required String name,
    required String email,
    required String phone,
    required String password,
  });

  Future<User> registerOrganizer(OrganizerSignup signup);

  Future<void> requestMembership(String orgId, String userId);

  Future<User?> restoreSession();

  Future<void> signOut();
}

class OrganizerSignup {
  const OrganizerSignup({
    required this.inviteKey,
    required this.orgName,
    required this.orgType,
    required this.city,
    required this.phone,
    required this.email,
    required this.password,
  });

  final String inviteKey;
  final String orgName;
  final OrgType orgType;
  final String city;
  final String phone;
  final String email;
  final String password;
}

abstract interface class FeedRepository {
  Future<List<CampusEvent>> feed();

  Future<CampusEvent?> eventById(String id);

  Future<void> registerView(String eventId, String userId);

  Future<bool> toggleFavorite(String eventId, String userId);

  Future<bool> toggleRegistration(String eventId, String userId);

  Future<List<CampusEvent>> favorites(String userId);

  Future<List<TicketBundle>> myTickets(String userId);

  Future<void> setReminder(
    String eventId,
    String userId,
    ReminderOffset offset, {
    DateTime? customAt,
  });

  Future<void> clearReminder(String eventId, String userId);

  Future<Reminder?> reminderOf(String eventId, String userId);

  Future<void> submitReport({
    required String reporterId,
    required ReportTarget target,
    required String reason,
    String comment = '',
    String? eventId,
    String? organizerId,
  });

  Future<List<String>> favoriteEventIds(String userId);

  Future<String> shareUrl(String eventId);

  Future<List<CampusEvent>> search({
    String query = '',
    Set<EventCategory> categories = const {},
    DateTime? from,
    DateTime? to,
  });

  Future<Organization?> organizationById(String id);
}

abstract interface class OrganizerRepository {
  Future<List<CampusEvent>> eventsOf(String orgId);

  Future<CampusEvent> saveDraft(CampusEvent event);

  Future<CampusEvent> publish(String eventId);

  Future<CampusEvent> cancel(String eventId);

  Future<void> deleteEvent(String eventId);

  Future<List<OrgMember>> pendingMembers(String orgId);

  Future<void> resolveMembership(String orgId, String userId, bool approve);

  Future<void> attachMedia(EventMedia media);

  Future<void> removeMedia(String mediaId);

  Future<void> reorderMedia(String eventId, List<String> orderedIds);

  Future<void> saveFields(String eventId, List<CustomField> fields);

  Future<List<EventStats>> statsFor(
    String orgId, {
    DateTime? from,
    DateTime? to,
  });

  Future<List<DayCount>> dailyStats(String eventId);

  Future<EventStats> statsOf(String eventId);

  Future<Registration?> checkIn(String ticketCode);

  Future<List<Registration>> attendees(String eventId);
}

abstract interface class AdminRepository {
  Future<InviteKey> mintInviteKey();

  Future<List<InviteKey>> inviteKeys();

  Future<List<CampusEvent>> moderationQueue();

  Future<CampusEvent> moderate(
    String eventId,
    bool approve, {
    String note = '',
  });

  Future<List<User>> users();

  Future<List<Organization>> organizations();

  Future<List<CampusEvent>> allEvents();

  Future<void> blockUser(String userId, bool blocked);

  Future<void> blockOrganization(String orgId, bool blocked);

  Future<List<Report>> openReports();

  Future<void> resolveReport(String reportId, ReportStatus action);

  Future<AppCounters> counters();
}

class AppCounters {
  const AppCounters({
    required this.events,
    required this.orgs,
    required this.users,
    required this.pendingModeration,
    required this.openReports,
    required this.activeInviteKeys,
  });

  final int events;
  final int orgs;
  final int users;
  final int pendingModeration;
  final int openReports;
  final int activeInviteKeys;
}

abstract interface class CampusLifeRepository
    implements
        AuthRepository,
        FeedRepository,
        OrganizerRepository,
        AdminRepository {
  Future<void> warmUp();
}
