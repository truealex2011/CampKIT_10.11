enum UserRole { participant, organizer, admin }

extension UserRoleX on UserRole {
  String get label => switch (this) {
    UserRole.participant => 'Участник',
    UserRole.organizer => 'Организатор',
    UserRole.admin => 'Админ',
  };
}

enum OrgType { school, club, section, studSoviet, team }

extension OrgTypeX on OrgType {
  String get label => switch (this) {
    OrgType.school => 'Школа',
    OrgType.club => 'Клуб',
    OrgType.section => 'Секция',
    OrgType.studSoviet => 'Студсовет',
    OrgType.team => 'Спортивная команда',
  };
}

enum EventCategory {
  sport,
  art,
  science,
  contest,
  lecture,
  music,
  volunteer,
  outing,
}

extension EventCategoryX on EventCategory {
  String get label => switch (this) {
    EventCategory.sport => 'Спорт',
    EventCategory.art => 'Творчество',
    EventCategory.science => 'Наука',
    EventCategory.contest => 'Конкурсы',
    EventCategory.lecture => 'Лекции',
    EventCategory.music => 'Музыка',
    EventCategory.volunteer => 'Волонтёрство',
    EventCategory.outing => 'Выезды',
  };
}

enum EventStatus { draft, pendingReview, published, rejected, cancelled }

extension EventStatusX on EventStatus {
  String get label => switch (this) {
    EventStatus.draft => 'Черновик',
    EventStatus.pendingReview => 'На проверке',
    EventStatus.published => 'Опубликовано',
    EventStatus.rejected => 'Отклонено',
    EventStatus.cancelled => 'Отменено',
  };
}

enum MemberRole { owner, manager, member }

enum MemberStatus { pending, approved, declined, banned }

enum FieldType { text, number, url, yesNo, choice }

extension FieldTypeX on FieldType {
  String get label => switch (this) {
    FieldType.text => 'Текст',
    FieldType.number => 'Число',
    FieldType.url => 'Ссылка',
    FieldType.yesNo => 'Да/нет',
    FieldType.choice => 'Выбор из списка',
  };
}

enum MediaKind { video, photo }

enum ReportTarget { event, organizer }

enum ReportStatus {
  open,
  eventHidden,
  organizerWarned,
  organizerBlocked,
  dismissed,
}

enum ReminderOffset { oneHour, oneDay, custom }

extension ReminderOffsetX on ReminderOffset {
  String get label => switch (this) {
    ReminderOffset.oneHour => 'за 1 час',
    ReminderOffset.oneDay => 'за день',
    ReminderOffset.custom => 'свое время',
  };
}

class AppException implements Exception {
  const AppException(this.code, this.message);

  final String code;
  final String message;

  @override
  String toString() => message;
}

class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone = '',
    this.passwordHash = '',
    this.banned = false,
  });

  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String phone;
  final String passwordHash;
  final bool banned;
}

class Organization {
  const Organization({
    required this.id,
    required this.name,
    required this.type,
    required this.city,
    required this.ownerId,
    this.phone = '',
    this.email = '',
    this.logoPath,
    this.blocked = false,
    this.createdAtByKey,
  });

  final String id;
  final String name;
  final OrgType type;
  final String city;
  final String ownerId;
  final String phone;
  final String email;
  final String? logoPath;
  final bool blocked;
  final String? createdAtByKey;

  Organization copyWith({
    String? name,
    OrgType? type,
    String? city,
    String? phone,
    String? email,
    String? logoPath,
    bool? blocked,
  }) => Organization(
    id: id,
    name: name ?? this.name,
    type: type ?? this.type,
    city: city ?? this.city,
    ownerId: ownerId,
    phone: phone ?? this.phone,
    email: email ?? this.email,
    logoPath: logoPath ?? this.logoPath,
    blocked: blocked ?? this.blocked,
    createdAtByKey: createdAtByKey,
  );
}

class OrgMember {
  const OrgMember({
    required this.orgId,
    required this.userId,
    required this.role,
    required this.status,
    required this.requestedAt,
  });

  final String orgId;
  final String userId;
  final MemberRole role;
  final MemberStatus status;
  final DateTime requestedAt;
}

class EventMedia {
  const EventMedia({
    required this.id,
    required this.eventId,
    required this.kind,
    required this.path,
    this.previewPath,
    this.position = 0,
    this.durationMs = 0,
    this.bytes = 0,
  });

  final String id;
  final String eventId;
  final MediaKind kind;
  final String path;
  final String? previewPath;
  final int position;
  final int durationMs;
  final int bytes;
}

class CustomField {
  const CustomField({
    required this.id,
    required this.eventId,
    required this.label,
    required this.type,
    this.value = '',
    this.options = const [],
    this.position = 0,
  });

  final String id;
  final String eventId;
  final String label;
  final FieldType type;
  final String value;
  final List<String> options;
  final int position;

  CustomField move(int to) => CustomField(
    id: id,
    eventId: eventId,
    label: label,
    type: type,
    value: value,
    options: options,
    position: to,
  );
}

class CampusEvent {
  const CampusEvent({
    required this.id,
    required this.orgId,
    required this.title,
    required this.category,
    required this.startAt,
    required this.place,
    required this.status,
    this.description = '',
    this.capacity = -1,
    this.moderationNote = '',
    this.media = const [],
    this.fields = const [],
    this.cancelledAt,
  });

  final String id;
  final String orgId;
  final String title;
  final EventCategory category;
  final DateTime startAt;
  final String place;
  final EventStatus status;
  final String description;
  final int capacity;
  final String moderationNote;
  final List<EventMedia> media;
  final List<CustomField> fields;
  final DateTime? cancelledAt;

  List<EventMedia> get photos =>
      media.where((m) => m.kind == MediaKind.photo).toList(growable: false);

  EventMedia? get video {
    for (final m in media) {
      if (m.kind == MediaKind.video) return m;
    }
    return null;
  }

  CampusEvent copyWith({
    String? title,
    String? description,
    EventCategory? category,
    DateTime? startAt,
    String? place,
    int? capacity,
    EventStatus? status,
    String? moderationNote,
    List<EventMedia>? media,
    List<CustomField>? fields,
    DateTime? cancelledAt,
  }) => CampusEvent(
    id: id,
    orgId: orgId,
    title: title ?? this.title,
    description: description ?? this.description,
    category: category ?? this.category,
    startAt: startAt ?? this.startAt,
    place: place ?? this.place,
    capacity: capacity ?? this.capacity,
    status: status ?? this.status,
    moderationNote: moderationNote ?? this.moderationNote,
    media: media ?? this.media,
    fields: fields ?? this.fields,
    cancelledAt: cancelledAt ?? this.cancelledAt,
  );
}

class Registration {
  const Registration({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.createdAt,
    this.checkedInAt,
  });

  final String id;
  final String eventId;
  final String userId;
  final DateTime createdAt;
  final DateTime? checkedInAt;

  bool get isCheckedIn => checkedInAt != null;

  String get ticketCode => '$eventId:$userId';
}

class Favorite {
  const Favorite({
    required this.userId,
    required this.eventId,
    required this.createdAt,
  });

  final String userId;
  final String eventId;
  final DateTime createdAt;
}

class Reminder {
  const Reminder({
    required this.userId,
    required this.eventId,
    required this.fireAt,
    required this.offset,
  });

  final String userId;
  final String eventId;
  final DateTime fireAt;
  final ReminderOffset offset;
}

class Report {
  const Report({
    required this.id,
    required this.target,
    required this.reporterId,
    required this.reason,
    required this.status,
    required this.createdAt,
    this.eventId,
    this.organizerId,
    this.comment = '',
  });

  final String id;
  final ReportTarget target;
  final String reporterId;
  final String reason;
  final ReportStatus status;
  final DateTime createdAt;
  final String? eventId;
  final String? organizerId;
  final String comment;
}

class EventView {
  const EventView({
    required this.eventId,
    required this.userId,
    required this.viewedAt,
  });

  final String eventId;
  final String userId;
  final DateTime viewedAt;
}

class InviteKey {
  const InviteKey({
    required this.id,
    required this.keyHash,
    this.used = false,
    this.attempts = 0,
    this.orgId,
    this.createdAt,
    this.plainKey,
  });

  final String id;
  final String keyHash;
  final bool used;
  final int attempts;
  final String? orgId;
  final DateTime? createdAt;

  final String? plainKey;

  static const maxAttempts = 5;
}

class EventStats {
  const EventStats({
    required this.eventId,
    required this.views,
    required this.likes,
    required this.registrations,
    required this.checkedIn,
    required this.capacity,
  });

  final String eventId;
  final int views;
  final int likes;
  final int registrations;
  final int checkedIn;
  final int capacity;

  double get fillRate => capacity > 0 ? registrations / capacity : 0;
}

class DayCount {
  const DayCount({
    required this.date,
    required this.registrations,
    required this.views,
  });

  final DateTime date;
  final int registrations;
  final int views;
}

class TicketBundle {
  const TicketBundle({required this.event, required this.registration});

  final CampusEvent event;
  final Registration registration;
}
