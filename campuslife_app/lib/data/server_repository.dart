import 'dart:convert';

import 'package:http/http.dart' as http;

import '../domain/entities.dart';
import '../domain/repositories.dart';
import 'mappers.dart';
import 'repository_impl.dart';

class ServerRepository extends LocalRepository {
  ServerRepository(
    super.database,
    super.preferences,
    Uri baseUri,
  ) : baseUri = baseUri.path.endsWith('/')
          ? baseUri
          : baseUri.replace(path: '${baseUri.path}/');

  final Uri baseUri;
  static const _tokenKey = 'campuslife.server.token';
  String? _token;

  @override
  Future<void> warmUp() async {
    _token = prefs.getString(_tokenKey);
  }

  Future<dynamic> _request(
    String method,
    String path, {
    Object? body,
    bool authenticated = true,
  }) async {
    final uri = baseUri.resolve(path);
    final headers = <String, String>{'Accept': 'application/json'};
    if (body != null) headers['Content-Type'] = 'application/json';
    if (authenticated && _token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    final request = http.Request(method, uri)..headers.addAll(headers);
    if (body != null) request.body = jsonEncode(body);
    try {
      final streamed = await request.send().timeout(const Duration(seconds: 20));
      final response = await http.Response.fromStream(streamed);
      final decoded = response.body.isEmpty ? null : jsonDecode(response.body);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        final error = decoded is Map ? decoded['error'] : null;
        throw AppException(
          error is Map ? '${error['code'] ?? 'server'}' : 'server',
          error is Map ? '${error['message'] ?? 'Запрос не выполнен'}' : 'Запрос не выполнен',
        );
      }
      return decoded;
    } on AppException {
      rethrow;
    } catch (error) {
      throw AppException('network', 'Нет связи с сервером: $error');
    }
  }

  Map<String, dynamic> _map(dynamic value) =>
      Map<String, dynamic>.from(value as Map);

  User _user(dynamic value) {
    final json = _map(value);
    return User(
      id: '${json['id']}',
      name: '${json['name']}',
      email: '${json['email']}',
      phone: '${json['phone'] ?? ''}',
      role: enumByName(UserRole.values, '${json['role']}', UserRole.participant),
    );
  }

  @override
  Future<User> signIn(String account, String password) async {
    final response = _map(await _request(
      'POST',
      'auth/sign-in',
      authenticated: false,
      body: {'email': account.trim(), 'password': password},
    ));
    _token = '${response['token']}';
    await prefs.setString(_tokenKey, _token!);
    return _user(response['user']);
  }

  @override
  Future<User> signInAs(UserRole role) async {
    final email = switch (role) {
      UserRole.participant => 'student@campus.ru',
      UserRole.organizer => 'organizer@campus.ru',
      UserRole.admin => 'admin@campus.ru',
    };
    return signIn(email, 'password123');
  }

  @override
  Future<User> registerParticipant({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final response = _map(await _request(
      'POST',
      'auth/register',
      authenticated: false,
      body: {'name': name, 'email': email, 'phone': phone, 'password': password},
    ));
    _token = '${response['token']}';
    await prefs.setString(_tokenKey, _token!);
    return _user(response['user']);
  }

  @override
  Future<User> registerOrganizer(OrganizerSignup signup) async {
    final response = _map(await _request(
      'POST',
      'auth/register',
      authenticated: false,
      body: {
        'name': signup.orgName,
        'email': signup.email,
        'phone': signup.phone,
        'password': signup.password,
      },
    ));
    _token = '${response['token']}';
    await prefs.setString(_tokenKey, _token!);
    await _request('POST', 'organizations', body: {
      'name': signup.orgName,
      'type': signup.orgType.name,
      'city': signup.city,
      'phone': signup.phone,
      'email': signup.email,
      'invite_key': signup.inviteKey,
    });
    return _user(response['user']);
  }

  @override
  Future<void> requestMembership(String orgId, String userId, {String note = ''}) async {
    await _request('POST', 'organizations/$orgId/membership', body: {'note': note});
  }

  @override
  Future<List<Organization>> organizations() async {
    final response = await _request('GET', 'organizations');
    return (response as List).map((item) {
      final json = _map(item);
      return Organization(
        id: '${json['id']}',
        name: '${json['name']}',
        type: enumByName(OrgType.values, '${json['type']}', OrgType.club),
        city: '${json['city']}',
        ownerId: '${json['owner_id']}',
        phone: '${json['phone'] ?? ''}',
        email: '${json['email'] ?? ''}',
      );
    }).toList(growable: false);
  }

  @override
  Future<List<CampusEvent>> eventsOf(String orgId) async {
    final response = await _request('GET', 'organizations/$orgId/events');
    return (response as List).map(_event).toList(growable: false);
  }

  @override
  Future<List<OrgMember>> pendingMembers(String orgId) async {
    final response = await _request(
      'GET',
      'organizations/$orgId/members/pending',
    );
    return (response as List).map((item) {
      final json = _map(item);
      return OrgMember(
        orgId: '${json['org_id']}',
        userId: '${json['user_id']}',
        role: enumByName(MemberRole.values, '${json['role']}', MemberRole.member),
        status: enumByName(MemberStatus.values, '${json['status']}', MemberStatus.pending),
        requestedAt: DateTime.parse('${json['requested_at']}'),
        name: json['name'] as String?,
        email: json['email'] as String?,
        phone: json['phone'] as String?,
        note: (json['note'] as String?) ?? '',
      );
    }).toList(growable: false);
  }

  @override
  Future<void> resolveMembership(
    String orgId,
    String userId,
    bool approve,
  ) async {
    await _request(
      'POST',
      'organizations/$orgId/members/$userId/${approve ? 'approve' : 'reject'}',
      body: const {'role': 'manager'},
    );
  }


  @override
  Future<User?> restoreSession() async {
    if (_token == null) return null;
    try {
      return _user(await _request('GET', 'auth/me'));
    } on AppException catch (error) {
      if (error.code == 'unauthorized') {
        _token = null;
        await prefs.remove(_tokenKey);
        return null;
      }
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    if (_token != null) {
      try {
        await _request('POST', 'auth/sign-out', body: const {});
      } finally {
        _token = null;
        await prefs.remove(_tokenKey);
      }
    }
  }

  @override
  Future<List<CampusEvent>> feed() async {
    final response = await _request('GET', 'events', authenticated: false);
    return (response as List).map(_event).toList(growable: false);
  }

  @override
  Future<CampusEvent?> eventById(String id) async {
    try {
      return _event(await _request('GET', 'events/$id', authenticated: false));
    } on AppException catch (error) {
      if (error.code == 'not_found') return null;
      rethrow;
    }
  }

  CampusEvent _event(dynamic value) {
    final json = _map(value);
    final fields = (json['fields'] as List? ?? const []).map((item) {
      final field = _map(item);
      return CustomField(
        id: '${field['id']}',
        eventId: '${field['event_id']}',
        label: '${field['label']}',
        type: enumByName(FieldType.values, '${field['type']}', FieldType.text),
        required: field['required'] == true || field['required'] == 1,
        options: (field['options'] as List? ?? const []).map((e) => '$e').toList(),
        position: (field['position'] as num?)?.toInt() ?? 0,
      );
    }).toList();
    final media = (json['media'] as List? ?? const []).map((item) {
      final file = _map(item);
      final relativeUrl = '${file['url']}';
      return EventMedia(
        id: '${file['id']}',
        eventId: '${file['event_id'] ?? json['id']}',
        kind: enumByName(MediaKind.values, '${file['kind']}', MediaKind.photo),
        path: baseUri.resolve(relativeUrl).toString(),
        bytes: (file['size'] as num?)?.toInt() ?? 0,
        position: (file['position'] as num?)?.toInt() ?? 0,
      );
    }).toList();
    return CampusEvent(
      id: '${json['id']}',
      orgId: '${json['org_id']}',
      title: '${json['title']}',
      description: '${json['description'] ?? ''}',
      category: enumByName(EventCategory.values, '${json['category']}', EventCategory.contest),
      startAt: DateTime.parse('${json['start_at']}'),
      place: '${json['place']}',
      capacity: (json['capacity'] as num?)?.toInt() ?? -1,
      status: enumByName(EventStatus.values, '${json['status']}', EventStatus.draft),
      autoApprove: json['auto_approve'] == true || json['auto_approve'] == 1,
      fields: fields,
      media: media,
    );
  }

  @override
  Future<void> submitApplication(
    String eventId,
    String userId,
    Map<String, String> answers,
  ) async {
    await _request('POST', 'events/$eventId/applications', body: {'answers': answers});
  }

  @override
  Future<List<EventApplication>> applicationsOf(String eventId) async {
    final response = await _request('GET', 'events/$eventId/applications');
    return (response as List).map((item) {
      final json = _map(item);
      return EventApplication(
        id: '${json['id']}',
        eventId: '${json['event_id']}',
        userId: '${json['user_id']}',
        applicantName: '${json['applicant_name']}',
        applicantEmail: '${json['applicant_email']}',
        applicantPhone: '${json['applicant_phone'] ?? ''}',
        answers: Map<String, String>.from(
          (json['answers'] as Map).map((key, value) => MapEntry('$key', '$value')),
        ),
        status: '${json['status']}',
        createdAt: DateTime.parse('${json['created_at']}'),
      );
    }).toList(growable: false);
  }

  @override
  Future<void> resolveApplication(String applicationId, bool approve) async {
    await _request(
      'PUT',
      'applications/$applicationId/status',
      body: {'status': approve ? 'approved' : 'rejected'},
    );
  }

  @override
  Future<CampusEvent> saveDraft(CampusEvent event) async {
    final body = {
      'id': event.id,
      'title': event.title,
      'description': event.description,
      'category': event.category.name,
      'start_at': event.startAt.toIso8601String(),
      'place': event.place,
      'capacity': event.capacity,
      'status': event.status.name,
      'auto_approve': event.autoApprove,
      'fields': [
        for (var i = 0; i < event.fields.length; i++)
          {
            'id': event.fields[i].id,
            'label': event.fields[i].label,
            'type': event.fields[i].type.name,
            'required': event.fields[i].required,
            'options': event.fields[i].options,
            'position': i,
          }
      ],
      'media': [
        for (var i = 0; i < event.media.length; i++)
          {
            'id': event.media[i].id,
            'position': i,
          }
      ],
    };
    final response = await _request(
      'POST',
      'organizations/${event.orgId}/events',
      body: body,
    );
    return _event(response);
  }

  @override
  Future<CampusEvent> publish(String eventId) async {
    // В серверном режиме «отправить на проверку» означает передачу события
    // в очередь модерации; публикует его администратор через moderate().
    final response = await _request(
      'PUT',
      'events/$eventId/status',
      body: {'status': 'pendingReview'},
    );
    return _event(response);
  }

  @override
  Future<CampusEvent> cancel(String eventId) async {
    final response = await _request(
      'PUT',
      'events/$eventId/status',
      body: {'status': 'cancelled'},
    );
    return _event(response);
  }

  @override
  Future<void> deleteEvent(String eventId) async {
    await _request('DELETE', 'events/$eventId');
  }

  @override
  Future<EventMedia> uploadMedia(
    String eventId,
    List<int> bytes, {
    required String name,
    required MediaKind kind,
  }) async {
    final uri = baseUri.resolve('events/$eventId/media?name=${Uri.encodeComponent(name)}&kind=${kind.name}');
    final request = http.Request('POST', uri)
      ..headers['Authorization'] = 'Bearer $_token'
      ..headers['Content-Type'] = 'application/octet-stream'
      ..headers['X-Filename'] = name
      ..bodyBytes = bytes;
    final streamed = await request.send().timeout(const Duration(seconds: 30));
    final response = await http.Response.fromStream(streamed);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw AppException('upload_failed', 'Не удалось загрузить медиа: ${response.statusCode}');
    }
    final json = _map(jsonDecode(response.body));
    final relativeUrl = '${json['url']}';
    return EventMedia(
      id: '${json['id']}',
      eventId: eventId,
      kind: kind,
      path: baseUri.resolve(relativeUrl).toString(),
      bytes: bytes.length,
      position: (json['position'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  Future<String> shareUrl(String eventId) async {
    final base = Uri.base;
    if (base.host.isNotEmpty && base.scheme.startsWith('http')) {
      final portPart =
          base.hasPort && base.port != 80 && base.port != 443 ? ':${base.port}' : '';
      return '${base.scheme}://${base.host}$portPart/#/events/$eventId';
    }
    final serverHost = baseUri.host.isNotEmpty ? baseUri.host : 'campuslife.app';
    final serverScheme = baseUri.scheme.isNotEmpty ? baseUri.scheme : 'https';
    final portPart =
        baseUri.hasPort && baseUri.port != 80 && baseUri.port != 443
            ? ':${baseUri.port}'
            : '';
    return '$serverScheme://$serverHost$portPart/#/events/$eventId';
  }

  // ---- Синхронизация с сервером: избранное, напоминания, билеты, QR ----

  @override
  Future<bool> toggleFavorite(String eventId, String userId) async {
    final response = _map(await _request('POST', 'events/$eventId/favorite'));
    return response['favorited'] == true;
  }

  @override
  Future<List<CampusEvent>> favorites(String userId) async {
    final response = await _request('GET', 'my/favorites');
    return (response as List).map(_event).toList(growable: false);
  }

  @override
  Future<List<String>> favoriteEventIds(String userId) async {
    final events = await favorites(userId);
    return [for (final event in events) event.id];
  }

  @override
  Future<void> setReminder(
    String eventId,
    String userId,
    ReminderOffset offset, {
    DateTime? customAt,
  }) async {
    await _request(
      'POST',
      'events/$eventId/reminders',
      body: {'offset': offset.name},
    );
  }

  @override
  Future<void> clearReminder(String eventId, String userId) async {
    await _request('DELETE', 'events/$eventId/reminders');
  }

  @override
  Future<Reminder?> reminderOf(String eventId, String userId) async {
    dynamic response;
    try {
      response = await _request('GET', 'events/$eventId/reminders');
    } on AppException catch (error) {
      if (error.code == 'not_found') return null;
      rethrow;
    }
    if (response == null) return null;
    final json = _map(response);
    final offset = enumByName(
      ReminderOffset.values,
      '${json['offset']}',
      ReminderOffset.oneHour,
    );
    final event = _event(json['event']);
    final fireAt = switch (offset) {
      ReminderOffset.oneHour => event.startAt.subtract(const Duration(hours: 1)),
      ReminderOffset.oneDay => event.startAt.subtract(const Duration(days: 1)),
      ReminderOffset.custom => event.startAt,
    };
    return Reminder(
      userId: userId,
      eventId: eventId,
      fireAt: fireAt,
      offset: offset,
    );
  }

  @override
  Future<List<TicketBundle>> myTickets(String userId) async {
    final response = await _request('GET', 'my/tickets');
    final bundles = <TicketBundle>[];
    for (final item in (response as List)) {
      final json = _map(item);
      final eventId = '${json['event_id']}';
      CampusEvent event;
      final rawEvent = json['event'];
      if (rawEvent is Map) {
        event = _event(rawEvent);
      } else {
        final loaded = await eventById(eventId);
        if (loaded == null) continue;
        event = loaded;
      }
      final status = '${json['status'] ?? 'pending'}';
      final updatedAt = DateTime.tryParse('${json['updated_at'] ?? ''}');
      bundles.add(
        TicketBundle(
          event: event,
          registration: Registration(
            id: '${json['id']}',
            eventId: eventId,
            userId: userId,
            createdAt: DateTime.parse('${json['created_at']}'),
            checkedInAt: status == 'checked_in' ? updatedAt : null,
            status: status,
          ),
        ),
      );
    }
    bundles.sort((a, b) => a.event.startAt.compareTo(b.event.startAt));
    return bundles;
  }

  @override
  Future<bool> toggleRegistration(String eventId, String userId) async {
    await _request(
      'POST',
      'events/$eventId/applications',
      body: {'answers': const <String, String>{}},
    );
    return true;
  }

  @override
  Future<Registration?> checkIn(String ticketCode) async {
    final parts = ticketCode.trim().split(':');
    if (parts.length != 2) {
      throw const AppException('ticket', 'Код билета имеет вид eventId:userId');
    }
    final eventId = parts[0];
    final userId = parts[1];
    final response = _map(
      await _request(
        'POST',
        'events/$eventId/check-in',
        body: {'ticket_id': userId},
      ),
    );
    return Registration(
      id: '${response['ticket_id'] ?? ticketCode}',
      eventId: eventId,
      userId: userId,
      createdAt: DateTime.now(),
      status: 'checked_in',
    );
  }

  @override
  Future<List<InviteKey>> inviteKeys() async {
    final response = await _request('GET', 'admin/invite-keys');
    return (response as List).map((item) {
      final json = _map(item);
      final code = '${json['code']}';
      final used = json['used'] == true || json['used'] == 1;
      final createdAt = json['created_at'] != null
          ? DateTime.tryParse('${json['created_at']}')
          : null;
      return InviteKey(
        id: code,
        keyHash: code,
        used: used,
        plainKey: code,
        createdAt: createdAt,
      );
    }).toList(growable: false);
  }

  @override
  Future<InviteKey> mintInviteKey() async {
    final response = _map(await _request('POST', 'admin/invite-keys'));
    final code = '${response['code']}';
    return InviteKey(
      id: code,
      keyHash: code,
      used: false,
      plainKey: code,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<List<CampusEvent>> moderationQueue() async {
    final response = await _request('GET', 'admin/moderation');
    return (response as List).map(_event).toList(growable: false);
  }

  @override
  Future<CampusEvent> moderate(
    String eventId,
    bool approve, {
    String note = '',
  }) async {
    final body = <String, dynamic>{
      'status': approve ? 'published' : 'rejected',
    };
    if (note.trim().isNotEmpty) {
      body['note'] = note.trim();
    }
    final response = _map(
      await _request(
        'PUT',
        'events/$eventId/status',
        body: body,
      ),
    );
    return _event(response);
  }

  @override
  Future<AppCounters> counters() async {
    final response = _map(await _request('GET', 'admin/counters'));
    return AppCounters(
      events: (response['events'] as num?)?.toInt() ?? 0,
      orgs: (response['orgs'] as num?)?.toInt() ?? 0,
      users: (response['users'] as num?)?.toInt() ?? 0,
      pendingModeration:
          (response['pending_moderation'] as num?)?.toInt() ?? 0,
      openReports: (response['open_reports'] as num?)?.toInt() ?? 0,
      activeInviteKeys: (response['active_invite_keys'] as num?)?.toInt() ?? 0,
    );
  }
}
