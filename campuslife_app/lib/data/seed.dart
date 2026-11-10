import 'dart:math';

import 'package:drift/drift.dart';

import '../domain/entities.dart';
import 'crypto.dart';
import 'database.dart' hide EventMedia;

typedef _SeedEvent = ({
  String id,
  String orgId,
  String title,
  EventCategory category,
  int day,
  int hour,
  String place,
  String description,
  int capacity,
  EventStatus status,
});

const _events = <_SeedEvent>[
  (
    id: 'ev_1',
    orgId: 'org_1',
    title: 'Осенний турнир по баскетболу',
    category: EventCategory.sport,
    day: 2,
    hour: 16,
    place: 'Спортзал, 2 этаж',
    description:
        'Класс на класс, три периода по десять минут. Записывайся капитаном команды или приходи болеть.',
    capacity: 60,
    status: EventStatus.published,
  ),
  (
    id: 'ev_2',
    orgId: 'org_1',
    title: 'День открытых дверей робототехники',
    category: EventCategory.science,
    day: 3,
    hour: 15,
    place: 'Кабинет 214, лаборатория',
    description:
        'Собираем линейного робота за сорок минут, разбираем типичные ошибки на региональном этапе.',
    capacity: 24,
    status: EventStatus.published,
  ),
  (
    id: 'ev_3',
    orgId: 'org_2',
    title: 'Фотопрогулка по старому городу',
    category: EventCategory.art,
    day: 4,
    hour: 12,
    place: 'Сбор у главного входа',
    description:
        'Идём по трём точкам с плёнкой и телефонами. Разбираем кадр на месте, потом общий разбор.',
    capacity: 18,
    status: EventStatus.published,
  ),
  (
    id: 'ev_4',
    orgId: 'org_1',
    title: 'Лекция: как не бояться олимпиад',
    category: EventCategory.lecture,
    day: 5,
    hour: 14,
    place: 'Актовый зал',
    description:
        'Призёр всероссийской олимпиады рассказывает, как готовиться без репетиторов и выгорания.',
    capacity: 120,
    status: EventStatus.published,
  ),
  (
    id: 'ev_5',
    orgId: 'org_2',
    title: 'Квартирник: школьные группы',
    category: EventCategory.music,
    day: 6,
    hour: 18,
    place: 'Малый зал, 1 этаж',
    description:
        'Четыре группы по двадцать минут. Можно прийти слушателем, можно встать в программу.',
    capacity: 80,
    status: EventStatus.published,
  ),
  (
    id: 'ev_6',
    orgId: 'org_1',
    title: 'Субботник в школьном саду',
    category: EventCategory.volunteer,
    day: 7,
    hour: 10,
    place: 'Школьный двор',
    description:
        'Сажаем кустарники, красим лавочки. Перчатки и инвентарь выдаём, чай с собой.',
    capacity: -1,
    status: EventStatus.published,
  ),
  (
    id: 'ev_7',
    orgId: 'org_1',
    title: 'Чемпионат по настольным играм',
    category: EventCategory.contest,
    day: 8,
    hour: 15,
    place: 'Библиотека',
    description:
        'Шахматы, «Эволюция» и «Dixit». Сетка на выбывание, финал в следующую пятницу.',
    capacity: 32,
    status: EventStatus.published,
  ),
  (
    id: 'ev_8',
    orgId: 'org_2',
    title: 'Выезд в планетарий',
    category: EventCategory.outing,
    day: 9,
    hour: 11,
    place: 'Автобус от школы',
    description:
        'Программа «Звёздное небо» и обсерватория. Автобус в 11:00, обратно к 15:00.',
    capacity: 40,
    status: EventStatus.published,
  ),
  (
    id: 'ev_9',
    orgId: 'org_1',
    title: 'Тренировка волейбольной секции',
    category: EventCategory.sport,
    day: 10,
    hour: 17,
    place: 'Спортзал, 2 этаж',
    description: 'Открытая тренировка для новичков, форма обязательна.',
    capacity: 20,
    status: EventStatus.published,
  ),
  (
    id: 'ev_10',
    orgId: 'org_2',
    title: 'Мастер-класс по скетчингу',
    category: EventCategory.art,
    day: 11,
    hour: 16,
    place: 'Кабинет 108',
    description:
        'Быстрые зарисовки за 5 минут: жест, объём, свет. Бумага и маркеры на месте.',
    capacity: 16,
    status: EventStatus.published,
  ),
  (
    id: 'ev_11',
    orgId: 'org_1',
    title: 'Научное кафе: химия еды',
    category: EventCategory.science,
    day: 12,
    hour: 15,
    place: 'Кабинет химии',
    description: 'Опыты с индикаторами и разбор, почему молоко сворачивается.',
    capacity: 22,
    status: EventStatus.published,
  ),
  (
    id: 'ev_12',
    orgId: 'org_1',
    title: 'Дебаты: технологии в школе',
    category: EventCategory.contest,
    day: 13,
    hour: 14,
    place: 'Актовый зал',
    description:
        'Две команды, формат «публичный форум», судьи из старшеклассников.',
    capacity: 48,
    status: EventStatus.published,
  ),
  (
    id: 'ev_13',
    orgId: 'org_2',
    title: 'Открытый микрофон',
    category: EventCategory.music,
    day: 14,
    hour: 17,
    place: 'Малый зал',
    description:
        'Поэзия, стендап и акустика. Слот на пять минут бронируется заранее.',
    capacity: 60,
    status: EventStatus.published,
  ),
  (
    id: 'ev_14',
    orgId: 'org_1',
    title: 'Профориентационная лекция',
    category: EventCategory.lecture,
    day: 15,
    hour: 13,
    place: 'Кабинет 301',
    description: 'Инженер, врач и дизайнер отвечают на вопросы о поступлении.',
    capacity: 70,
    status: EventStatus.published,
  ),
  (
    id: 'ev_15',
    orgId: 'org_1',
    title: 'Сбор макулатуры',
    category: EventCategory.volunteer,
    day: 16,
    hour: 12,
    place: 'Школьный двор',
    description:
        'Приносим макулатуру, считаем килограммы по классам, вручаем грамоты.',
    capacity: -1,
    status: EventStatus.published,
  ),
  (
    id: 'ev_16',
    orgId: 'org_2',
    title: 'Поход в картинную галерею',
    category: EventCategory.outing,
    day: 17,
    hour: 11,
    place: 'Сбор у вахты',
    description: 'Экскурсия по русскому авангарду и самостоятельная зарисовка.',
    capacity: 25,
    status: EventStatus.published,
  ),
  (
    id: 'ev_17',
    orgId: 'org_1',
    title: 'Кубок по мини-футболу',
    category: EventCategory.sport,
    day: 18,
    hour: 16,
    place: 'Спортзал',
    description: 'Групповой этап и плей-офф в один день.',
    capacity: 64,
    status: EventStatus.published,
  ),
  (
    id: 'ev_18',
    orgId: 'org_2',
    title: 'Вечер короткого метра',
    category: EventCategory.art,
    day: 19,
    hour: 18,
    place: 'Актовый зал',
    description: 'Показ работ фотостудии и обсуждение с авторами.',
    capacity: 90,
    status: EventStatus.published,
  ),
  (
    id: 'ev_19',
    orgId: 'org_1',
    title: 'Весенний бал старшеклассников',
    category: EventCategory.art,
    day: 21,
    hour: 17,
    place: 'Актовый зал',
    description: 'Ждём подтверждение программы от студсовета.',
    capacity: 150,
    status: EventStatus.pendingReview,
  ),
  (
    id: 'ev_20',
    orgId: 'org_2',
    title: 'Фотоконкурс «Мой район»',
    category: EventCategory.contest,
    day: 22,
    hour: 12,
    place: 'Онлайн-голосование',
    description: 'Приём работ до пятницы, потом открытое голосование.',
    capacity: -1,
    status: EventStatus.pendingReview,
  ),
  (
    id: 'ev_21',
    orgId: 'org_1',
    title: 'Черновик: турнир по КВН',
    category: EventCategory.contest,
    day: 24,
    hour: 15,
    place: 'Актовый зал',
    description: 'Пока только идея и список команд.',
    capacity: -1,
    status: EventStatus.draft,
  ),
];

const _students = <(String, String)>[
  ('u_s1', 'Алексей Петров'),
  ('u_s2', 'Мария Соколова'),
  ('u_s3', 'Даниил Орлов'),
  ('u_s4', 'Софья Лебедева'),
  ('u_s5', 'Иван Кузнецов'),
  ('u_s6', 'Анна Морозова'),
  ('u_s7', 'Тимур Алиев'),
  ('u_s8', 'Полина Волкова'),
];

Future<void> seedIfEmpty(AppDatabase db) async {
  final existing = await db.select(db.users).get();
  if (existing.isNotEmpty) return;
  final now = DateTime.now();
  final password = Value(hashSecret('campus123'));

  Future<void> addUser(
    String id,
    String name,
    String email,
    UserRole role, {
    String phone = '',
  }) => db
      .into(db.users)
      .insert(
        UsersCompanion.insert(
          id: id,
          name: name,
          email: email,
          role: role.name,
          phone: Value(phone),
          passwordHash: password,
        ),
      );

  await addUser(
    'u_participant',
    'Алексей Петров',
    'uchastnik@campus.life',
    UserRole.participant,
    phone: '+7 900 123-45-67',
  );
  await addUser(
    'u_org',
    'Студсовет школы №24',
    'org@campus.life',
    UserRole.organizer,
    phone: '+7 900 765-43-21',
  );
  await addUser(
    'u_admin',
    'Администратор',
    'admin@campus.life',
    UserRole.admin,
  );
  await addUser(
    'u_org2',
    'Фотостудия «Объектив»',
    'photo@campus.life',
    UserRole.organizer,
  );
  for (final student in _students) {
    await addUser(
      student.$1,
      student.$2,
      '${student.$1}@campus.life',
      UserRole.participant,
    );
  }

  await db
      .into(db.organizations)
      .insert(
        OrganizationsCompanion.insert(
          id: 'org_1',
          name: 'Студсовет школы №24',
          type: OrgType.studSoviet.name,
          city: 'Москва',
          ownerId: 'u_org',
          phone: const Value('+7 900 765-43-21'),
          email: const Value('org@campus.life'),
          createdAtByKey: const Value('key_seed'),
        ),
      );
  await db
      .into(db.organizations)
      .insert(
        OrganizationsCompanion.insert(
          id: 'org_2',
          name: 'Фотостудия «Объектив»',
          type: OrgType.club.name,
          city: 'Москва',
          ownerId: 'u_org2',
          email: const Value('photo@campus.life'),
        ),
      );
  for (final org in ['org_1', 'org_2']) {
    await db
        .into(db.organizationMembers)
        .insert(
          OrganizationMembersCompanion.insert(
            orgId: org,
            userId: org == 'org_1' ? 'u_org' : 'u_org2',
            role: MemberRole.owner.name,
            status: MemberStatus.approved.name,
            requestedAt: now,
          ),
        );
  }
  await db
      .into(db.organizationMembers)
      .insert(
        OrganizationMembersCompanion.insert(
          orgId: 'org_1',
          userId: 'u_s3',
          role: MemberRole.member.name,
          status: MemberStatus.pending.name,
          requestedAt: now.subtract(const Duration(days: 1)),
        ),
      );

  await db
      .into(db.inviteKeys)
      .insert(
        InviteKeysCompanion.insert(
          id: 'key_seed',
          keyHash: hashSecret('CL-24KT-2026'),
          used: const Value(true),
          orgId: const Value('org_1'),
          createdAt: Value(now.subtract(const Duration(days: 30))),
        ),
      );

  for (final event in _events) {
    await db
        .into(db.events)
        .insert(
          EventsCompanion.insert(
            id: event.id,
            orgId: event.orgId,
            title: event.title,
            description: Value(event.description),
            category: event.category.name,
            startAt: DateTime(
              now.year,
              now.month,
              now.day,
              event.hour,
            ).add(Duration(days: event.day)),
            place: event.place,
            capacity: Value(event.capacity),
            status: event.status.name,
          ),
        );
  }

  await db
      .into(db.eventCustomFields)
      .insert(
        EventCustomFieldsCompanion.insert(
          id: 'fld_1',
          eventId: 'ev_1',
          label: 'Класс и буква',
          type: FieldType.text.name,
          position: const Value(0),
        ),
      );
  await db
      .into(db.eventCustomFields)
      .insert(
        EventCustomFieldsCompanion.insert(
          id: 'fld_2',
          eventId: 'ev_1',
          label: 'Роль в команде',
          type: FieldType.choice.name,
          options: const Value('["капитан","игрок","болельщик"]'),
          position: const Value(1),
        ),
      );

  final random = Random(24);
  final participants = ['u_participant', for (final s in _students) s.$1];
  for (final event in _events.where((e) => e.status == EventStatus.published)) {
    for (final userId in participants) {
      final isMain = userId == 'u_participant';
      final index = int.parse(event.id.substring(3));
      if (!isMain && random.nextDouble() > 0.45) continue;
      if (isMain && index > 4) continue;
      final createdAt = now.subtract(
        Duration(days: random.nextInt(13), hours: random.nextInt(20)),
      );
      await db
          .into(db.registrations)
          .insert(
            RegistrationsCompanion.insert(
              id: 'reg_${event.id}_$userId',
              eventId: event.id,
              userId: userId,
              createdAt: createdAt,
              checkedInAt: index <= 2 && random.nextBool()
                  ? Value(createdAt.add(const Duration(days: 1)))
                  : const Value.absent(),
            ),
          );
      if (random.nextDouble() < 0.5) {
        await db
            .into(db.favorites)
            .insert(
              FavoritesCompanion.insert(
                userId: userId,
                eventId: event.id,
                createdAt: createdAt,
              ),
              mode: InsertMode.insertOrIgnore,
            );
      }
      final views = 2 + random.nextInt(6);
      for (var i = 0; i < views; i++) {
        await db
            .into(db.eventViews)
            .insert(
              EventViewsCompanion.insert(
                eventId: event.id,
                userId: userId,
                viewedAt: now.subtract(
                  Duration(days: random.nextInt(14), hours: random.nextInt(20)),
                ),
              ),
            );
      }
    }
  }

  await db
      .into(db.reminders)
      .insert(
        RemindersCompanion.insert(
          userId: 'u_participant',
          eventId: 'ev_1',
          fireAt: now.add(const Duration(days: 1, hours: 15)),
          offset: ReminderOffset.oneHour.name,
        ),
      );

  await db
      .into(db.reports)
      .insert(
        ReportsCompanion.insert(
          id: 'rep_seed',
          target: ReportTarget.event.name,
          reporterId: 'u_s5',
          reason: 'Не по теме школы',
          status: ReportStatus.open.name,
          createdAt: now.subtract(const Duration(hours: 6)),
          eventId: const Value('ev_18'),
          organizerId: const Value('org_2'),
          comment: const Value('Похоже на рекламу сторонней студии.'),
        ),
      );
}
