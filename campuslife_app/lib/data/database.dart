import 'package:drift/drift.dart';

part 'database.g.dart';

@DataClassName('UserRow')
class Users extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get email => text().unique()();
  TextColumn get role => text()();
  TextColumn get phone => text().withDefault(const Constant(''))();
  TextColumn get passwordHash => text().withDefault(const Constant(''))();
  BoolColumn get banned => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('OrganizationRow')
class Organizations extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get type => text()();
  TextColumn get city => text()();
  TextColumn get ownerId => text()();
  TextColumn get phone => text().withDefault(const Constant(''))();
  TextColumn get email => text().withDefault(const Constant(''))();
  TextColumn get logoPath => text().nullable()();
  BoolColumn get blocked => boolean().withDefault(const Constant(false))();
  TextColumn get createdAtByKey => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('OrgMemberRow')
class OrganizationMembers extends Table {
  TextColumn get orgId => text()();
  TextColumn get userId => text()();
  TextColumn get role => text()();
  TextColumn get status => text()();
  DateTimeColumn get requestedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {orgId, userId};
}

@DataClassName('InviteKeyRow')
class InviteKeys extends Table {
  TextColumn get id => text()();
  TextColumn get keyHash => text().unique()();
  BoolColumn get used => boolean().withDefault(const Constant(false))();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  TextColumn get orgId => text().nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('EventRow')
class Events extends Table {
  TextColumn get id => text()();
  TextColumn get orgId => text()();
  TextColumn get title => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get category => text()();
  DateTimeColumn get startAt => dateTime()();
  TextColumn get place => text()();
  IntColumn get capacity => integer().withDefault(const Constant(-1))();
  TextColumn get status => text()();
  TextColumn get moderationNote => text().withDefault(const Constant(''))();
  DateTimeColumn get cancelledAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('EventMediaRow')
class EventMedia extends Table {
  TextColumn get id => text()();
  TextColumn get eventId => text()();
  TextColumn get kind => text()();
  TextColumn get path => text()();
  TextColumn get previewPath => text().nullable()();
  IntColumn get position => integer().withDefault(const Constant(0))();
  IntColumn get durationMs => integer().withDefault(const Constant(0))();
  IntColumn get bytes => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('CustomFieldRow')
class EventCustomFields extends Table {
  TextColumn get id => text()();
  TextColumn get eventId => text()();
  TextColumn get label => text()();
  TextColumn get type => text()();
  TextColumn get value => text().withDefault(const Constant(''))();
  TextColumn get options => text().withDefault(const Constant('[]'))();
  IntColumn get position => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('RegistrationRow')
class Registrations extends Table {
  TextColumn get id => text()();
  TextColumn get eventId => text()();
  TextColumn get userId => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get checkedInAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('FavoriteRow')
class Favorites extends Table {
  TextColumn get userId => text()();
  TextColumn get eventId => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {userId, eventId};
}

@DataClassName('ReminderRow')
class Reminders extends Table {
  TextColumn get userId => text()();
  TextColumn get eventId => text()();
  DateTimeColumn get fireAt => dateTime()();
  TextColumn get offset => text()();

  @override
  Set<Column> get primaryKey => {userId, eventId};
}

@DataClassName('ReportRow')
class Reports extends Table {
  TextColumn get id => text()();
  TextColumn get target => text()();
  TextColumn get reporterId => text()();
  TextColumn get reason => text()();
  TextColumn get status => text()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get eventId => text().nullable()();
  TextColumn get organizerId => text().nullable()();
  TextColumn get comment => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('EventViewRow')
class EventViews extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get eventId => text()();
  TextColumn get userId => text()();
  DateTimeColumn get viewedAt => dateTime()();
}

@DriftDatabase(
  tables: [
    Users,
    Organizations,
    OrganizationMembers,
    InviteKeys,
    Events,
    EventMedia,
    EventCustomFields,
    Registrations,
    Favorites,
    Reminders,
    Reports,
    EventViews,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 1;
}
