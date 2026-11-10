import 'dart:convert';

import '../domain/entities.dart';
import 'database.dart' hide EventMedia;

T enumByName<T extends Enum>(List<T> values, String name, T fallback) {
  for (final value in values) {
    if (value.name == name) {
      return value;
    }
  }
  return fallback;
}

String encodeOptions(List<String> options) => jsonEncode(options);

List<String> decodeOptions(String raw) {
  try {
    final decoded = jsonDecode(raw);
    if (decoded is List) {
      return decoded.map((e) => '$e').toList(growable: false);
    }
  } on FormatException {
    return const [];
  }
  return const [];
}

extension UserRowMapper on UserRow {
  User toUser() => User(
    id: id,
    name: name,
    email: email,
    role: enumByName(UserRole.values, role, UserRole.participant),
    phone: phone,
    passwordHash: passwordHash,
    banned: banned,
  );
}

extension OrganizationRowMapper on OrganizationRow {
  Organization toOrganization() => Organization(
    id: id,
    name: name,
    type: enumByName(OrgType.values, type, OrgType.club),
    city: city,
    ownerId: ownerId,
    phone: phone,
    email: email,
    logoPath: logoPath,
    blocked: blocked,
    createdAtByKey: createdAtByKey,
  );
}

extension OrgMemberRowMapper on OrgMemberRow {
  OrgMember toOrgMember() => OrgMember(
    orgId: orgId,
    userId: userId,
    role: enumByName(MemberRole.values, role, MemberRole.member),
    status: enumByName(MemberStatus.values, status, MemberStatus.pending),
    requestedAt: requestedAt,
  );
}

extension InviteKeyRowMapper on InviteKeyRow {
  InviteKey toInviteKey() => InviteKey(
    id: id,
    keyHash: keyHash,
    used: used,
    attempts: attempts,
    orgId: orgId,
    createdAt: createdAt,
  );
}

extension EventRowMapper on EventRow {
  CampusEvent toEvent() => CampusEvent(
    id: id,
    orgId: orgId,
    title: title,
    description: description,
    category: enumByName(EventCategory.values, category, EventCategory.contest),
    startAt: startAt,
    place: place,
    capacity: capacity,
    status: enumByName(EventStatus.values, status, EventStatus.draft),
    moderationNote: moderationNote,
    cancelledAt: cancelledAt,
  );
}

extension EventMediaRowMapper on EventMediaRow {
  EventMedia toMedia() => EventMedia(
    id: id,
    eventId: eventId,
    kind: enumByName(MediaKind.values, kind, MediaKind.photo),
    path: path,
    previewPath: previewPath,
    position: position,
    durationMs: durationMs,
    bytes: bytes,
  );
}

extension CustomFieldRowMapper on CustomFieldRow {
  CustomField toField() => CustomField(
    id: id,
    eventId: eventId,
    label: label,
    type: enumByName(FieldType.values, type, FieldType.text),
    value: value,
    options: decodeOptions(options),
    position: position,
  );
}

extension RegistrationRowMapper on RegistrationRow {
  Registration toRegistration() => Registration(
    id: id,
    eventId: eventId,
    userId: userId,
    createdAt: createdAt,
    checkedInAt: checkedInAt,
  );
}

extension ReminderRowMapper on ReminderRow {
  Reminder toReminder() => Reminder(
    userId: userId,
    eventId: eventId,
    fireAt: fireAt,
    offset: enumByName(ReminderOffset.values, offset, ReminderOffset.oneDay),
  );
}

extension ReportRowMapper on ReportRow {
  Report toReport() => Report(
    id: id,
    target: enumByName(ReportTarget.values, target, ReportTarget.event),
    reporterId: reporterId,
    reason: reason,
    status: enumByName(ReportStatus.values, status, ReportStatus.open),
    createdAt: createdAt,
    eventId: eventId,
    organizerId: organizerId,
    comment: comment,
  );
}
