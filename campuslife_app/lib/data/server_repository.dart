import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/entities.dart';
import '../domain/repositories.dart';
import 'database.dart' hide EventMedia;
import 'mappers.dart';
import 'repository_impl.dart';

class ServerRepository extends LocalRepository {
  ServerRepository(
    AppDatabase database,
    SharedPreferences preferences,
    Uri baseUri,
  ) : _preferences = preferences,
       baseUri = baseUri.path.endsWith('/')
           ? baseUri
           : baseUri.replace(path: '${baseUri.path}/'),
       super(database, preferences);

  final Uri baseUri;
  final SharedPreferences _preferences;
  static const _tokenKey = 'campuslife.server.token';
  String? _token;

  @override
  Future<void> warmUp() async {
    _token = _preferences.getString(_tokenKey);
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
    await _preferences.setString(_tokenKey, _token!);
    return _user(response['user']);
  }

  @override
  Future<User> signInAs(UserRole role) => Future.error(
    const AppException('unsupported', 'Демо-вход на сервере недоступен'),
  );

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
    await _preferences.setString(_tokenKey, _token!);
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
    await _preferences.setString(_tokenKey, _token!);
    await _request('POST', 'organizations', body: {
      'name': signup.orgName,
      'type': signup.orgType.name,
      'city': signup.city,
      'phone': signup.phone,
      'email': signup.email,
    });
    return _user(response['user']);
  }

  @override
  Future<void> requestMembership(String orgId, String userId) async {
    await _request('POST', 'organizations/$orgId/membership', body: const {});
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
        await _preferences.remove(_tokenKey);
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
        await _preferences.remove(_tokenKey);
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
}
