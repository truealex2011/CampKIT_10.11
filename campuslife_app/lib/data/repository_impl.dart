import 'package:drift/drift.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/entities.dart';
import '../domain/repositories.dart';
import 'crypto.dart';
import 'database.dart' hide EventMedia;
import 'mappers.dart';
import 'seed.dart';

class LocalRepository implements CampusLifeRepository {
  LocalRepository(this._db, this._prefs);

  final AppDatabase _db;
  final SharedPreferences _prefs;

  static const _sessionKey = 'campuslife.session.userId';

  @override
  Future<void> warmUp() => seedIfEmpty(_db);

  Future<void> _openSession(String userId) =>
      _prefs.setString(_sessionKey, userId);

  Future<User> _userById(String id) async {
    final row = await (_db.select(
      _db.users,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (row == null) {
      throw const AppException('user', 'Пользователь не найден');
    }
    return row.toUser();
  }

  Future<void> _checkNotBanned(UserRow row) async {
    if (row.banned) {
      throw const AppException(
        'banned',
        'Аккаунт заблокирован администратором',
      );
    }
  }

  @override
  Future<User> signIn(String account, String password) async {
    final login = account.trim().toLowerCase();
    final rows = await _db.select(_db.users).get();
    UserRow? found;
    for (final row in rows) {
      if (row.email.toLowerCase() == login ||
          row.phone.trim() == account.trim()) {
        found = row;
        break;
      }
    }
    if (found == null) {
      throw const AppException('auth', 'Аккаунт с такой почтой не найден');
    }
    await _checkNotBanned(found);
    if (found.passwordHash.isEmpty) {
      throw const AppException('auth', 'На этом аккаунте пароль не задан');
    }
    if (found.passwordHash != hashSecret(password)) {
      throw const AppException('auth', 'Неверный пароль');
    }
    await _openSession(found.id);
    return found.toUser();
  }

  @override
  Future<User> signInAs(UserRole role) async {
    final rows = await (_db.select(
      _db.users,
    )..where((t) => t.role.equals(role.name))).get();
    if (rows.isEmpty) {
      throw const AppException('auth', 'Демо-аккаунт для этой роли не найден');
    }
    await _checkNotBanned(rows.first);
    await _openSession(rows.first.id);
    return rows.first.toUser();
  }

  @override
  Future<User> registerParticipant({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    await _ensureEmailFree(email);
    final id = newId('u');
    await _db
        .into(_db.users)
        .insert(
          UsersCompanion.insert(
            id: id,
            name: name.trim(),
            email: email.trim(),
            role: UserRole.participant.name,
            phone: Value(phone.trim()),
            passwordHash: Value(hashSecret(password)),
          ),
        );
    await _openSession(id);
    return _userById(id);
  }

  Future<void> _ensureEmailFree(String email) async {
    final rows = await (_db.select(
      _db.users,
    )..where((t) => t.email.equals(email.trim()))).get();
    if (rows.isNotEmpty) {
      throw const AppException('email', 'Такая почта уже зарегистрирована');
    }
  }

  @override
  Future<User> registerOrganizer(OrganizerSignup signup) async {
    final keyHash = hashSecret(signup.inviteKey);
    final key = await (_db.select(
      _db.inviteKeys,
    )..where((t) => t.keyHash.equals(keyHash))).getSingleOrNull();
    if (key == null) {
      throw const AppException(
        'invite',
        'Ключ не найден. Запроси его у админа',
      );
    }
    if (key.used) {
      throw const AppException('invite', 'Этот ключ уже использован');
    }
    if (key.attempts >= InviteKey.maxAttempts) {
      throw const AppException('invite', 'Попытки по этому ключу исчерпаны');
    }
    await _ensureEmailFree(signup.email);
    await (_db.update(_db.inviteKeys)..where((t) => t.id.equals(key.id))).write(
      InviteKeysCompanion(attempts: Value(key.attempts + 1)),
    );
    final userId = newId('u');
    final orgId = newId('org');
    await _db
        .into(_db.users)
        .insert(
          UsersCompanion.insert(
            id: userId,
            name: signup.orgName.trim(),
            email: signup.email.trim(),
            role: UserRole.organizer.name,
            phone: Value(signup.phone.trim()),
            passwordHash: Value(hashSecret(signup.password)),
          ),
        );
    await _db
        .into(_db.organizations)
        .insert(
          OrganizationsCompanion.insert(
            id: orgId,
            name: signup.orgName.trim(),
            type: signup.orgType.name,
            city: signup.city.trim(),
            ownerId: userId,
            phone: Value(signup.phone.trim()),
            email: Value(signup.email.trim()),
            createdAtByKey: Value(key.id),
          ),
        );
    await _db
        .into(_db.organizationMembers)
        .insert(
          OrganizationMembersCompanion.insert(
            orgId: orgId,
            userId: userId,
            role: MemberRole.owner.name,
            status: MemberStatus.approved.name,
            requestedAt: DateTime.now(),
          ),
        );
    await (_db.update(_db.inviteKeys)..where((t) => t.id.equals(key.id))).write(
      InviteKeysCompanion(used: const Value(true), orgId: Value(orgId)),
    );
    await _openSession(userId);
    return _userById(userId);
  }

  @override
  Future<void> requestMembership(String orgId, String userId) async {
    final org = await organizationById(orgId);
    if (org == null) {
      throw const AppException('org', 'Организация с таким id не найдена');
    }
    if (org.blocked) {
      throw const AppException('org', 'Организация заблокирована');
    }
    final existing =
        await (_db.select(_db.organizationMembers)
              ..where((t) => t.orgId.equals(orgId) & t.userId.equals(userId)))
            .getSingleOrNull();
    if (existing != null && existing.status == MemberStatus.approved.name) {
      throw const AppException('member', 'Ты уже состоишь в этой организации');
    }
    await _db
        .into(_db.organizationMembers)
        .insert(
          OrganizationMembersCompanion.insert(
            orgId: orgId,
            userId: userId,
            role: MemberRole.member.name,
            status: MemberStatus.pending.name,
            requestedAt: DateTime.now(),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  @override
  Future<User?> restoreSession() async {
    final id = _prefs.getString(_sessionKey);
    if (id == null) return null;
    final row = await (_db.select(
      _db.users,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (row == null || row.banned) return null;
    return row.toUser();
  }

  @override
  Future<void> signOut() => _prefs.remove(_sessionKey);

  Future<List<CampusEvent>> _withDetails(List<EventRow> rows) async {
    if (rows.isEmpty) return const [];
    final media = await _db.select(_db.eventMedia).get();
    final fields = await _db.select(_db.eventCustomFields).get();
    return [
      for (final row in rows)
        row.toEvent().copyWith(
          media: [
            for (final m in media)
              if (m.eventId == row.id) m.toMedia(),
          ]..sort((a, b) => a.position.compareTo(b.position)),
          fields: [
            for (final f in fields)
              if (f.eventId == row.id) f.toField(),
          ]..sort((a, b) => a.position.compareTo(b.position)),
        ),
    ];
  }

  Future<Set<String>> _blockedOrgIds() async {
    final rows = await (_db.select(
      _db.organizations,
    )..where((t) => t.blocked.equals(true))).get();
    return {for (final row in rows) row.id};
  }

  @override
  Future<List<CampusEvent>> feed() async {
    final rows =
        await (_db.select(_db.events)
              ..where((t) => t.status.equals(EventStatus.published.name))
              ..orderBy([(t) => OrderingTerm.asc(t.startAt)]))
            .get();
    final blocked = await _blockedOrgIds();
    return _withDetails([
      for (final row in rows)
        if (!blocked.contains(row.orgId)) row,
    ]);
  }

  @override
  Future<CampusEvent?> eventById(String id) async {
    final row = await (_db.select(
      _db.events,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (row == null) return null;
    return (await _withDetails([row])).first;
  }

  @override
  Future<void> registerView(String eventId, String userId) => _db
      .into(_db.eventViews)
      .insert(
        EventViewsCompanion.insert(
          eventId: eventId,
          userId: userId,
          viewedAt: DateTime.now(),
        ),
      );

  @override
  Future<bool> toggleFavorite(String eventId, String userId) async {
    final existing =
        await (_db.select(_db.favorites)..where(
              (t) => t.userId.equals(userId) & t.eventId.equals(eventId),
            ))
            .getSingleOrNull();
    if (existing != null) {
      await (_db.delete(_db.favorites)
            ..where((t) => t.userId.equals(userId) & t.eventId.equals(eventId)))
          .go();
      return false;
    }
    await _db
        .into(_db.favorites)
        .insert(
          FavoritesCompanion.insert(
            userId: userId,
            eventId: eventId,
            createdAt: DateTime.now(),
          ),
        );
    return true;
  }

  @override
  Future<bool> toggleRegistration(String eventId, String userId) async {
    final existing =
        await (_db.select(_db.registrations)..where(
              (t) => t.eventId.equals(eventId) & t.userId.equals(userId),
            ))
            .getSingleOrNull();
    if (existing != null) {
      await (_db.delete(
        _db.registrations,
      )..where((t) => t.id.equals(existing.id))).go();
      return false;
    }
    final event = await eventById(eventId);
    if (event == null) {
      throw const AppException('event', 'Событие не найдено');
    }
    if (event.status == EventStatus.cancelled) {
      throw const AppException('event', 'Событие отменено организатором');
    }
    if (event.capacity > 0) {
      final current = await (_db.select(
        _db.registrations,
      )..where((t) => t.eventId.equals(eventId))).get();
      if (current.length >= event.capacity) {
        throw const AppException('capacity', 'Свободных мест не осталось');
      }
    }
    await _db
        .into(_db.registrations)
        .insert(
          RegistrationsCompanion.insert(
            id: newId('reg'),
            eventId: eventId,
            userId: userId,
            createdAt: DateTime.now(),
          ),
        );
    return true;
  }

  @override
  Future<List<CampusEvent>> favorites(String userId) async {
    final rows =
        await (_db.select(_db.favorites)
              ..where((t) => t.userId.equals(userId))
              ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
            .get();
    final result = <CampusEvent>[];
    for (final row in rows) {
      final event = await eventById(row.eventId);
      if (event != null) result.add(event);
    }
    return result;
  }

  @override
  Future<List<TicketBundle>> myTickets(String userId) async {
    final rows = await (_db.select(
      _db.registrations,
    )..where((t) => t.userId.equals(userId))).get();
    final bundles = <TicketBundle>[];
    for (final row in rows) {
      final event = await eventById(row.eventId);
      if (event != null) {
        bundles.add(
          TicketBundle(event: event, registration: row.toRegistration()),
        );
      }
    }
    bundles.sort((a, b) => a.event.startAt.compareTo(b.event.startAt));
    return bundles;
  }

  @override
  Future<void> setReminder(
    String eventId,
    String userId,
    ReminderOffset offset, {
    DateTime? customAt,
  }) async {
    final event = await eventById(eventId);
    if (event == null) {
      throw const AppException('event', 'Событие не найдено');
    }
    final fireAt = switch (offset) {
      ReminderOffset.oneHour => event.startAt.subtract(
        const Duration(hours: 1),
      ),
      ReminderOffset.oneDay => event.startAt.subtract(const Duration(days: 1)),
      ReminderOffset.custom => customAt ?? event.startAt,
    };
    await _db
        .into(_db.reminders)
        .insert(
          RemindersCompanion.insert(
            userId: userId,
            eventId: eventId,
            fireAt: fireAt,
            offset: offset.name,
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  @override
  Future<void> clearReminder(String eventId, String userId) => (_db.delete(
    _db.reminders,
  )..where((t) => t.userId.equals(userId) & t.eventId.equals(eventId))).go();

  @override
  Future<Reminder?> reminderOf(String eventId, String userId) async {
    final row =
        await (_db.select(_db.reminders)..where(
              (t) => t.userId.equals(userId) & t.eventId.equals(eventId),
            ))
            .getSingleOrNull();
    return row?.toReminder();
  }

  @override
  Future<void> submitReport({
    required String reporterId,
    required ReportTarget target,
    required String reason,
    String comment = '',
    String? eventId,
    String? organizerId,
  }) => _db
      .into(_db.reports)
      .insert(
        ReportsCompanion.insert(
          id: newId('rep'),
          target: target.name,
          reporterId: reporterId,
          reason: reason,
          status: ReportStatus.open.name,
          createdAt: DateTime.now(),
          eventId: Value(eventId),
          organizerId: Value(organizerId),
          comment: Value(comment),
        ),
      );

  @override
  Future<List<String>> favoriteEventIds(String userId) async {
    final rows = await (_db.select(
      _db.favorites,
    )..where((t) => t.userId.equals(userId))).get();
    return [for (final row in rows) row.eventId];
  }

  @override
  Future<String> shareUrl(String eventId) async =>
      'https://campus.life/e/$eventId';

  @override
  Future<List<CampusEvent>> search({
    String query = '',
    Set<EventCategory> categories = const {},
    DateTime? from,
    DateTime? to,
  }) async {
    final rows = await (_db.select(
      _db.events,
    )..where((t) => t.status.equals(EventStatus.published.name))).get();
    final blocked = await _blockedOrgIds();
    final needle = query.trim().toLowerCase();
    final filtered = [
      for (final row in rows)
        if (!blocked.contains(row.orgId) &&
            (categories.isEmpty ||
                categories.any((c) => c.name == row.category)) &&
            (from == null || !row.startAt.isBefore(from)) &&
            (to == null || !row.startAt.isAfter(to)) &&
            (needle.isEmpty ||
                row.title.toLowerCase().contains(needle) ||
                row.description.toLowerCase().contains(needle) ||
                row.place.toLowerCase().contains(needle)))
          row,
    ]..sort((a, b) => a.startAt.compareTo(b.startAt));
    return _withDetails(filtered);
  }

  @override
  Future<Organization?> organizationById(String id) async {
    final row = await (_db.select(
      _db.organizations,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return row?.toOrganization();
  }

  @override
  Future<List<CampusEvent>> eventsOf(String orgId) async {
    final rows =
        await (_db.select(_db.events)
              ..where((t) => t.orgId.equals(orgId))
              ..orderBy([(t) => OrderingTerm.desc(t.startAt)]))
            .get();
    return _withDetails(rows);
  }

  @override
  Future<CampusEvent> saveDraft(CampusEvent event) async {
    await _db
        .into(_db.events)
        .insert(
          EventsCompanion.insert(
            id: event.id,
            orgId: event.orgId,
            title: event.title,
            description: Value(event.description),
            category: event.category.name,
            startAt: event.startAt,
            place: event.place,
            capacity: Value(event.capacity),
            status: event.status.name,
            moderationNote: Value(event.moderationNote),
            cancelledAt: Value(event.cancelledAt),
          ),
          mode: InsertMode.insertOrReplace,
        );
    await saveFields(event.id, event.fields);
    await (_db.delete(
      _db.eventMedia,
    )..where((t) => t.eventId.equals(event.id))).go();
    for (final media in event.media) {
      await _db
          .into(_db.eventMedia)
          .insert(
            EventMediaCompanion.insert(
              id: media.id,
              eventId: event.id,
              kind: media.kind.name,
              path: media.path,
              previewPath: Value(media.previewPath),
              position: Value(media.position),
              durationMs: Value(media.durationMs),
              bytes: Value(media.bytes),
            ),
            mode: InsertMode.insertOrReplace,
          );
    }
    final saved = await eventById(event.id);
    return saved ?? event;
  }

  @override
  Future<CampusEvent> publish(String eventId) async {
    await (_db.update(_db.events)..where((t) => t.id.equals(eventId))).write(
      EventsCompanion(
        status: Value(EventStatus.pendingReview.name),
        moderationNote: const Value(''),
      ),
    );
    final updated = await eventById(eventId);
    if (updated == null) {
      throw const AppException('event', 'Событие не найдено');
    }
    return updated;
  }

  @override
  Future<CampusEvent> cancel(String eventId) async {
    await (_db.update(_db.events)..where((t) => t.id.equals(eventId))).write(
      EventsCompanion(
        status: Value(EventStatus.cancelled.name),
        cancelledAt: Value(DateTime.now()),
      ),
    );
    final updated = await eventById(eventId);
    if (updated == null) {
      throw const AppException('event', 'Событие не найдено');
    }
    return updated;
  }

  @override
  Future<void> deleteEvent(String eventId) async {
    await (_db.delete(
      _db.eventMedia,
    )..where((t) => t.eventId.equals(eventId))).go();
    await (_db.delete(
      _db.eventCustomFields,
    )..where((t) => t.eventId.equals(eventId))).go();
    await (_db.delete(_db.events)..where((t) => t.id.equals(eventId))).go();
  }

  @override
  Future<List<OrgMember>> pendingMembers(String orgId) async {
    final rows =
        await (_db.select(_db.organizationMembers)..where(
              (t) =>
                  t.orgId.equals(orgId) &
                  t.status.equals(MemberStatus.pending.name),
            ))
            .get();
    return [for (final row in rows) row.toOrgMember()];
  }

  @override
  Future<void> resolveMembership(
    String orgId,
    String userId,
    bool approve,
  ) async {
    await (_db.update(
      _db.organizationMembers,
    )..where((t) => t.orgId.equals(orgId) & t.userId.equals(userId))).write(
      OrganizationMembersCompanion(
        status: Value(
          approve ? MemberStatus.approved.name : MemberStatus.declined.name,
        ),
      ),
    );
  }

  @override
  Future<void> attachMedia(EventMedia media) async {
    final existing = await (_db.select(
      _db.eventMedia,
    )..where((t) => t.eventId.equals(media.eventId))).get();
    if (media.kind == MediaKind.video) {
      if (existing.any((m) => m.kind == MediaKind.video.name)) {
        throw const AppException('media', 'Видео может быть только одно');
      }
      if (media.bytes > 50 * 1024 * 1024) {
        throw const AppException('media', 'Видео больше 50 МБ');
      }
      if (media.durationMs > 30000) {
        throw const AppException('media', 'Видео длиннее 30 секунд');
      }
    } else {
      final photos = existing
          .where((m) => m.kind == MediaKind.photo.name)
          .length;
      if (photos >= 20) {
        throw const AppException('media', 'Не больше 20 фотографий');
      }
    }
    await _db
        .into(_db.eventMedia)
        .insert(
          EventMediaCompanion.insert(
            id: media.id,
            eventId: media.eventId,
            kind: media.kind.name,
            path: media.path,
            previewPath: Value(media.previewPath),
            position: Value(media.position),
            durationMs: Value(media.durationMs),
            bytes: Value(media.bytes),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  @override
  Future<void> removeMedia(String mediaId) =>
      (_db.delete(_db.eventMedia)..where((t) => t.id.equals(mediaId))).go();

  @override
  Future<void> reorderMedia(String eventId, List<String> orderedIds) async {
    for (var i = 0; i < orderedIds.length; i++) {
      await (_db.update(_db.eventMedia)
            ..where((t) => t.id.equals(orderedIds[i])))
          .write(EventMediaCompanion(position: Value(i)));
    }
  }

  @override
  Future<void> saveFields(String eventId, List<CustomField> fields) async {
    if (fields.length > 10) {
      throw const AppException('fields', 'Не больше 10 своих полей');
    }
    await (_db.delete(
      _db.eventCustomFields,
    )..where((t) => t.eventId.equals(eventId))).go();
    for (var i = 0; i < fields.length; i++) {
      final field = fields[i];
      await _db
          .into(_db.eventCustomFields)
          .insert(
            EventCustomFieldsCompanion.insert(
              id: field.id,
              eventId: field.eventId,
              label: field.label,
              type: field.type.name,
              value: Value(field.value),
              options: Value(encodeOptions(field.options)),
              position: Value(i),
            ),
          );
    }
  }

  @override
  Future<List<EventStats>> statsFor(
    String orgId, {
    DateTime? from,
    DateTime? to,
  }) async {
    final events = await eventsOf(orgId);
    final result = <EventStats>[];
    for (final event in events) {
      if (from != null && event.startAt.isBefore(from)) continue;
      if (to != null && event.startAt.isAfter(to)) continue;
      result.add(await statsOf(event.id));
    }
    return result;
  }

  @override
  Future<List<DayCount>> dailyStats(String eventId) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final registrations = await (_db.select(
      _db.registrations,
    )..where((t) => t.eventId.equals(eventId))).get();
    final views = await (_db.select(
      _db.eventViews,
    )..where((t) => t.eventId.equals(eventId))).get();
    return [
      for (var i = 13; i >= 0; i--)
        () {
          final day = today.subtract(Duration(days: i));
          final next = day.add(const Duration(days: 1));
          bool sameDay(DateTime value) =>
              !value.isBefore(day) && value.isBefore(next);
          return DayCount(
            date: day,
            registrations: registrations
                .where((r) => sameDay(r.createdAt))
                .length,
            views: views.where((v) => sameDay(v.viewedAt)).length,
          );
        }(),
    ];
  }

  @override
  Future<EventStats> statsOf(String eventId) async {
    final event = await eventById(eventId);
    final views = await (_db.select(
      _db.eventViews,
    )..where((t) => t.eventId.equals(eventId))).get();
    final likes = await (_db.select(
      _db.favorites,
    )..where((t) => t.eventId.equals(eventId))).get();
    final registrations = await (_db.select(
      _db.registrations,
    )..where((t) => t.eventId.equals(eventId))).get();
    return EventStats(
      eventId: eventId,
      views: views.length,
      likes: likes.length,
      registrations: registrations.length,
      checkedIn: registrations.where((r) => r.checkedInAt != null).length,
      capacity: event?.capacity ?? -1,
    );
  }

  @override
  Future<Registration?> checkIn(String ticketCode) async {
    final parts = ticketCode.trim().split(':');
    if (parts.length != 2) {
      throw const AppException('ticket', 'Код билета имеет вид eventId:userId');
    }
    final rows =
        await (_db.select(_db.registrations)..where(
              (t) => t.eventId.equals(parts[0]) & t.userId.equals(parts[1]),
            ))
            .get();
    if (rows.isEmpty) {
      throw const AppException('ticket', 'Билет не найден');
    }
    final row = rows.first;
    if (row.checkedInAt != null) {
      throw const AppException('ticket', 'Этот билет уже отсканирован');
    }
    await (_db.update(_db.registrations)..where((t) => t.id.equals(row.id)))
        .write(RegistrationsCompanion(checkedInAt: Value(DateTime.now())));
    final updated = await (_db.select(
      _db.registrations,
    )..where((t) => t.id.equals(row.id))).getSingleOrNull();
    return updated?.toRegistration();
  }

  @override
  Future<List<Registration>> attendees(String eventId) async {
    final rows = await (_db.select(
      _db.registrations,
    )..where((t) => t.eventId.equals(eventId))).get();
    return [for (final row in rows) row.toRegistration()];
  }

  @override
  Future<InviteKey> mintInviteKey() async {
    final plain = randomInviteKey();
    final id = newId('key');
    await _db
        .into(_db.inviteKeys)
        .insert(
          InviteKeysCompanion.insert(
            id: id,
            keyHash: hashSecret(plain),
            createdAt: Value(DateTime.now()),
          ),
        );
    return InviteKey(id: id, keyHash: hashSecret(plain), plainKey: plain);
  }

  @override
  Future<List<InviteKey>> inviteKeys() async {
    final rows = await (_db.select(
      _db.inviteKeys,
    )..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();
    return [for (final row in rows) row.toInviteKey()];
  }

  @override
  Future<List<CampusEvent>> moderationQueue() async {
    final rows = await (_db.select(
      _db.events,
    )..where((t) => t.status.equals(EventStatus.pendingReview.name))).get();
    return _withDetails(rows);
  }

  @override
  Future<CampusEvent> moderate(
    String eventId,
    bool approve, {
    String note = '',
  }) async {
    await (_db.update(_db.events)..where((t) => t.id.equals(eventId))).write(
      EventsCompanion(
        status: Value(
          approve ? EventStatus.published.name : EventStatus.rejected.name,
        ),
        moderationNote: Value(note),
      ),
    );
    final updated = await eventById(eventId);
    if (updated == null) {
      throw const AppException('event', 'Событие не найдено');
    }
    return updated;
  }

  @override
  Future<List<User>> users() async {
    final rows = await _db.select(_db.users).get();
    return [for (final row in rows) row.toUser()];
  }

  @override
  Future<List<Organization>> organizations() async {
    final rows = await _db.select(_db.organizations).get();
    return [for (final row in rows) row.toOrganization()];
  }

  @override
  Future<List<CampusEvent>> allEvents() async {
    final rows = await (_db.select(
      _db.events,
    )..orderBy([(t) => OrderingTerm.desc(t.startAt)])).get();
    return _withDetails(rows);
  }

  @override
  Future<void> blockUser(String userId, bool blocked) =>
      (_db.update(_db.users)..where((t) => t.id.equals(userId))).write(
        UsersCompanion(banned: Value(blocked)),
      );

  @override
  Future<void> blockOrganization(String orgId, bool blocked) =>
      (_db.update(_db.organizations)..where((t) => t.id.equals(orgId))).write(
        OrganizationsCompanion(blocked: Value(blocked)),
      );

  @override
  Future<List<Report>> openReports() async {
    final rows =
        await (_db.select(_db.reports)
              ..where((t) => t.status.equals(ReportStatus.open.name))
              ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
            .get();
    return [for (final row in rows) row.toReport()];
  }

  @override
  Future<void> resolveReport(String reportId, ReportStatus action) async {
    final row = await (_db.select(
      _db.reports,
    )..where((t) => t.id.equals(reportId))).getSingleOrNull();
    if (row == null) {
      throw const AppException('report', 'Жалоба не найдена');
    }
    await (_db.update(_db.reports)..where((t) => t.id.equals(reportId))).write(
      ReportsCompanion(status: Value(action.name)),
    );
    switch (action) {
      case ReportStatus.eventHidden:
        if (row.eventId != null) {
          await moderate(row.eventId!, false, note: 'Скрыто по жалобе');
        }
      case ReportStatus.organizerBlocked:
        final orgId = row.organizerId;
        if (orgId != null) {
          await blockOrganization(orgId, true);
        }
      case ReportStatus.open:
      case ReportStatus.organizerWarned:
      case ReportStatus.dismissed:
        break;
    }
  }

  @override
  Future<AppCounters> counters() async {
    final events = await _db.select(_db.events).get();
    final orgs = await _db.select(_db.organizations).get();
    final users = await _db.select(_db.users).get();
    final keys = await _db.select(_db.inviteKeys).get();
    final reports = await openReports();
    return AppCounters(
      events: events.length,
      orgs: orgs.length,
      users: users.length,
      pendingModeration: events
          .where((e) => e.status == EventStatus.pendingReview.name)
          .length,
      openReports: reports.length,
      activeInviteKeys: keys.where((k) => !k.used).length,
    );
  }
}
