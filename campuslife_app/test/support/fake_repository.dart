import 'package:campuslife_app/domain/entities.dart';
import 'package:campuslife_app/domain/repositories.dart';

class FakeCampusLifeRepository implements CampusLifeRepository {
  FakeCampusLifeRepository() {
    people.addAll([
      const User(
        id: 'usr_admin',
        name: 'Ирина Соколова',
        email: 'admin@campus.ru',
        phone: '+7 900 000-00-01',
        role: UserRole.admin,
        passwordHash: 'h-admin',
      ),
      const User(
        id: 'usr_org',
        name: 'Пётр Крылов',
        email: 'organizer@campus.ru',
        phone: '+7 900 000-00-02',
        role: UserRole.organizer,
        passwordHash: 'h-org',
      ),
      const User(
        id: 'usr_stu',
        name: 'Аня Морозова',
        email: 'student@campus.ru',
        phone: '+7 900 000-00-03',
        role: UserRole.participant,
        passwordHash: 'h-stu',
      ),
      const User(
        id: 'usr_stu2',
        name: 'Дима Ветров',
        email: 'dima@campus.ru',
        phone: '+7 900 000-00-04',
        role: UserRole.participant,
      ),
      const User(
        id: 'usr_stu3',
        name: 'Лена Тихая',
        email: 'lena@campus.ru',
        phone: '+7 900 000-00-05',
        role: UserRole.participant,
      ),
    ]);

    orgs.addAll([
      const Organization(
        id: 'org_studsovet',
        name: 'Студсовет ПМК',
        type: OrgType.studSoviet,
        city: 'Владивосток',
        ownerId: 'usr_org',
        phone: '+7 423 200-00-00',
        email: 'studsovet@campus.ru',
      ),
      const Organization(
        id: 'org_robo',
        name: 'Клуб робототехники',
        type: OrgType.club,
        city: 'Владивосток',
        ownerId: 'usr_org',
        phone: '+7 423 200-00-01',
        email: 'robo@campus.ru',
      ),
      const Organization(
        id: 'org_school21',
        name: 'Школа №21',
        type: OrgType.school,
        city: 'Уссурийск',
        ownerId: 'usr_stu2',
        blocked: true,
      ),
    ]);

    members.add(
      OrgMember(
        orgId: 'org_studsovet',
        userId: 'usr_stu2',
        role: MemberRole.member,
        status: MemberStatus.pending,
        requestedAt: _day,
      ),
    );

    events.addAll([
      _ev(
        id: 'evt_kvest',
        orgId: 'org_studsovet',
        title: 'Квест «Ночь в кампусе»',
        category: EventCategory.contest,
        startAt: _day.add(const Duration(days: 2, hours: 18)),
        place: 'Главный корпус, актовый зал',
        status: EventStatus.published,
        description:
            'Командная игра по станциям: логика, загадки и немного страха. '
            'Приходи в чёрной форме, команда до 5 человек.',
        capacity: 60,
      ),
      _ev(
        id: 'evt_hack',
        orgId: 'org_robo',
        title: 'Хакатон мини-дронов',
        category: EventCategory.science,
        startAt: _day.add(const Duration(days: 5, hours: 10)),
        place: 'Корпус Б, лаборатория 214',
        status: EventStatus.published,
        description: 'Двое суток на сборку и полётную программу дрона.',
        capacity: 24,
      ),
      _ev(
        id: 'evt_music',
        orgId: 'org_studsovet',
        title: 'Открытый микрофон',
        category: EventCategory.music,
        startAt: _day.add(const Duration(days: 1, hours: 19, minutes: 30)),
        place: 'Студенческая гостиная',
        status: EventStatus.published,
        description: 'Три минуты на себя: песня, стих или стендап.',
      ),
      _ev(
        id: 'evt_sport',
        orgId: 'org_studsovet',
        title: 'Волейбол со студсоветом',
        category: EventCategory.sport,
        startAt: _day.add(const Duration(days: 3, hours: 17)),
        place: 'Спортзал, корпус А',
        status: EventStatus.published,
        capacity: 30,
      ),
      _ev(
        id: 'evt_draft',
        orgId: 'org_robo',
        title: 'Мастер-класс по 3D-печати',
        category: EventCategory.lecture,
        startAt: _day.add(const Duration(days: 9, hours: 15)),
        place: 'Корпус Б, maker-_space',
        status: EventStatus.draft,
        fields: [
          const CustomField(
            id: 'fld_1',
            eventId: 'evt_draft',
            label: 'Опыт работы с принтером',
            type: FieldType.choice,
            options: ['нет', 'уверенный'],
          ),
        ],
      ),
      _ev(
        id: 'evt_review',
        orgId: 'org_robo',
        title: 'Лига дебатов',
        category: EventCategory.contest,
        startAt: _day.add(const Duration(days: 7, hours: 16)),
        place: 'Аудитория 108',
        status: EventStatus.pendingReview,
        capacity: 40,
      ),
      _ev(
        id: 'evt_hidden',
        orgId: 'org_studsovet',
        title: 'Скрытая вечеринка',
        category: EventCategory.outing,
        startAt: _day.add(const Duration(days: 4, hours: 21)),
        place: 'Загородный дом',
        status: EventStatus.rejected,
        moderationNote: 'Скрыто администратором',
      ),
    ]);

    regs.addAll([
      Registration(
        id: 'reg_1',
        eventId: 'evt_kvest',
        userId: 'usr_stu',
        createdAt: _day,
        checkedInAt: _day,
      ),
      Registration(
        id: 'reg_2',
        eventId: 'evt_kvest',
        userId: 'usr_stu2',
        createdAt: _day,
      ),
      Registration(
        id: 'reg_3',
        eventId: 'evt_music',
        userId: 'usr_stu',
        createdAt: _day,
      ),
    ]);

    views.addAll([
      for (var i = 0; i < 46; i++)
        EventView(viewedAt: _day, eventId: 'evt_kvest', userId: 'usr_stu2'),
      for (var i = 0; i < 21; i++)
        EventView(viewedAt: _day, eventId: 'evt_music', userId: 'usr_stu3'),
    ]);

    keys.add(
      InviteKey(
        id: 'key_1',
        keyHash: 'h_key_1',
        plainKey: 'CL-K3RT-7HQM',
        createdAt: _day,
      ),
    );
    keys.add(InviteKey(id: 'key_2', keyHash: 'h_key_2', used: true));

    reports.add(
      Report(
        id: 'rep_1',
        target: ReportTarget.event,
        reporterId: 'usr_stu3',
        eventId: 'evt_sport',
        reason: 'Недостоверная информация',
        status: ReportStatus.open,
        createdAt: _day,
        comment: 'Указано другое время сбора.',
      ),
    );
  }

  static final DateTime _day = DateTime(2026, 11, 6, 12);

  final List<User> people = [];
  final List<Organization> orgs = [];
  final List<OrgMember> members = [];
  final List<CampusEvent> events = [];
  final List<Registration> regs = [];
  final List<EventView> views = [];
  final List<Favorite> favs = [];
  final List<Reminder> reminders = [];
  final List<InviteKey> keys = [];
  final List<Report> reports = [];

  User? session;
  int bumps = 0;

  CampusEvent _ev({
    required String id,
    required String orgId,
    required String title,
    required EventCategory category,
    required DateTime startAt,
    required String place,
    required EventStatus status,
    String description = '',
    int capacity = -1,
    String moderationNote = '',
    List<CustomField> fields = const [],
  }) => CampusEvent(
    id: id,
    orgId: orgId,
    title: title,
    category: category,
    startAt: startAt,
    place: place,
    status: status,
    description: description,
    capacity: capacity,
    moderationNote: moderationNote,
    fields: fields,
  );

  Set<String> get _blockedOrgs =>
      orgs.where((o) => o.blocked).map((o) => o.id).toSet();

  List<CampusEvent> get _visible => [
    for (final e in events)
      if (e.status == EventStatus.published &&
          !_blockedOrgs.contains(e.orgId) &&
          e.moderationNote != 'Скрыто администратором')
        e,
  ];

  @override
  Future<void> warmUp() async {}

  @override
  Future<User> signIn(String account, String password) async {
    final user = people.firstWhere(
      (u) => u.id == account || u.email == account,
      orElse: () => throw const AppException('auth', 'Аккаунт не найден'),
    );
    if (user.banned) throw const AppException('auth', 'Аккаунт заблокирован');
    session = user;
    return user;
  }

  @override
  Future<User> signInAs(UserRole role) async {
    final user = people.firstWhere(
      (u) => u.role == role,
      orElse: () => throw const AppException('auth', 'Нет такого пользователя'),
    );
    session = user;
    return user;
  }

  @override
  Future<User> registerParticipant({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final user = User(
      id: 'usr_${people.length}',
      name: name,
      email: email,
      phone: phone,
      role: UserRole.participant,
    );
    people.add(user);
    session = user;
    return user;
  }

  @override
  Future<User> registerOrganizer(OrganizerSignup signup) async {
    final user = User(
      id: 'usr_new_org',
      name: signup.orgName,
      email: signup.email,
      phone: signup.phone,
      role: UserRole.organizer,
    );
    people.add(user);
    orgs.add(
      Organization(
        id: 'org_new',
        name: signup.orgName,
        type: signup.orgType,
        city: signup.city,
        ownerId: user.id,
        phone: signup.phone,
        email: signup.email,
      ),
    );
    session = user;
    return user;
  }

  @override
  Future<void> requestMembership(String orgId, String userId) async {
    members.add(
      OrgMember(
        orgId: orgId,
        userId: userId,
        role: MemberRole.member,
        status: MemberStatus.pending,
        requestedAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<User?> restoreSession() async => session;

  @override
  Future<void> signOut() async => session = null;

  @override
  Future<List<CampusEvent>> feed() async => _sorted(_visible);

  @override
  Future<CampusEvent?> eventById(String id) async {
    for (final e in events) {
      if (e.id == id) return e;
    }
    return null;
  }

  List<CampusEvent> _sorted(List<CampusEvent> list) {
    final copy = [...list]..sort((a, b) => a.startAt.compareTo(b.startAt));
    return copy;
  }

  @override
  Future<void> registerView(String eventId, String userId) async {
    views.add(EventView(eventId: eventId, userId: userId, viewedAt: _day));
  }

  @override
  Future<bool> toggleFavorite(String eventId, String userId) async {
    final i = favs.indexWhere(
      (f) => f.eventId == eventId && f.userId == userId,
    );
    if (i >= 0) {
      favs.removeAt(i);
      return false;
    }
    favs.add(Favorite(userId: userId, eventId: eventId, createdAt: _day));
    return true;
  }

  @override
  Future<bool> toggleRegistration(String eventId, String userId) async {
    final i = regs.indexWhere(
      (r) => r.eventId == eventId && r.userId == userId,
    );
    if (i >= 0) {
      regs.removeAt(i);
      return false;
    }
    regs.add(
      Registration(
        id: 'reg_${regs.length + 1}',
        eventId: eventId,
        userId: userId,
        createdAt: DateTime.now(),
      ),
    );
    return true;
  }

  @override
  Future<List<CampusEvent>> favorites(String userId) async {
    final ids = favs.where((f) => f.userId == userId).map((f) => f.eventId);
    return _sorted([
      for (final id in ids)
        for (final e in _visible)
          if (e.id == id) e,
    ]);
  }

  @override
  Future<List<String>> favoriteEventIds(String userId) async => [
    for (final f in favs)
      if (f.userId == userId) f.eventId,
  ];

  @override
  Future<List<TicketBundle>> myTickets(String userId) async => [
    for (final r in regs)
      if (r.userId == userId)
        TicketBundle(
          event: events.firstWhere((e) => e.id == r.eventId),
          registration: r,
        ),
  ];

  @override
  Future<void> setReminder(
    String eventId,
    String userId,
    ReminderOffset offset, {
    DateTime? customAt,
  }) async {
    reminders.removeWhere((r) => r.eventId == eventId && r.userId == userId);
    final event = events.firstWhere((e) => e.id == eventId);
    reminders.add(
      Reminder(
        userId: userId,
        eventId: eventId,
        fireAt: customAt ?? event.startAt.subtract(const Duration(hours: 1)),
        offset: offset,
      ),
    );
  }

  @override
  Future<void> clearReminder(String eventId, String userId) async {
    reminders.removeWhere((r) => r.eventId == eventId && r.userId == userId);
  }

  @override
  Future<Reminder?> reminderOf(String eventId, String userId) async {
    for (final r in reminders) {
      if (r.eventId == eventId && r.userId == userId) return r;
    }
    return null;
  }

  @override
  Future<void> submitReport({
    required String reporterId,
    required ReportTarget target,
    required String reason,
    String comment = '',
    String? eventId,
    String? organizerId,
  }) async {
    reports.add(
      Report(
        id: 'rep_${reports.length + 1}',
        target: target,
        reporterId: reporterId,
        reason: reason,
        status: ReportStatus.open,
        createdAt: DateTime.now(),
        eventId: eventId,
        organizerId: organizerId,
        comment: comment,
      ),
    );
  }

  @override
  Future<String> shareUrl(String eventId) async =>
      'https://campuslife.app/e/$eventId';

  @override
  Future<List<CampusEvent>> search({
    String query = '',
    Set<EventCategory> categories = const {},
    DateTime? from,
    DateTime? to,
  }) async {
    final q = query.trim().toLowerCase();
    return _sorted([
      for (final e in _visible)
        if ((q.isEmpty ||
            e.title.toLowerCase().contains(q) ||
            e.description.toLowerCase().contains(q) ||
            e.place.toLowerCase().contains(q)) &&
            (categories.isEmpty || categories.contains(e.category)) &&
            (from == null || !e.startAt.isBefore(from)) &&
            (to == null || !e.startAt.isAfter(to)))
          e,
    ]);
  }

  @override
  Future<Organization?> organizationById(String id) async {
    for (final o in orgs) {
      if (o.id == id) return o;
    }
    return null;
  }

  @override
  Future<List<CampusEvent>> eventsOf(String orgId) async => [
    for (final e in events)
      if (e.orgId == orgId) e,
  ];

  @override
  Future<CampusEvent> saveDraft(CampusEvent event) async {
    final i = events.indexWhere((e) => e.id == event.id);
    final saved = event.status == EventStatus.published
        ? event
        : event.copyWith(status: EventStatus.draft);
    if (i >= 0) {
      events[i] = saved;
    } else {
      events.add(saved);
    }
    await saveFields(saved.id, saved.fields);
    return saved;
  }

  @override
  Future<CampusEvent> publish(String eventId) async {
    final event = await _must(eventId);
    final updated = event.copyWith(
      status: EventStatus.pendingReview,
      moderationNote: '',
    );
    await _replace(updated);
    return updated;
  }

  @override
  Future<CampusEvent> cancel(String eventId) async {
    final event = await _must(eventId);
    final updated = event.copyWith(
      status: EventStatus.cancelled,
      cancelledAt: DateTime.now(),
    );
    await _replace(updated);
    return updated;
  }

  @override
  Future<void> deleteEvent(String eventId) async =>
      events.removeWhere((e) => e.id == eventId);

  Future<CampusEvent> _must(String id) async {
    final event = await eventById(id);
    if (event == null) throw const AppException('event', 'Событие не найдено');
    return event;
  }

  Future<void> _replace(CampusEvent event) async {
    final i = events.indexWhere((e) => e.id == event.id);
    if (i >= 0) {
      events[i] = event;
    } else {
      events.add(event);
    }
  }

  @override
  Future<List<OrgMember>> pendingMembers(String orgId) async => [
    for (final m in members)
      if (m.orgId == orgId && m.status == MemberStatus.pending) m,
  ];

  @override
  Future<void> resolveMembership(String orgId, String userId, bool approve) async {
    for (final m in members) {
      if (m.orgId == orgId && m.userId == userId) {
        members[members.indexOf(m)] = OrgMember(
          orgId: orgId,
          userId: userId,
          role: m.role,
          status: approve ? MemberStatus.approved : MemberStatus.declined,
          requestedAt: m.requestedAt,
        );
        return;
      }
    }
  }

  @override
  Future<void> attachMedia(EventMedia media) async {}

  @override
  Future<void> removeMedia(String mediaId) async {
    for (final e in events) {
      e.media.removeWhere((m) => m.id == mediaId);
    }
  }

  @override
  Future<void> reorderMedia(String eventId, List<String> orderedIds) async {}

  @override
  Future<void> saveFields(String eventId, List<CustomField> fields) async {
    if (fields.length > 10) {
      throw const AppException('fields', 'Не больше 10 своих полей');
    }
    final event = await _must(eventId);
    await _replace(
      event.copyWith(
        fields: [
          for (var i = 0; i < fields.length; i++) fields[i].move(i),
        ],
      ),
    );
  }

  @override
  Future<List<EventStats>> statsFor(String orgId, {DateTime? from, DateTime? to}) async {
    return [
      for (final e in events)
        if (e.orgId == orgId) await statsOf(e.id),
    ];
  }

  @override
  Future<List<DayCount>> dailyStats(String eventId) async => [
    DayCount(date: _day, registrations: 4, views: 12),
    DayCount(date: _day.add(const Duration(days: 1)), registrations: 7, views: 20),
    DayCount(date: _day.add(const Duration(days: 2)), registrations: 3, views: 9),
  ];

  @override
  Future<EventStats> statsOf(String eventId) async {
    final event = await _must(eventId);
    return EventStats(
      eventId: eventId,
      views: views.where((v) => v.eventId == eventId).length,
      likes: favs.where((f) => f.eventId == eventId).length,
      registrations: regs.where((r) => r.eventId == eventId).length,
      checkedIn:
          regs.where((r) => r.eventId == eventId && r.checkedInAt != null)
              .length,
      capacity: event.capacity,
    );
  }

  @override
  Future<Registration?> checkIn(String ticketCode) async {
    final parts = ticketCode.split(':');
    if (parts.length != 2) throw const AppException('qr', 'Билет не распознан');
    for (var i = 0; i < regs.length; i++) {
      final r = regs[i];
      if (r.eventId == parts[0] && r.userId == parts[1]) {
        if (r.checkedInAt != null) {
          throw const AppException('qr', 'Этот билет уже отмечен');
        }
        final updated = Registration(
          id: r.id,
          eventId: r.eventId,
          userId: r.userId,
          createdAt: r.createdAt,
          checkedInAt: DateTime.now(),
        );
        regs[i] = updated;
        return updated;
      }
    }
    throw const AppException('qr', 'Нет заявки на этот билет');
  }

  @override
  Future<List<Registration>> attendees(String eventId) async => [
    for (final r in regs)
      if (r.eventId == eventId) r,
  ];

  @override
  Future<InviteKey> mintInviteKey() async {
    final key = InviteKey(
      id: 'key_${keys.length + 1}',
      keyHash: 'h_key_${keys.length + 1}',
      createdAt: DateTime.now(),
      plainKey: 'CL-NEW-KEY',
    );
    keys.add(key);
    return key;
  }

  @override
  Future<List<InviteKey>> inviteKeys() async => keys;

  @override
  Future<List<CampusEvent>> moderationQueue() async => [
    for (final e in events)
      if (e.status == EventStatus.pendingReview) e,
  ];

  @override
  Future<CampusEvent> moderate(String eventId, bool approve, {String note = ''}) async {
    final event = await _must(eventId);
    final updated = event.copyWith(
      status: approve ? EventStatus.published : EventStatus.rejected,
      moderationNote: note,
    );
    await _replace(updated);
    return updated;
  }

  @override
  Future<List<User>> users() async => people;

  @override
  Future<List<Organization>> organizations() async => orgs;

  @override
  Future<List<CampusEvent>> allEvents() async => events;

  @override
  Future<void> blockUser(String userId, bool blocked) async {
    final i = people.indexWhere((u) => u.id == userId);
    if (i < 0) return;
    final u = people[i];
    people[i] = User(
      id: u.id,
      name: u.name,
      email: u.email,
      phone: u.phone,
      role: u.role,
      passwordHash: u.passwordHash,
      banned: blocked,
    );
  }

  @override
  Future<void> blockOrganization(String orgId, bool blocked) async {
    final i = orgs.indexWhere((o) => o.id == orgId);
    if (i < 0) return;
    orgs[i] = Organization(
      id: orgs[i].id,
      name: orgs[i].name,
      type: orgs[i].type,
      city: orgs[i].city,
      ownerId: orgs[i].ownerId,
      phone: orgs[i].phone,
      email: orgs[i].email,
      blocked: blocked,
    );
  }

  @override
  Future<List<Report>> openReports() async => [
    for (final r in reports)
      if (r.status == ReportStatus.open) r,
  ];

  @override
  Future<void> resolveReport(String reportId, ReportStatus action) async {
    final i = reports.indexWhere((r) => r.id == reportId);
    if (i < 0) return;
    final r = reports[i];
    reports[i] = Report(
      id: r.id,
      target: r.target,
      reporterId: r.reporterId,
      reason: r.reason,
      status: action,
      createdAt: r.createdAt,
      eventId: r.eventId,
      organizerId: r.organizerId,
      comment: r.comment,
    );
  }

  @override
  Future<AppCounters> counters() async => AppCounters(
    events: events.length,
    orgs: orgs.length,
    users: people.length,
    pendingModeration:
        events.where((e) => e.status == EventStatus.pendingReview).length,
    openReports: reports.where((r) => r.status == ReportStatus.open).length,
    activeInviteKeys: keys.where((k) => !k.used).length,
  );
}
