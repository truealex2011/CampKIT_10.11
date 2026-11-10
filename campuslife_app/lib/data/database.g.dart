// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, UserRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _passwordHashMeta = const VerificationMeta(
    'passwordHash',
  );
  @override
  late final GeneratedColumn<String> passwordHash = GeneratedColumn<String>(
    'password_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _bannedMeta = const VerificationMeta('banned');
  @override
  late final GeneratedColumn<bool> banned = GeneratedColumn<bool>(
    'banned',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("banned" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    email,
    role,
    phone,
    passwordHash,
    banned,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('password_hash')) {
      context.handle(
        _passwordHashMeta,
        passwordHash.isAcceptableOrUnknown(
          data['password_hash']!,
          _passwordHashMeta,
        ),
      );
    }
    if (data.containsKey('banned')) {
      context.handle(
        _bannedMeta,
        banned.isAcceptableOrUnknown(data['banned']!, _bannedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      passwordHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password_hash'],
      )!,
      banned: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}banned'],
      )!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class UserRow extends DataClass implements Insertable<UserRow> {
  final String id;
  final String name;
  final String email;
  final String role;
  final String phone;
  final String passwordHash;
  final bool banned;
  const UserRow({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.phone,
    required this.passwordHash,
    required this.banned,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['email'] = Variable<String>(email);
    map['role'] = Variable<String>(role);
    map['phone'] = Variable<String>(phone);
    map['password_hash'] = Variable<String>(passwordHash);
    map['banned'] = Variable<bool>(banned);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      name: Value(name),
      email: Value(email),
      role: Value(role),
      phone: Value(phone),
      passwordHash: Value(passwordHash),
      banned: Value(banned),
    );
  }

  factory UserRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String>(json['email']),
      role: serializer.fromJson<String>(json['role']),
      phone: serializer.fromJson<String>(json['phone']),
      passwordHash: serializer.fromJson<String>(json['passwordHash']),
      banned: serializer.fromJson<bool>(json['banned']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'email': serializer.toJson<String>(email),
      'role': serializer.toJson<String>(role),
      'phone': serializer.toJson<String>(phone),
      'passwordHash': serializer.toJson<String>(passwordHash),
      'banned': serializer.toJson<bool>(banned),
    };
  }

  UserRow copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? phone,
    String? passwordHash,
    bool? banned,
  }) => UserRow(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
    role: role ?? this.role,
    phone: phone ?? this.phone,
    passwordHash: passwordHash ?? this.passwordHash,
    banned: banned ?? this.banned,
  );
  UserRow copyWithCompanion(UsersCompanion data) {
    return UserRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      role: data.role.present ? data.role.value : this.role,
      phone: data.phone.present ? data.phone.value : this.phone,
      passwordHash: data.passwordHash.present
          ? data.passwordHash.value
          : this.passwordHash,
      banned: data.banned.present ? data.banned.value : this.banned,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('role: $role, ')
          ..write('phone: $phone, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('banned: $banned')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, email, role, phone, passwordHash, banned);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.email == this.email &&
          other.role == this.role &&
          other.phone == this.phone &&
          other.passwordHash == this.passwordHash &&
          other.banned == this.banned);
}

class UsersCompanion extends UpdateCompanion<UserRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> email;
  final Value<String> role;
  final Value<String> phone;
  final Value<String> passwordHash;
  final Value<bool> banned;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.role = const Value.absent(),
    this.phone = const Value.absent(),
    this.passwordHash = const Value.absent(),
    this.banned = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    required String name,
    required String email,
    required String role,
    this.phone = const Value.absent(),
    this.passwordHash = const Value.absent(),
    this.banned = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       email = Value(email),
       role = Value(role);
  static Insertable<UserRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? email,
    Expression<String>? role,
    Expression<String>? phone,
    Expression<String>? passwordHash,
    Expression<bool>? banned,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (role != null) 'role': role,
      if (phone != null) 'phone': phone,
      if (passwordHash != null) 'password_hash': passwordHash,
      if (banned != null) 'banned': banned,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? email,
    Value<String>? role,
    Value<String>? phone,
    Value<String>? passwordHash,
    Value<bool>? banned,
    Value<int>? rowid,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      passwordHash: passwordHash ?? this.passwordHash,
      banned: banned ?? this.banned,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (passwordHash.present) {
      map['password_hash'] = Variable<String>(passwordHash.value);
    }
    if (banned.present) {
      map['banned'] = Variable<bool>(banned.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('role: $role, ')
          ..write('phone: $phone, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('banned: $banned, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OrganizationsTable extends Organizations
    with TableInfo<$OrganizationsTable, OrganizationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrganizationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
    'city',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
    'owner_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _logoPathMeta = const VerificationMeta(
    'logoPath',
  );
  @override
  late final GeneratedColumn<String> logoPath = GeneratedColumn<String>(
    'logo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _blockedMeta = const VerificationMeta(
    'blocked',
  );
  @override
  late final GeneratedColumn<bool> blocked = GeneratedColumn<bool>(
    'blocked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("blocked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtByKeyMeta = const VerificationMeta(
    'createdAtByKey',
  );
  @override
  late final GeneratedColumn<String> createdAtByKey = GeneratedColumn<String>(
    'created_at_by_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    type,
    city,
    ownerId,
    phone,
    email,
    logoPath,
    blocked,
    createdAtByKey,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'organizations';
  @override
  VerificationContext validateIntegrity(
    Insertable<OrganizationRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('city')) {
      context.handle(
        _cityMeta,
        city.isAcceptableOrUnknown(data['city']!, _cityMeta),
      );
    } else if (isInserting) {
      context.missing(_cityMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('logo_path')) {
      context.handle(
        _logoPathMeta,
        logoPath.isAcceptableOrUnknown(data['logo_path']!, _logoPathMeta),
      );
    }
    if (data.containsKey('blocked')) {
      context.handle(
        _blockedMeta,
        blocked.isAcceptableOrUnknown(data['blocked']!, _blockedMeta),
      );
    }
    if (data.containsKey('created_at_by_key')) {
      context.handle(
        _createdAtByKeyMeta,
        createdAtByKey.isAcceptableOrUnknown(
          data['created_at_by_key']!,
          _createdAtByKeyMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrganizationRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrganizationRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      city: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}city'],
      )!,
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_id'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      logoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}logo_path'],
      ),
      blocked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}blocked'],
      )!,
      createdAtByKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at_by_key'],
      ),
    );
  }

  @override
  $OrganizationsTable createAlias(String alias) {
    return $OrganizationsTable(attachedDatabase, alias);
  }
}

class OrganizationRow extends DataClass implements Insertable<OrganizationRow> {
  final String id;
  final String name;
  final String type;
  final String city;
  final String ownerId;
  final String phone;
  final String email;
  final String? logoPath;
  final bool blocked;
  final String? createdAtByKey;
  const OrganizationRow({
    required this.id,
    required this.name,
    required this.type,
    required this.city,
    required this.ownerId,
    required this.phone,
    required this.email,
    this.logoPath,
    required this.blocked,
    this.createdAtByKey,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['city'] = Variable<String>(city);
    map['owner_id'] = Variable<String>(ownerId);
    map['phone'] = Variable<String>(phone);
    map['email'] = Variable<String>(email);
    if (!nullToAbsent || logoPath != null) {
      map['logo_path'] = Variable<String>(logoPath);
    }
    map['blocked'] = Variable<bool>(blocked);
    if (!nullToAbsent || createdAtByKey != null) {
      map['created_at_by_key'] = Variable<String>(createdAtByKey);
    }
    return map;
  }

  OrganizationsCompanion toCompanion(bool nullToAbsent) {
    return OrganizationsCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      city: Value(city),
      ownerId: Value(ownerId),
      phone: Value(phone),
      email: Value(email),
      logoPath: logoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(logoPath),
      blocked: Value(blocked),
      createdAtByKey: createdAtByKey == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAtByKey),
    );
  }

  factory OrganizationRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrganizationRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      city: serializer.fromJson<String>(json['city']),
      ownerId: serializer.fromJson<String>(json['ownerId']),
      phone: serializer.fromJson<String>(json['phone']),
      email: serializer.fromJson<String>(json['email']),
      logoPath: serializer.fromJson<String?>(json['logoPath']),
      blocked: serializer.fromJson<bool>(json['blocked']),
      createdAtByKey: serializer.fromJson<String?>(json['createdAtByKey']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'city': serializer.toJson<String>(city),
      'ownerId': serializer.toJson<String>(ownerId),
      'phone': serializer.toJson<String>(phone),
      'email': serializer.toJson<String>(email),
      'logoPath': serializer.toJson<String?>(logoPath),
      'blocked': serializer.toJson<bool>(blocked),
      'createdAtByKey': serializer.toJson<String?>(createdAtByKey),
    };
  }

  OrganizationRow copyWith({
    String? id,
    String? name,
    String? type,
    String? city,
    String? ownerId,
    String? phone,
    String? email,
    Value<String?> logoPath = const Value.absent(),
    bool? blocked,
    Value<String?> createdAtByKey = const Value.absent(),
  }) => OrganizationRow(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    city: city ?? this.city,
    ownerId: ownerId ?? this.ownerId,
    phone: phone ?? this.phone,
    email: email ?? this.email,
    logoPath: logoPath.present ? logoPath.value : this.logoPath,
    blocked: blocked ?? this.blocked,
    createdAtByKey: createdAtByKey.present
        ? createdAtByKey.value
        : this.createdAtByKey,
  );
  OrganizationRow copyWithCompanion(OrganizationsCompanion data) {
    return OrganizationRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      city: data.city.present ? data.city.value : this.city,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      logoPath: data.logoPath.present ? data.logoPath.value : this.logoPath,
      blocked: data.blocked.present ? data.blocked.value : this.blocked,
      createdAtByKey: data.createdAtByKey.present
          ? data.createdAtByKey.value
          : this.createdAtByKey,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrganizationRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('city: $city, ')
          ..write('ownerId: $ownerId, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('logoPath: $logoPath, ')
          ..write('blocked: $blocked, ')
          ..write('createdAtByKey: $createdAtByKey')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    type,
    city,
    ownerId,
    phone,
    email,
    logoPath,
    blocked,
    createdAtByKey,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrganizationRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.city == this.city &&
          other.ownerId == this.ownerId &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.logoPath == this.logoPath &&
          other.blocked == this.blocked &&
          other.createdAtByKey == this.createdAtByKey);
}

class OrganizationsCompanion extends UpdateCompanion<OrganizationRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> type;
  final Value<String> city;
  final Value<String> ownerId;
  final Value<String> phone;
  final Value<String> email;
  final Value<String?> logoPath;
  final Value<bool> blocked;
  final Value<String?> createdAtByKey;
  final Value<int> rowid;
  const OrganizationsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.city = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.logoPath = const Value.absent(),
    this.blocked = const Value.absent(),
    this.createdAtByKey = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OrganizationsCompanion.insert({
    required String id,
    required String name,
    required String type,
    required String city,
    required String ownerId,
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.logoPath = const Value.absent(),
    this.blocked = const Value.absent(),
    this.createdAtByKey = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       type = Value(type),
       city = Value(city),
       ownerId = Value(ownerId);
  static Insertable<OrganizationRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? city,
    Expression<String>? ownerId,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? logoPath,
    Expression<bool>? blocked,
    Expression<String>? createdAtByKey,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (city != null) 'city': city,
      if (ownerId != null) 'owner_id': ownerId,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (logoPath != null) 'logo_path': logoPath,
      if (blocked != null) 'blocked': blocked,
      if (createdAtByKey != null) 'created_at_by_key': createdAtByKey,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OrganizationsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? type,
    Value<String>? city,
    Value<String>? ownerId,
    Value<String>? phone,
    Value<String>? email,
    Value<String?>? logoPath,
    Value<bool>? blocked,
    Value<String?>? createdAtByKey,
    Value<int>? rowid,
  }) {
    return OrganizationsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      city: city ?? this.city,
      ownerId: ownerId ?? this.ownerId,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      logoPath: logoPath ?? this.logoPath,
      blocked: blocked ?? this.blocked,
      createdAtByKey: createdAtByKey ?? this.createdAtByKey,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (logoPath.present) {
      map['logo_path'] = Variable<String>(logoPath.value);
    }
    if (blocked.present) {
      map['blocked'] = Variable<bool>(blocked.value);
    }
    if (createdAtByKey.present) {
      map['created_at_by_key'] = Variable<String>(createdAtByKey.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrganizationsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('city: $city, ')
          ..write('ownerId: $ownerId, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('logoPath: $logoPath, ')
          ..write('blocked: $blocked, ')
          ..write('createdAtByKey: $createdAtByKey, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OrganizationMembersTable extends OrganizationMembers
    with TableInfo<$OrganizationMembersTable, OrgMemberRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrganizationMembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _orgIdMeta = const VerificationMeta('orgId');
  @override
  late final GeneratedColumn<String> orgId = GeneratedColumn<String>(
    'org_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _requestedAtMeta = const VerificationMeta(
    'requestedAt',
  );
  @override
  late final GeneratedColumn<DateTime> requestedAt = GeneratedColumn<DateTime>(
    'requested_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    orgId,
    userId,
    role,
    status,
    requestedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'organization_members';
  @override
  VerificationContext validateIntegrity(
    Insertable<OrgMemberRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('org_id')) {
      context.handle(
        _orgIdMeta,
        orgId.isAcceptableOrUnknown(data['org_id']!, _orgIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orgIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('requested_at')) {
      context.handle(
        _requestedAtMeta,
        requestedAt.isAcceptableOrUnknown(
          data['requested_at']!,
          _requestedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_requestedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {orgId, userId};
  @override
  OrgMemberRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrgMemberRow(
      orgId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}org_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      requestedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}requested_at'],
      )!,
    );
  }

  @override
  $OrganizationMembersTable createAlias(String alias) {
    return $OrganizationMembersTable(attachedDatabase, alias);
  }
}

class OrgMemberRow extends DataClass implements Insertable<OrgMemberRow> {
  final String orgId;
  final String userId;
  final String role;
  final String status;
  final DateTime requestedAt;
  const OrgMemberRow({
    required this.orgId,
    required this.userId,
    required this.role,
    required this.status,
    required this.requestedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['org_id'] = Variable<String>(orgId);
    map['user_id'] = Variable<String>(userId);
    map['role'] = Variable<String>(role);
    map['status'] = Variable<String>(status);
    map['requested_at'] = Variable<DateTime>(requestedAt);
    return map;
  }

  OrganizationMembersCompanion toCompanion(bool nullToAbsent) {
    return OrganizationMembersCompanion(
      orgId: Value(orgId),
      userId: Value(userId),
      role: Value(role),
      status: Value(status),
      requestedAt: Value(requestedAt),
    );
  }

  factory OrgMemberRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrgMemberRow(
      orgId: serializer.fromJson<String>(json['orgId']),
      userId: serializer.fromJson<String>(json['userId']),
      role: serializer.fromJson<String>(json['role']),
      status: serializer.fromJson<String>(json['status']),
      requestedAt: serializer.fromJson<DateTime>(json['requestedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'orgId': serializer.toJson<String>(orgId),
      'userId': serializer.toJson<String>(userId),
      'role': serializer.toJson<String>(role),
      'status': serializer.toJson<String>(status),
      'requestedAt': serializer.toJson<DateTime>(requestedAt),
    };
  }

  OrgMemberRow copyWith({
    String? orgId,
    String? userId,
    String? role,
    String? status,
    DateTime? requestedAt,
  }) => OrgMemberRow(
    orgId: orgId ?? this.orgId,
    userId: userId ?? this.userId,
    role: role ?? this.role,
    status: status ?? this.status,
    requestedAt: requestedAt ?? this.requestedAt,
  );
  OrgMemberRow copyWithCompanion(OrganizationMembersCompanion data) {
    return OrgMemberRow(
      orgId: data.orgId.present ? data.orgId.value : this.orgId,
      userId: data.userId.present ? data.userId.value : this.userId,
      role: data.role.present ? data.role.value : this.role,
      status: data.status.present ? data.status.value : this.status,
      requestedAt: data.requestedAt.present
          ? data.requestedAt.value
          : this.requestedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrgMemberRow(')
          ..write('orgId: $orgId, ')
          ..write('userId: $userId, ')
          ..write('role: $role, ')
          ..write('status: $status, ')
          ..write('requestedAt: $requestedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(orgId, userId, role, status, requestedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrgMemberRow &&
          other.orgId == this.orgId &&
          other.userId == this.userId &&
          other.role == this.role &&
          other.status == this.status &&
          other.requestedAt == this.requestedAt);
}

class OrganizationMembersCompanion extends UpdateCompanion<OrgMemberRow> {
  final Value<String> orgId;
  final Value<String> userId;
  final Value<String> role;
  final Value<String> status;
  final Value<DateTime> requestedAt;
  final Value<int> rowid;
  const OrganizationMembersCompanion({
    this.orgId = const Value.absent(),
    this.userId = const Value.absent(),
    this.role = const Value.absent(),
    this.status = const Value.absent(),
    this.requestedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OrganizationMembersCompanion.insert({
    required String orgId,
    required String userId,
    required String role,
    required String status,
    required DateTime requestedAt,
    this.rowid = const Value.absent(),
  }) : orgId = Value(orgId),
       userId = Value(userId),
       role = Value(role),
       status = Value(status),
       requestedAt = Value(requestedAt);
  static Insertable<OrgMemberRow> custom({
    Expression<String>? orgId,
    Expression<String>? userId,
    Expression<String>? role,
    Expression<String>? status,
    Expression<DateTime>? requestedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (orgId != null) 'org_id': orgId,
      if (userId != null) 'user_id': userId,
      if (role != null) 'role': role,
      if (status != null) 'status': status,
      if (requestedAt != null) 'requested_at': requestedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OrganizationMembersCompanion copyWith({
    Value<String>? orgId,
    Value<String>? userId,
    Value<String>? role,
    Value<String>? status,
    Value<DateTime>? requestedAt,
    Value<int>? rowid,
  }) {
    return OrganizationMembersCompanion(
      orgId: orgId ?? this.orgId,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      status: status ?? this.status,
      requestedAt: requestedAt ?? this.requestedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (orgId.present) {
      map['org_id'] = Variable<String>(orgId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (requestedAt.present) {
      map['requested_at'] = Variable<DateTime>(requestedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrganizationMembersCompanion(')
          ..write('orgId: $orgId, ')
          ..write('userId: $userId, ')
          ..write('role: $role, ')
          ..write('status: $status, ')
          ..write('requestedAt: $requestedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InviteKeysTable extends InviteKeys
    with TableInfo<$InviteKeysTable, InviteKeyRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InviteKeysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _keyHashMeta = const VerificationMeta(
    'keyHash',
  );
  @override
  late final GeneratedColumn<String> keyHash = GeneratedColumn<String>(
    'key_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _usedMeta = const VerificationMeta('used');
  @override
  late final GeneratedColumn<bool> used = GeneratedColumn<bool>(
    'used',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("used" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _orgIdMeta = const VerificationMeta('orgId');
  @override
  late final GeneratedColumn<String> orgId = GeneratedColumn<String>(
    'org_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    keyHash,
    used,
    attempts,
    orgId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'invite_keys';
  @override
  VerificationContext validateIntegrity(
    Insertable<InviteKeyRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('key_hash')) {
      context.handle(
        _keyHashMeta,
        keyHash.isAcceptableOrUnknown(data['key_hash']!, _keyHashMeta),
      );
    } else if (isInserting) {
      context.missing(_keyHashMeta);
    }
    if (data.containsKey('used')) {
      context.handle(
        _usedMeta,
        used.isAcceptableOrUnknown(data['used']!, _usedMeta),
      );
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('org_id')) {
      context.handle(
        _orgIdMeta,
        orgId.isAcceptableOrUnknown(data['org_id']!, _orgIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InviteKeyRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InviteKeyRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      keyHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key_hash'],
      )!,
      used: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}used'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      orgId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}org_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
    );
  }

  @override
  $InviteKeysTable createAlias(String alias) {
    return $InviteKeysTable(attachedDatabase, alias);
  }
}

class InviteKeyRow extends DataClass implements Insertable<InviteKeyRow> {
  final String id;
  final String keyHash;
  final bool used;
  final int attempts;
  final String? orgId;
  final DateTime? createdAt;
  const InviteKeyRow({
    required this.id,
    required this.keyHash,
    required this.used,
    required this.attempts,
    this.orgId,
    this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['key_hash'] = Variable<String>(keyHash);
    map['used'] = Variable<bool>(used);
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || orgId != null) {
      map['org_id'] = Variable<String>(orgId);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    return map;
  }

  InviteKeysCompanion toCompanion(bool nullToAbsent) {
    return InviteKeysCompanion(
      id: Value(id),
      keyHash: Value(keyHash),
      used: Value(used),
      attempts: Value(attempts),
      orgId: orgId == null && nullToAbsent
          ? const Value.absent()
          : Value(orgId),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory InviteKeyRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InviteKeyRow(
      id: serializer.fromJson<String>(json['id']),
      keyHash: serializer.fromJson<String>(json['keyHash']),
      used: serializer.fromJson<bool>(json['used']),
      attempts: serializer.fromJson<int>(json['attempts']),
      orgId: serializer.fromJson<String?>(json['orgId']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'keyHash': serializer.toJson<String>(keyHash),
      'used': serializer.toJson<bool>(used),
      'attempts': serializer.toJson<int>(attempts),
      'orgId': serializer.toJson<String?>(orgId),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  InviteKeyRow copyWith({
    String? id,
    String? keyHash,
    bool? used,
    int? attempts,
    Value<String?> orgId = const Value.absent(),
    Value<DateTime?> createdAt = const Value.absent(),
  }) => InviteKeyRow(
    id: id ?? this.id,
    keyHash: keyHash ?? this.keyHash,
    used: used ?? this.used,
    attempts: attempts ?? this.attempts,
    orgId: orgId.present ? orgId.value : this.orgId,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
  );
  InviteKeyRow copyWithCompanion(InviteKeysCompanion data) {
    return InviteKeyRow(
      id: data.id.present ? data.id.value : this.id,
      keyHash: data.keyHash.present ? data.keyHash.value : this.keyHash,
      used: data.used.present ? data.used.value : this.used,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      orgId: data.orgId.present ? data.orgId.value : this.orgId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InviteKeyRow(')
          ..write('id: $id, ')
          ..write('keyHash: $keyHash, ')
          ..write('used: $used, ')
          ..write('attempts: $attempts, ')
          ..write('orgId: $orgId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, keyHash, used, attempts, orgId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InviteKeyRow &&
          other.id == this.id &&
          other.keyHash == this.keyHash &&
          other.used == this.used &&
          other.attempts == this.attempts &&
          other.orgId == this.orgId &&
          other.createdAt == this.createdAt);
}

class InviteKeysCompanion extends UpdateCompanion<InviteKeyRow> {
  final Value<String> id;
  final Value<String> keyHash;
  final Value<bool> used;
  final Value<int> attempts;
  final Value<String?> orgId;
  final Value<DateTime?> createdAt;
  final Value<int> rowid;
  const InviteKeysCompanion({
    this.id = const Value.absent(),
    this.keyHash = const Value.absent(),
    this.used = const Value.absent(),
    this.attempts = const Value.absent(),
    this.orgId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InviteKeysCompanion.insert({
    required String id,
    required String keyHash,
    this.used = const Value.absent(),
    this.attempts = const Value.absent(),
    this.orgId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       keyHash = Value(keyHash);
  static Insertable<InviteKeyRow> custom({
    Expression<String>? id,
    Expression<String>? keyHash,
    Expression<bool>? used,
    Expression<int>? attempts,
    Expression<String>? orgId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (keyHash != null) 'key_hash': keyHash,
      if (used != null) 'used': used,
      if (attempts != null) 'attempts': attempts,
      if (orgId != null) 'org_id': orgId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InviteKeysCompanion copyWith({
    Value<String>? id,
    Value<String>? keyHash,
    Value<bool>? used,
    Value<int>? attempts,
    Value<String?>? orgId,
    Value<DateTime?>? createdAt,
    Value<int>? rowid,
  }) {
    return InviteKeysCompanion(
      id: id ?? this.id,
      keyHash: keyHash ?? this.keyHash,
      used: used ?? this.used,
      attempts: attempts ?? this.attempts,
      orgId: orgId ?? this.orgId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (keyHash.present) {
      map['key_hash'] = Variable<String>(keyHash.value);
    }
    if (used.present) {
      map['used'] = Variable<bool>(used.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (orgId.present) {
      map['org_id'] = Variable<String>(orgId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InviteKeysCompanion(')
          ..write('id: $id, ')
          ..write('keyHash: $keyHash, ')
          ..write('used: $used, ')
          ..write('attempts: $attempts, ')
          ..write('orgId: $orgId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EventsTable extends Events with TableInfo<$EventsTable, EventRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orgIdMeta = const VerificationMeta('orgId');
  @override
  late final GeneratedColumn<String> orgId = GeneratedColumn<String>(
    'org_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startAtMeta = const VerificationMeta(
    'startAt',
  );
  @override
  late final GeneratedColumn<DateTime> startAt = GeneratedColumn<DateTime>(
    'start_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _placeMeta = const VerificationMeta('place');
  @override
  late final GeneratedColumn<String> place = GeneratedColumn<String>(
    'place',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _capacityMeta = const VerificationMeta(
    'capacity',
  );
  @override
  late final GeneratedColumn<int> capacity = GeneratedColumn<int>(
    'capacity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(-1),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _moderationNoteMeta = const VerificationMeta(
    'moderationNote',
  );
  @override
  late final GeneratedColumn<String> moderationNote = GeneratedColumn<String>(
    'moderation_note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _cancelledAtMeta = const VerificationMeta(
    'cancelledAt',
  );
  @override
  late final GeneratedColumn<DateTime> cancelledAt = GeneratedColumn<DateTime>(
    'cancelled_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    orgId,
    title,
    description,
    category,
    startAt,
    place,
    capacity,
    status,
    moderationNote,
    cancelledAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'events';
  @override
  VerificationContext validateIntegrity(
    Insertable<EventRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('org_id')) {
      context.handle(
        _orgIdMeta,
        orgId.isAcceptableOrUnknown(data['org_id']!, _orgIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orgIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('start_at')) {
      context.handle(
        _startAtMeta,
        startAt.isAcceptableOrUnknown(data['start_at']!, _startAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startAtMeta);
    }
    if (data.containsKey('place')) {
      context.handle(
        _placeMeta,
        place.isAcceptableOrUnknown(data['place']!, _placeMeta),
      );
    } else if (isInserting) {
      context.missing(_placeMeta);
    }
    if (data.containsKey('capacity')) {
      context.handle(
        _capacityMeta,
        capacity.isAcceptableOrUnknown(data['capacity']!, _capacityMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('moderation_note')) {
      context.handle(
        _moderationNoteMeta,
        moderationNote.isAcceptableOrUnknown(
          data['moderation_note']!,
          _moderationNoteMeta,
        ),
      );
    }
    if (data.containsKey('cancelled_at')) {
      context.handle(
        _cancelledAtMeta,
        cancelledAt.isAcceptableOrUnknown(
          data['cancelled_at']!,
          _cancelledAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EventRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EventRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      orgId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}org_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      startAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_at'],
      )!,
      place: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}place'],
      )!,
      capacity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}capacity'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      moderationNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}moderation_note'],
      )!,
      cancelledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cancelled_at'],
      ),
    );
  }

  @override
  $EventsTable createAlias(String alias) {
    return $EventsTable(attachedDatabase, alias);
  }
}

class EventRow extends DataClass implements Insertable<EventRow> {
  final String id;
  final String orgId;
  final String title;
  final String description;
  final String category;
  final DateTime startAt;
  final String place;
  final int capacity;
  final String status;
  final String moderationNote;
  final DateTime? cancelledAt;
  const EventRow({
    required this.id,
    required this.orgId,
    required this.title,
    required this.description,
    required this.category,
    required this.startAt,
    required this.place,
    required this.capacity,
    required this.status,
    required this.moderationNote,
    this.cancelledAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['org_id'] = Variable<String>(orgId);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['category'] = Variable<String>(category);
    map['start_at'] = Variable<DateTime>(startAt);
    map['place'] = Variable<String>(place);
    map['capacity'] = Variable<int>(capacity);
    map['status'] = Variable<String>(status);
    map['moderation_note'] = Variable<String>(moderationNote);
    if (!nullToAbsent || cancelledAt != null) {
      map['cancelled_at'] = Variable<DateTime>(cancelledAt);
    }
    return map;
  }

  EventsCompanion toCompanion(bool nullToAbsent) {
    return EventsCompanion(
      id: Value(id),
      orgId: Value(orgId),
      title: Value(title),
      description: Value(description),
      category: Value(category),
      startAt: Value(startAt),
      place: Value(place),
      capacity: Value(capacity),
      status: Value(status),
      moderationNote: Value(moderationNote),
      cancelledAt: cancelledAt == null && nullToAbsent
          ? const Value.absent()
          : Value(cancelledAt),
    );
  }

  factory EventRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EventRow(
      id: serializer.fromJson<String>(json['id']),
      orgId: serializer.fromJson<String>(json['orgId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      category: serializer.fromJson<String>(json['category']),
      startAt: serializer.fromJson<DateTime>(json['startAt']),
      place: serializer.fromJson<String>(json['place']),
      capacity: serializer.fromJson<int>(json['capacity']),
      status: serializer.fromJson<String>(json['status']),
      moderationNote: serializer.fromJson<String>(json['moderationNote']),
      cancelledAt: serializer.fromJson<DateTime?>(json['cancelledAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'orgId': serializer.toJson<String>(orgId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'category': serializer.toJson<String>(category),
      'startAt': serializer.toJson<DateTime>(startAt),
      'place': serializer.toJson<String>(place),
      'capacity': serializer.toJson<int>(capacity),
      'status': serializer.toJson<String>(status),
      'moderationNote': serializer.toJson<String>(moderationNote),
      'cancelledAt': serializer.toJson<DateTime?>(cancelledAt),
    };
  }

  EventRow copyWith({
    String? id,
    String? orgId,
    String? title,
    String? description,
    String? category,
    DateTime? startAt,
    String? place,
    int? capacity,
    String? status,
    String? moderationNote,
    Value<DateTime?> cancelledAt = const Value.absent(),
  }) => EventRow(
    id: id ?? this.id,
    orgId: orgId ?? this.orgId,
    title: title ?? this.title,
    description: description ?? this.description,
    category: category ?? this.category,
    startAt: startAt ?? this.startAt,
    place: place ?? this.place,
    capacity: capacity ?? this.capacity,
    status: status ?? this.status,
    moderationNote: moderationNote ?? this.moderationNote,
    cancelledAt: cancelledAt.present ? cancelledAt.value : this.cancelledAt,
  );
  EventRow copyWithCompanion(EventsCompanion data) {
    return EventRow(
      id: data.id.present ? data.id.value : this.id,
      orgId: data.orgId.present ? data.orgId.value : this.orgId,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      category: data.category.present ? data.category.value : this.category,
      startAt: data.startAt.present ? data.startAt.value : this.startAt,
      place: data.place.present ? data.place.value : this.place,
      capacity: data.capacity.present ? data.capacity.value : this.capacity,
      status: data.status.present ? data.status.value : this.status,
      moderationNote: data.moderationNote.present
          ? data.moderationNote.value
          : this.moderationNote,
      cancelledAt: data.cancelledAt.present
          ? data.cancelledAt.value
          : this.cancelledAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EventRow(')
          ..write('id: $id, ')
          ..write('orgId: $orgId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('startAt: $startAt, ')
          ..write('place: $place, ')
          ..write('capacity: $capacity, ')
          ..write('status: $status, ')
          ..write('moderationNote: $moderationNote, ')
          ..write('cancelledAt: $cancelledAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    orgId,
    title,
    description,
    category,
    startAt,
    place,
    capacity,
    status,
    moderationNote,
    cancelledAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EventRow &&
          other.id == this.id &&
          other.orgId == this.orgId &&
          other.title == this.title &&
          other.description == this.description &&
          other.category == this.category &&
          other.startAt == this.startAt &&
          other.place == this.place &&
          other.capacity == this.capacity &&
          other.status == this.status &&
          other.moderationNote == this.moderationNote &&
          other.cancelledAt == this.cancelledAt);
}

class EventsCompanion extends UpdateCompanion<EventRow> {
  final Value<String> id;
  final Value<String> orgId;
  final Value<String> title;
  final Value<String> description;
  final Value<String> category;
  final Value<DateTime> startAt;
  final Value<String> place;
  final Value<int> capacity;
  final Value<String> status;
  final Value<String> moderationNote;
  final Value<DateTime?> cancelledAt;
  final Value<int> rowid;
  const EventsCompanion({
    this.id = const Value.absent(),
    this.orgId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    this.startAt = const Value.absent(),
    this.place = const Value.absent(),
    this.capacity = const Value.absent(),
    this.status = const Value.absent(),
    this.moderationNote = const Value.absent(),
    this.cancelledAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EventsCompanion.insert({
    required String id,
    required String orgId,
    required String title,
    this.description = const Value.absent(),
    required String category,
    required DateTime startAt,
    required String place,
    this.capacity = const Value.absent(),
    required String status,
    this.moderationNote = const Value.absent(),
    this.cancelledAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       orgId = Value(orgId),
       title = Value(title),
       category = Value(category),
       startAt = Value(startAt),
       place = Value(place),
       status = Value(status);
  static Insertable<EventRow> custom({
    Expression<String>? id,
    Expression<String>? orgId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? category,
    Expression<DateTime>? startAt,
    Expression<String>? place,
    Expression<int>? capacity,
    Expression<String>? status,
    Expression<String>? moderationNote,
    Expression<DateTime>? cancelledAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orgId != null) 'org_id': orgId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (category != null) 'category': category,
      if (startAt != null) 'start_at': startAt,
      if (place != null) 'place': place,
      if (capacity != null) 'capacity': capacity,
      if (status != null) 'status': status,
      if (moderationNote != null) 'moderation_note': moderationNote,
      if (cancelledAt != null) 'cancelled_at': cancelledAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EventsCompanion copyWith({
    Value<String>? id,
    Value<String>? orgId,
    Value<String>? title,
    Value<String>? description,
    Value<String>? category,
    Value<DateTime>? startAt,
    Value<String>? place,
    Value<int>? capacity,
    Value<String>? status,
    Value<String>? moderationNote,
    Value<DateTime?>? cancelledAt,
    Value<int>? rowid,
  }) {
    return EventsCompanion(
      id: id ?? this.id,
      orgId: orgId ?? this.orgId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      startAt: startAt ?? this.startAt,
      place: place ?? this.place,
      capacity: capacity ?? this.capacity,
      status: status ?? this.status,
      moderationNote: moderationNote ?? this.moderationNote,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (orgId.present) {
      map['org_id'] = Variable<String>(orgId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (startAt.present) {
      map['start_at'] = Variable<DateTime>(startAt.value);
    }
    if (place.present) {
      map['place'] = Variable<String>(place.value);
    }
    if (capacity.present) {
      map['capacity'] = Variable<int>(capacity.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (moderationNote.present) {
      map['moderation_note'] = Variable<String>(moderationNote.value);
    }
    if (cancelledAt.present) {
      map['cancelled_at'] = Variable<DateTime>(cancelledAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventsCompanion(')
          ..write('id: $id, ')
          ..write('orgId: $orgId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('startAt: $startAt, ')
          ..write('place: $place, ')
          ..write('capacity: $capacity, ')
          ..write('status: $status, ')
          ..write('moderationNote: $moderationNote, ')
          ..write('cancelledAt: $cancelledAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EventMediaTable extends EventMedia
    with TableInfo<$EventMediaTable, EventMediaRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventMediaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventIdMeta = const VerificationMeta(
    'eventId',
  );
  @override
  late final GeneratedColumn<String> eventId = GeneratedColumn<String>(
    'event_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _previewPathMeta = const VerificationMeta(
    'previewPath',
  );
  @override
  late final GeneratedColumn<String> previewPath = GeneratedColumn<String>(
    'preview_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _bytesMeta = const VerificationMeta('bytes');
  @override
  late final GeneratedColumn<int> bytes = GeneratedColumn<int>(
    'bytes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    eventId,
    kind,
    path,
    previewPath,
    position,
    durationMs,
    bytes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'event_media';
  @override
  VerificationContext validateIntegrity(
    Insertable<EventMediaRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('event_id')) {
      context.handle(
        _eventIdMeta,
        eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta),
      );
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('preview_path')) {
      context.handle(
        _previewPathMeta,
        previewPath.isAcceptableOrUnknown(
          data['preview_path']!,
          _previewPathMeta,
        ),
      );
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    }
    if (data.containsKey('bytes')) {
      context.handle(
        _bytesMeta,
        bytes.isAcceptableOrUnknown(data['bytes']!, _bytesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EventMediaRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EventMediaRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      eventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      )!,
      previewPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preview_path'],
      ),
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      )!,
      bytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bytes'],
      )!,
    );
  }

  @override
  $EventMediaTable createAlias(String alias) {
    return $EventMediaTable(attachedDatabase, alias);
  }
}

class EventMediaRow extends DataClass implements Insertable<EventMediaRow> {
  final String id;
  final String eventId;
  final String kind;
  final String path;
  final String? previewPath;
  final int position;
  final int durationMs;
  final int bytes;
  const EventMediaRow({
    required this.id,
    required this.eventId,
    required this.kind,
    required this.path,
    this.previewPath,
    required this.position,
    required this.durationMs,
    required this.bytes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['event_id'] = Variable<String>(eventId);
    map['kind'] = Variable<String>(kind);
    map['path'] = Variable<String>(path);
    if (!nullToAbsent || previewPath != null) {
      map['preview_path'] = Variable<String>(previewPath);
    }
    map['position'] = Variable<int>(position);
    map['duration_ms'] = Variable<int>(durationMs);
    map['bytes'] = Variable<int>(bytes);
    return map;
  }

  EventMediaCompanion toCompanion(bool nullToAbsent) {
    return EventMediaCompanion(
      id: Value(id),
      eventId: Value(eventId),
      kind: Value(kind),
      path: Value(path),
      previewPath: previewPath == null && nullToAbsent
          ? const Value.absent()
          : Value(previewPath),
      position: Value(position),
      durationMs: Value(durationMs),
      bytes: Value(bytes),
    );
  }

  factory EventMediaRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EventMediaRow(
      id: serializer.fromJson<String>(json['id']),
      eventId: serializer.fromJson<String>(json['eventId']),
      kind: serializer.fromJson<String>(json['kind']),
      path: serializer.fromJson<String>(json['path']),
      previewPath: serializer.fromJson<String?>(json['previewPath']),
      position: serializer.fromJson<int>(json['position']),
      durationMs: serializer.fromJson<int>(json['durationMs']),
      bytes: serializer.fromJson<int>(json['bytes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'eventId': serializer.toJson<String>(eventId),
      'kind': serializer.toJson<String>(kind),
      'path': serializer.toJson<String>(path),
      'previewPath': serializer.toJson<String?>(previewPath),
      'position': serializer.toJson<int>(position),
      'durationMs': serializer.toJson<int>(durationMs),
      'bytes': serializer.toJson<int>(bytes),
    };
  }

  EventMediaRow copyWith({
    String? id,
    String? eventId,
    String? kind,
    String? path,
    Value<String?> previewPath = const Value.absent(),
    int? position,
    int? durationMs,
    int? bytes,
  }) => EventMediaRow(
    id: id ?? this.id,
    eventId: eventId ?? this.eventId,
    kind: kind ?? this.kind,
    path: path ?? this.path,
    previewPath: previewPath.present ? previewPath.value : this.previewPath,
    position: position ?? this.position,
    durationMs: durationMs ?? this.durationMs,
    bytes: bytes ?? this.bytes,
  );
  EventMediaRow copyWithCompanion(EventMediaCompanion data) {
    return EventMediaRow(
      id: data.id.present ? data.id.value : this.id,
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      kind: data.kind.present ? data.kind.value : this.kind,
      path: data.path.present ? data.path.value : this.path,
      previewPath: data.previewPath.present
          ? data.previewPath.value
          : this.previewPath,
      position: data.position.present ? data.position.value : this.position,
      durationMs: data.durationMs.present
          ? data.durationMs.value
          : this.durationMs,
      bytes: data.bytes.present ? data.bytes.value : this.bytes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EventMediaRow(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('kind: $kind, ')
          ..write('path: $path, ')
          ..write('previewPath: $previewPath, ')
          ..write('position: $position, ')
          ..write('durationMs: $durationMs, ')
          ..write('bytes: $bytes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    eventId,
    kind,
    path,
    previewPath,
    position,
    durationMs,
    bytes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EventMediaRow &&
          other.id == this.id &&
          other.eventId == this.eventId &&
          other.kind == this.kind &&
          other.path == this.path &&
          other.previewPath == this.previewPath &&
          other.position == this.position &&
          other.durationMs == this.durationMs &&
          other.bytes == this.bytes);
}

class EventMediaCompanion extends UpdateCompanion<EventMediaRow> {
  final Value<String> id;
  final Value<String> eventId;
  final Value<String> kind;
  final Value<String> path;
  final Value<String?> previewPath;
  final Value<int> position;
  final Value<int> durationMs;
  final Value<int> bytes;
  final Value<int> rowid;
  const EventMediaCompanion({
    this.id = const Value.absent(),
    this.eventId = const Value.absent(),
    this.kind = const Value.absent(),
    this.path = const Value.absent(),
    this.previewPath = const Value.absent(),
    this.position = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.bytes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EventMediaCompanion.insert({
    required String id,
    required String eventId,
    required String kind,
    required String path,
    this.previewPath = const Value.absent(),
    this.position = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.bytes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       eventId = Value(eventId),
       kind = Value(kind),
       path = Value(path);
  static Insertable<EventMediaRow> custom({
    Expression<String>? id,
    Expression<String>? eventId,
    Expression<String>? kind,
    Expression<String>? path,
    Expression<String>? previewPath,
    Expression<int>? position,
    Expression<int>? durationMs,
    Expression<int>? bytes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eventId != null) 'event_id': eventId,
      if (kind != null) 'kind': kind,
      if (path != null) 'path': path,
      if (previewPath != null) 'preview_path': previewPath,
      if (position != null) 'position': position,
      if (durationMs != null) 'duration_ms': durationMs,
      if (bytes != null) 'bytes': bytes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EventMediaCompanion copyWith({
    Value<String>? id,
    Value<String>? eventId,
    Value<String>? kind,
    Value<String>? path,
    Value<String?>? previewPath,
    Value<int>? position,
    Value<int>? durationMs,
    Value<int>? bytes,
    Value<int>? rowid,
  }) {
    return EventMediaCompanion(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      kind: kind ?? this.kind,
      path: path ?? this.path,
      previewPath: previewPath ?? this.previewPath,
      position: position ?? this.position,
      durationMs: durationMs ?? this.durationMs,
      bytes: bytes ?? this.bytes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (eventId.present) {
      map['event_id'] = Variable<String>(eventId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (previewPath.present) {
      map['preview_path'] = Variable<String>(previewPath.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (bytes.present) {
      map['bytes'] = Variable<int>(bytes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventMediaCompanion(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('kind: $kind, ')
          ..write('path: $path, ')
          ..write('previewPath: $previewPath, ')
          ..write('position: $position, ')
          ..write('durationMs: $durationMs, ')
          ..write('bytes: $bytes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EventCustomFieldsTable extends EventCustomFields
    with TableInfo<$EventCustomFieldsTable, CustomFieldRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventCustomFieldsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventIdMeta = const VerificationMeta(
    'eventId',
  );
  @override
  late final GeneratedColumn<String> eventId = GeneratedColumn<String>(
    'event_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _optionsMeta = const VerificationMeta(
    'options',
  );
  @override
  late final GeneratedColumn<String> options = GeneratedColumn<String>(
    'options',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    eventId,
    label,
    type,
    value,
    options,
    position,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'event_custom_fields';
  @override
  VerificationContext validateIntegrity(
    Insertable<CustomFieldRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('event_id')) {
      context.handle(
        _eventIdMeta,
        eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta),
      );
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    }
    if (data.containsKey('options')) {
      context.handle(
        _optionsMeta,
        options.isAcceptableOrUnknown(data['options']!, _optionsMeta),
      );
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomFieldRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomFieldRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      eventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      options: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}options'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $EventCustomFieldsTable createAlias(String alias) {
    return $EventCustomFieldsTable(attachedDatabase, alias);
  }
}

class CustomFieldRow extends DataClass implements Insertable<CustomFieldRow> {
  final String id;
  final String eventId;
  final String label;
  final String type;
  final String value;
  final String options;
  final int position;
  const CustomFieldRow({
    required this.id,
    required this.eventId,
    required this.label,
    required this.type,
    required this.value,
    required this.options,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['event_id'] = Variable<String>(eventId);
    map['label'] = Variable<String>(label);
    map['type'] = Variable<String>(type);
    map['value'] = Variable<String>(value);
    map['options'] = Variable<String>(options);
    map['position'] = Variable<int>(position);
    return map;
  }

  EventCustomFieldsCompanion toCompanion(bool nullToAbsent) {
    return EventCustomFieldsCompanion(
      id: Value(id),
      eventId: Value(eventId),
      label: Value(label),
      type: Value(type),
      value: Value(value),
      options: Value(options),
      position: Value(position),
    );
  }

  factory CustomFieldRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomFieldRow(
      id: serializer.fromJson<String>(json['id']),
      eventId: serializer.fromJson<String>(json['eventId']),
      label: serializer.fromJson<String>(json['label']),
      type: serializer.fromJson<String>(json['type']),
      value: serializer.fromJson<String>(json['value']),
      options: serializer.fromJson<String>(json['options']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'eventId': serializer.toJson<String>(eventId),
      'label': serializer.toJson<String>(label),
      'type': serializer.toJson<String>(type),
      'value': serializer.toJson<String>(value),
      'options': serializer.toJson<String>(options),
      'position': serializer.toJson<int>(position),
    };
  }

  CustomFieldRow copyWith({
    String? id,
    String? eventId,
    String? label,
    String? type,
    String? value,
    String? options,
    int? position,
  }) => CustomFieldRow(
    id: id ?? this.id,
    eventId: eventId ?? this.eventId,
    label: label ?? this.label,
    type: type ?? this.type,
    value: value ?? this.value,
    options: options ?? this.options,
    position: position ?? this.position,
  );
  CustomFieldRow copyWithCompanion(EventCustomFieldsCompanion data) {
    return CustomFieldRow(
      id: data.id.present ? data.id.value : this.id,
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      label: data.label.present ? data.label.value : this.label,
      type: data.type.present ? data.type.value : this.type,
      value: data.value.present ? data.value.value : this.value,
      options: data.options.present ? data.options.value : this.options,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomFieldRow(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('label: $label, ')
          ..write('type: $type, ')
          ..write('value: $value, ')
          ..write('options: $options, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, eventId, label, type, value, options, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomFieldRow &&
          other.id == this.id &&
          other.eventId == this.eventId &&
          other.label == this.label &&
          other.type == this.type &&
          other.value == this.value &&
          other.options == this.options &&
          other.position == this.position);
}

class EventCustomFieldsCompanion extends UpdateCompanion<CustomFieldRow> {
  final Value<String> id;
  final Value<String> eventId;
  final Value<String> label;
  final Value<String> type;
  final Value<String> value;
  final Value<String> options;
  final Value<int> position;
  final Value<int> rowid;
  const EventCustomFieldsCompanion({
    this.id = const Value.absent(),
    this.eventId = const Value.absent(),
    this.label = const Value.absent(),
    this.type = const Value.absent(),
    this.value = const Value.absent(),
    this.options = const Value.absent(),
    this.position = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EventCustomFieldsCompanion.insert({
    required String id,
    required String eventId,
    required String label,
    required String type,
    this.value = const Value.absent(),
    this.options = const Value.absent(),
    this.position = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       eventId = Value(eventId),
       label = Value(label),
       type = Value(type);
  static Insertable<CustomFieldRow> custom({
    Expression<String>? id,
    Expression<String>? eventId,
    Expression<String>? label,
    Expression<String>? type,
    Expression<String>? value,
    Expression<String>? options,
    Expression<int>? position,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eventId != null) 'event_id': eventId,
      if (label != null) 'label': label,
      if (type != null) 'type': type,
      if (value != null) 'value': value,
      if (options != null) 'options': options,
      if (position != null) 'position': position,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EventCustomFieldsCompanion copyWith({
    Value<String>? id,
    Value<String>? eventId,
    Value<String>? label,
    Value<String>? type,
    Value<String>? value,
    Value<String>? options,
    Value<int>? position,
    Value<int>? rowid,
  }) {
    return EventCustomFieldsCompanion(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      label: label ?? this.label,
      type: type ?? this.type,
      value: value ?? this.value,
      options: options ?? this.options,
      position: position ?? this.position,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (eventId.present) {
      map['event_id'] = Variable<String>(eventId.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (options.present) {
      map['options'] = Variable<String>(options.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventCustomFieldsCompanion(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('label: $label, ')
          ..write('type: $type, ')
          ..write('value: $value, ')
          ..write('options: $options, ')
          ..write('position: $position, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RegistrationsTable extends Registrations
    with TableInfo<$RegistrationsTable, RegistrationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RegistrationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventIdMeta = const VerificationMeta(
    'eventId',
  );
  @override
  late final GeneratedColumn<String> eventId = GeneratedColumn<String>(
    'event_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _checkedInAtMeta = const VerificationMeta(
    'checkedInAt',
  );
  @override
  late final GeneratedColumn<DateTime> checkedInAt = GeneratedColumn<DateTime>(
    'checked_in_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    eventId,
    userId,
    createdAt,
    checkedInAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'registrations';
  @override
  VerificationContext validateIntegrity(
    Insertable<RegistrationRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('event_id')) {
      context.handle(
        _eventIdMeta,
        eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta),
      );
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('checked_in_at')) {
      context.handle(
        _checkedInAtMeta,
        checkedInAt.isAcceptableOrUnknown(
          data['checked_in_at']!,
          _checkedInAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RegistrationRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RegistrationRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      eventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      checkedInAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}checked_in_at'],
      ),
    );
  }

  @override
  $RegistrationsTable createAlias(String alias) {
    return $RegistrationsTable(attachedDatabase, alias);
  }
}

class RegistrationRow extends DataClass implements Insertable<RegistrationRow> {
  final String id;
  final String eventId;
  final String userId;
  final DateTime createdAt;
  final DateTime? checkedInAt;
  const RegistrationRow({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.createdAt,
    this.checkedInAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['event_id'] = Variable<String>(eventId);
    map['user_id'] = Variable<String>(userId);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || checkedInAt != null) {
      map['checked_in_at'] = Variable<DateTime>(checkedInAt);
    }
    return map;
  }

  RegistrationsCompanion toCompanion(bool nullToAbsent) {
    return RegistrationsCompanion(
      id: Value(id),
      eventId: Value(eventId),
      userId: Value(userId),
      createdAt: Value(createdAt),
      checkedInAt: checkedInAt == null && nullToAbsent
          ? const Value.absent()
          : Value(checkedInAt),
    );
  }

  factory RegistrationRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RegistrationRow(
      id: serializer.fromJson<String>(json['id']),
      eventId: serializer.fromJson<String>(json['eventId']),
      userId: serializer.fromJson<String>(json['userId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      checkedInAt: serializer.fromJson<DateTime?>(json['checkedInAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'eventId': serializer.toJson<String>(eventId),
      'userId': serializer.toJson<String>(userId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'checkedInAt': serializer.toJson<DateTime?>(checkedInAt),
    };
  }

  RegistrationRow copyWith({
    String? id,
    String? eventId,
    String? userId,
    DateTime? createdAt,
    Value<DateTime?> checkedInAt = const Value.absent(),
  }) => RegistrationRow(
    id: id ?? this.id,
    eventId: eventId ?? this.eventId,
    userId: userId ?? this.userId,
    createdAt: createdAt ?? this.createdAt,
    checkedInAt: checkedInAt.present ? checkedInAt.value : this.checkedInAt,
  );
  RegistrationRow copyWithCompanion(RegistrationsCompanion data) {
    return RegistrationRow(
      id: data.id.present ? data.id.value : this.id,
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      userId: data.userId.present ? data.userId.value : this.userId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      checkedInAt: data.checkedInAt.present
          ? data.checkedInAt.value
          : this.checkedInAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RegistrationRow(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('checkedInAt: $checkedInAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, eventId, userId, createdAt, checkedInAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RegistrationRow &&
          other.id == this.id &&
          other.eventId == this.eventId &&
          other.userId == this.userId &&
          other.createdAt == this.createdAt &&
          other.checkedInAt == this.checkedInAt);
}

class RegistrationsCompanion extends UpdateCompanion<RegistrationRow> {
  final Value<String> id;
  final Value<String> eventId;
  final Value<String> userId;
  final Value<DateTime> createdAt;
  final Value<DateTime?> checkedInAt;
  final Value<int> rowid;
  const RegistrationsCompanion({
    this.id = const Value.absent(),
    this.eventId = const Value.absent(),
    this.userId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.checkedInAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RegistrationsCompanion.insert({
    required String id,
    required String eventId,
    required String userId,
    required DateTime createdAt,
    this.checkedInAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       eventId = Value(eventId),
       userId = Value(userId),
       createdAt = Value(createdAt);
  static Insertable<RegistrationRow> custom({
    Expression<String>? id,
    Expression<String>? eventId,
    Expression<String>? userId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? checkedInAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eventId != null) 'event_id': eventId,
      if (userId != null) 'user_id': userId,
      if (createdAt != null) 'created_at': createdAt,
      if (checkedInAt != null) 'checked_in_at': checkedInAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RegistrationsCompanion copyWith({
    Value<String>? id,
    Value<String>? eventId,
    Value<String>? userId,
    Value<DateTime>? createdAt,
    Value<DateTime?>? checkedInAt,
    Value<int>? rowid,
  }) {
    return RegistrationsCompanion(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      checkedInAt: checkedInAt ?? this.checkedInAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (eventId.present) {
      map['event_id'] = Variable<String>(eventId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (checkedInAt.present) {
      map['checked_in_at'] = Variable<DateTime>(checkedInAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RegistrationsCompanion(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('checkedInAt: $checkedInAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FavoritesTable extends Favorites
    with TableInfo<$FavoritesTable, FavoriteRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FavoritesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventIdMeta = const VerificationMeta(
    'eventId',
  );
  @override
  late final GeneratedColumn<String> eventId = GeneratedColumn<String>(
    'event_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [userId, eventId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'favorites';
  @override
  VerificationContext validateIntegrity(
    Insertable<FavoriteRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('event_id')) {
      context.handle(
        _eventIdMeta,
        eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta),
      );
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId, eventId};
  @override
  FavoriteRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FavoriteRow(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      eventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $FavoritesTable createAlias(String alias) {
    return $FavoritesTable(attachedDatabase, alias);
  }
}

class FavoriteRow extends DataClass implements Insertable<FavoriteRow> {
  final String userId;
  final String eventId;
  final DateTime createdAt;
  const FavoriteRow({
    required this.userId,
    required this.eventId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['event_id'] = Variable<String>(eventId);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  FavoritesCompanion toCompanion(bool nullToAbsent) {
    return FavoritesCompanion(
      userId: Value(userId),
      eventId: Value(eventId),
      createdAt: Value(createdAt),
    );
  }

  factory FavoriteRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FavoriteRow(
      userId: serializer.fromJson<String>(json['userId']),
      eventId: serializer.fromJson<String>(json['eventId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'eventId': serializer.toJson<String>(eventId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  FavoriteRow copyWith({
    String? userId,
    String? eventId,
    DateTime? createdAt,
  }) => FavoriteRow(
    userId: userId ?? this.userId,
    eventId: eventId ?? this.eventId,
    createdAt: createdAt ?? this.createdAt,
  );
  FavoriteRow copyWithCompanion(FavoritesCompanion data) {
    return FavoriteRow(
      userId: data.userId.present ? data.userId.value : this.userId,
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FavoriteRow(')
          ..write('userId: $userId, ')
          ..write('eventId: $eventId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(userId, eventId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FavoriteRow &&
          other.userId == this.userId &&
          other.eventId == this.eventId &&
          other.createdAt == this.createdAt);
}

class FavoritesCompanion extends UpdateCompanion<FavoriteRow> {
  final Value<String> userId;
  final Value<String> eventId;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const FavoritesCompanion({
    this.userId = const Value.absent(),
    this.eventId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FavoritesCompanion.insert({
    required String userId,
    required String eventId,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       eventId = Value(eventId),
       createdAt = Value(createdAt);
  static Insertable<FavoriteRow> custom({
    Expression<String>? userId,
    Expression<String>? eventId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (eventId != null) 'event_id': eventId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FavoritesCompanion copyWith({
    Value<String>? userId,
    Value<String>? eventId,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return FavoritesCompanion(
      userId: userId ?? this.userId,
      eventId: eventId ?? this.eventId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (eventId.present) {
      map['event_id'] = Variable<String>(eventId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavoritesCompanion(')
          ..write('userId: $userId, ')
          ..write('eventId: $eventId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RemindersTable extends Reminders
    with TableInfo<$RemindersTable, ReminderRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventIdMeta = const VerificationMeta(
    'eventId',
  );
  @override
  late final GeneratedColumn<String> eventId = GeneratedColumn<String>(
    'event_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fireAtMeta = const VerificationMeta('fireAt');
  @override
  late final GeneratedColumn<DateTime> fireAt = GeneratedColumn<DateTime>(
    'fire_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _offsetMeta = const VerificationMeta('offset');
  @override
  late final GeneratedColumn<String> offset = GeneratedColumn<String>(
    'offset',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [userId, eventId, fireAt, offset];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReminderRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('event_id')) {
      context.handle(
        _eventIdMeta,
        eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta),
      );
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('fire_at')) {
      context.handle(
        _fireAtMeta,
        fireAt.isAcceptableOrUnknown(data['fire_at']!, _fireAtMeta),
      );
    } else if (isInserting) {
      context.missing(_fireAtMeta);
    }
    if (data.containsKey('offset')) {
      context.handle(
        _offsetMeta,
        offset.isAcceptableOrUnknown(data['offset']!, _offsetMeta),
      );
    } else if (isInserting) {
      context.missing(_offsetMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId, eventId};
  @override
  ReminderRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReminderRow(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      eventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_id'],
      )!,
      fireAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fire_at'],
      )!,
      offset: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}offset'],
      )!,
    );
  }

  @override
  $RemindersTable createAlias(String alias) {
    return $RemindersTable(attachedDatabase, alias);
  }
}

class ReminderRow extends DataClass implements Insertable<ReminderRow> {
  final String userId;
  final String eventId;
  final DateTime fireAt;
  final String offset;
  const ReminderRow({
    required this.userId,
    required this.eventId,
    required this.fireAt,
    required this.offset,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['event_id'] = Variable<String>(eventId);
    map['fire_at'] = Variable<DateTime>(fireAt);
    map['offset'] = Variable<String>(offset);
    return map;
  }

  RemindersCompanion toCompanion(bool nullToAbsent) {
    return RemindersCompanion(
      userId: Value(userId),
      eventId: Value(eventId),
      fireAt: Value(fireAt),
      offset: Value(offset),
    );
  }

  factory ReminderRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReminderRow(
      userId: serializer.fromJson<String>(json['userId']),
      eventId: serializer.fromJson<String>(json['eventId']),
      fireAt: serializer.fromJson<DateTime>(json['fireAt']),
      offset: serializer.fromJson<String>(json['offset']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'eventId': serializer.toJson<String>(eventId),
      'fireAt': serializer.toJson<DateTime>(fireAt),
      'offset': serializer.toJson<String>(offset),
    };
  }

  ReminderRow copyWith({
    String? userId,
    String? eventId,
    DateTime? fireAt,
    String? offset,
  }) => ReminderRow(
    userId: userId ?? this.userId,
    eventId: eventId ?? this.eventId,
    fireAt: fireAt ?? this.fireAt,
    offset: offset ?? this.offset,
  );
  ReminderRow copyWithCompanion(RemindersCompanion data) {
    return ReminderRow(
      userId: data.userId.present ? data.userId.value : this.userId,
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      fireAt: data.fireAt.present ? data.fireAt.value : this.fireAt,
      offset: data.offset.present ? data.offset.value : this.offset,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReminderRow(')
          ..write('userId: $userId, ')
          ..write('eventId: $eventId, ')
          ..write('fireAt: $fireAt, ')
          ..write('offset: $offset')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(userId, eventId, fireAt, offset);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReminderRow &&
          other.userId == this.userId &&
          other.eventId == this.eventId &&
          other.fireAt == this.fireAt &&
          other.offset == this.offset);
}

class RemindersCompanion extends UpdateCompanion<ReminderRow> {
  final Value<String> userId;
  final Value<String> eventId;
  final Value<DateTime> fireAt;
  final Value<String> offset;
  final Value<int> rowid;
  const RemindersCompanion({
    this.userId = const Value.absent(),
    this.eventId = const Value.absent(),
    this.fireAt = const Value.absent(),
    this.offset = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RemindersCompanion.insert({
    required String userId,
    required String eventId,
    required DateTime fireAt,
    required String offset,
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       eventId = Value(eventId),
       fireAt = Value(fireAt),
       offset = Value(offset);
  static Insertable<ReminderRow> custom({
    Expression<String>? userId,
    Expression<String>? eventId,
    Expression<DateTime>? fireAt,
    Expression<String>? offset,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (eventId != null) 'event_id': eventId,
      if (fireAt != null) 'fire_at': fireAt,
      if (offset != null) 'offset': offset,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RemindersCompanion copyWith({
    Value<String>? userId,
    Value<String>? eventId,
    Value<DateTime>? fireAt,
    Value<String>? offset,
    Value<int>? rowid,
  }) {
    return RemindersCompanion(
      userId: userId ?? this.userId,
      eventId: eventId ?? this.eventId,
      fireAt: fireAt ?? this.fireAt,
      offset: offset ?? this.offset,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (eventId.present) {
      map['event_id'] = Variable<String>(eventId.value);
    }
    if (fireAt.present) {
      map['fire_at'] = Variable<DateTime>(fireAt.value);
    }
    if (offset.present) {
      map['offset'] = Variable<String>(offset.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemindersCompanion(')
          ..write('userId: $userId, ')
          ..write('eventId: $eventId, ')
          ..write('fireAt: $fireAt, ')
          ..write('offset: $offset, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReportsTable extends Reports with TableInfo<$ReportsTable, ReportRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReportsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetMeta = const VerificationMeta('target');
  @override
  late final GeneratedColumn<String> target = GeneratedColumn<String>(
    'target',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reporterIdMeta = const VerificationMeta(
    'reporterId',
  );
  @override
  late final GeneratedColumn<String> reporterId = GeneratedColumn<String>(
    'reporter_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventIdMeta = const VerificationMeta(
    'eventId',
  );
  @override
  late final GeneratedColumn<String> eventId = GeneratedColumn<String>(
    'event_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _organizerIdMeta = const VerificationMeta(
    'organizerId',
  );
  @override
  late final GeneratedColumn<String> organizerId = GeneratedColumn<String>(
    'organizer_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _commentMeta = const VerificationMeta(
    'comment',
  );
  @override
  late final GeneratedColumn<String> comment = GeneratedColumn<String>(
    'comment',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    target,
    reporterId,
    reason,
    status,
    createdAt,
    eventId,
    organizerId,
    comment,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reports';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReportRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('target')) {
      context.handle(
        _targetMeta,
        target.isAcceptableOrUnknown(data['target']!, _targetMeta),
      );
    } else if (isInserting) {
      context.missing(_targetMeta);
    }
    if (data.containsKey('reporter_id')) {
      context.handle(
        _reporterIdMeta,
        reporterId.isAcceptableOrUnknown(data['reporter_id']!, _reporterIdMeta),
      );
    } else if (isInserting) {
      context.missing(_reporterIdMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('event_id')) {
      context.handle(
        _eventIdMeta,
        eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta),
      );
    }
    if (data.containsKey('organizer_id')) {
      context.handle(
        _organizerIdMeta,
        organizerId.isAcceptableOrUnknown(
          data['organizer_id']!,
          _organizerIdMeta,
        ),
      );
    }
    if (data.containsKey('comment')) {
      context.handle(
        _commentMeta,
        comment.isAcceptableOrUnknown(data['comment']!, _commentMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReportRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReportRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      target: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target'],
      )!,
      reporterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reporter_id'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      eventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_id'],
      ),
      organizerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}organizer_id'],
      ),
      comment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}comment'],
      )!,
    );
  }

  @override
  $ReportsTable createAlias(String alias) {
    return $ReportsTable(attachedDatabase, alias);
  }
}

class ReportRow extends DataClass implements Insertable<ReportRow> {
  final String id;
  final String target;
  final String reporterId;
  final String reason;
  final String status;
  final DateTime createdAt;
  final String? eventId;
  final String? organizerId;
  final String comment;
  const ReportRow({
    required this.id,
    required this.target,
    required this.reporterId,
    required this.reason,
    required this.status,
    required this.createdAt,
    this.eventId,
    this.organizerId,
    required this.comment,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['target'] = Variable<String>(target);
    map['reporter_id'] = Variable<String>(reporterId);
    map['reason'] = Variable<String>(reason);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || eventId != null) {
      map['event_id'] = Variable<String>(eventId);
    }
    if (!nullToAbsent || organizerId != null) {
      map['organizer_id'] = Variable<String>(organizerId);
    }
    map['comment'] = Variable<String>(comment);
    return map;
  }

  ReportsCompanion toCompanion(bool nullToAbsent) {
    return ReportsCompanion(
      id: Value(id),
      target: Value(target),
      reporterId: Value(reporterId),
      reason: Value(reason),
      status: Value(status),
      createdAt: Value(createdAt),
      eventId: eventId == null && nullToAbsent
          ? const Value.absent()
          : Value(eventId),
      organizerId: organizerId == null && nullToAbsent
          ? const Value.absent()
          : Value(organizerId),
      comment: Value(comment),
    );
  }

  factory ReportRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReportRow(
      id: serializer.fromJson<String>(json['id']),
      target: serializer.fromJson<String>(json['target']),
      reporterId: serializer.fromJson<String>(json['reporterId']),
      reason: serializer.fromJson<String>(json['reason']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      eventId: serializer.fromJson<String?>(json['eventId']),
      organizerId: serializer.fromJson<String?>(json['organizerId']),
      comment: serializer.fromJson<String>(json['comment']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'target': serializer.toJson<String>(target),
      'reporterId': serializer.toJson<String>(reporterId),
      'reason': serializer.toJson<String>(reason),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'eventId': serializer.toJson<String?>(eventId),
      'organizerId': serializer.toJson<String?>(organizerId),
      'comment': serializer.toJson<String>(comment),
    };
  }

  ReportRow copyWith({
    String? id,
    String? target,
    String? reporterId,
    String? reason,
    String? status,
    DateTime? createdAt,
    Value<String?> eventId = const Value.absent(),
    Value<String?> organizerId = const Value.absent(),
    String? comment,
  }) => ReportRow(
    id: id ?? this.id,
    target: target ?? this.target,
    reporterId: reporterId ?? this.reporterId,
    reason: reason ?? this.reason,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    eventId: eventId.present ? eventId.value : this.eventId,
    organizerId: organizerId.present ? organizerId.value : this.organizerId,
    comment: comment ?? this.comment,
  );
  ReportRow copyWithCompanion(ReportsCompanion data) {
    return ReportRow(
      id: data.id.present ? data.id.value : this.id,
      target: data.target.present ? data.target.value : this.target,
      reporterId: data.reporterId.present
          ? data.reporterId.value
          : this.reporterId,
      reason: data.reason.present ? data.reason.value : this.reason,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      organizerId: data.organizerId.present
          ? data.organizerId.value
          : this.organizerId,
      comment: data.comment.present ? data.comment.value : this.comment,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReportRow(')
          ..write('id: $id, ')
          ..write('target: $target, ')
          ..write('reporterId: $reporterId, ')
          ..write('reason: $reason, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('eventId: $eventId, ')
          ..write('organizerId: $organizerId, ')
          ..write('comment: $comment')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    target,
    reporterId,
    reason,
    status,
    createdAt,
    eventId,
    organizerId,
    comment,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReportRow &&
          other.id == this.id &&
          other.target == this.target &&
          other.reporterId == this.reporterId &&
          other.reason == this.reason &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.eventId == this.eventId &&
          other.organizerId == this.organizerId &&
          other.comment == this.comment);
}

class ReportsCompanion extends UpdateCompanion<ReportRow> {
  final Value<String> id;
  final Value<String> target;
  final Value<String> reporterId;
  final Value<String> reason;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<String?> eventId;
  final Value<String?> organizerId;
  final Value<String> comment;
  final Value<int> rowid;
  const ReportsCompanion({
    this.id = const Value.absent(),
    this.target = const Value.absent(),
    this.reporterId = const Value.absent(),
    this.reason = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.eventId = const Value.absent(),
    this.organizerId = const Value.absent(),
    this.comment = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReportsCompanion.insert({
    required String id,
    required String target,
    required String reporterId,
    required String reason,
    required String status,
    required DateTime createdAt,
    this.eventId = const Value.absent(),
    this.organizerId = const Value.absent(),
    this.comment = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       target = Value(target),
       reporterId = Value(reporterId),
       reason = Value(reason),
       status = Value(status),
       createdAt = Value(createdAt);
  static Insertable<ReportRow> custom({
    Expression<String>? id,
    Expression<String>? target,
    Expression<String>? reporterId,
    Expression<String>? reason,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<String>? eventId,
    Expression<String>? organizerId,
    Expression<String>? comment,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (target != null) 'target': target,
      if (reporterId != null) 'reporter_id': reporterId,
      if (reason != null) 'reason': reason,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (eventId != null) 'event_id': eventId,
      if (organizerId != null) 'organizer_id': organizerId,
      if (comment != null) 'comment': comment,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReportsCompanion copyWith({
    Value<String>? id,
    Value<String>? target,
    Value<String>? reporterId,
    Value<String>? reason,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<String?>? eventId,
    Value<String?>? organizerId,
    Value<String>? comment,
    Value<int>? rowid,
  }) {
    return ReportsCompanion(
      id: id ?? this.id,
      target: target ?? this.target,
      reporterId: reporterId ?? this.reporterId,
      reason: reason ?? this.reason,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      eventId: eventId ?? this.eventId,
      organizerId: organizerId ?? this.organizerId,
      comment: comment ?? this.comment,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (target.present) {
      map['target'] = Variable<String>(target.value);
    }
    if (reporterId.present) {
      map['reporter_id'] = Variable<String>(reporterId.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (eventId.present) {
      map['event_id'] = Variable<String>(eventId.value);
    }
    if (organizerId.present) {
      map['organizer_id'] = Variable<String>(organizerId.value);
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReportsCompanion(')
          ..write('id: $id, ')
          ..write('target: $target, ')
          ..write('reporterId: $reporterId, ')
          ..write('reason: $reason, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('eventId: $eventId, ')
          ..write('organizerId: $organizerId, ')
          ..write('comment: $comment, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EventViewsTable extends EventViews
    with TableInfo<$EventViewsTable, EventViewRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventViewsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _eventIdMeta = const VerificationMeta(
    'eventId',
  );
  @override
  late final GeneratedColumn<String> eventId = GeneratedColumn<String>(
    'event_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _viewedAtMeta = const VerificationMeta(
    'viewedAt',
  );
  @override
  late final GeneratedColumn<DateTime> viewedAt = GeneratedColumn<DateTime>(
    'viewed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, eventId, userId, viewedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'event_views';
  @override
  VerificationContext validateIntegrity(
    Insertable<EventViewRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('event_id')) {
      context.handle(
        _eventIdMeta,
        eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta),
      );
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('viewed_at')) {
      context.handle(
        _viewedAtMeta,
        viewedAt.isAcceptableOrUnknown(data['viewed_at']!, _viewedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_viewedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EventViewRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EventViewRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      eventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      viewedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}viewed_at'],
      )!,
    );
  }

  @override
  $EventViewsTable createAlias(String alias) {
    return $EventViewsTable(attachedDatabase, alias);
  }
}

class EventViewRow extends DataClass implements Insertable<EventViewRow> {
  final int id;
  final String eventId;
  final String userId;
  final DateTime viewedAt;
  const EventViewRow({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.viewedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['event_id'] = Variable<String>(eventId);
    map['user_id'] = Variable<String>(userId);
    map['viewed_at'] = Variable<DateTime>(viewedAt);
    return map;
  }

  EventViewsCompanion toCompanion(bool nullToAbsent) {
    return EventViewsCompanion(
      id: Value(id),
      eventId: Value(eventId),
      userId: Value(userId),
      viewedAt: Value(viewedAt),
    );
  }

  factory EventViewRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EventViewRow(
      id: serializer.fromJson<int>(json['id']),
      eventId: serializer.fromJson<String>(json['eventId']),
      userId: serializer.fromJson<String>(json['userId']),
      viewedAt: serializer.fromJson<DateTime>(json['viewedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'eventId': serializer.toJson<String>(eventId),
      'userId': serializer.toJson<String>(userId),
      'viewedAt': serializer.toJson<DateTime>(viewedAt),
    };
  }

  EventViewRow copyWith({
    int? id,
    String? eventId,
    String? userId,
    DateTime? viewedAt,
  }) => EventViewRow(
    id: id ?? this.id,
    eventId: eventId ?? this.eventId,
    userId: userId ?? this.userId,
    viewedAt: viewedAt ?? this.viewedAt,
  );
  EventViewRow copyWithCompanion(EventViewsCompanion data) {
    return EventViewRow(
      id: data.id.present ? data.id.value : this.id,
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      userId: data.userId.present ? data.userId.value : this.userId,
      viewedAt: data.viewedAt.present ? data.viewedAt.value : this.viewedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EventViewRow(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('userId: $userId, ')
          ..write('viewedAt: $viewedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, eventId, userId, viewedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EventViewRow &&
          other.id == this.id &&
          other.eventId == this.eventId &&
          other.userId == this.userId &&
          other.viewedAt == this.viewedAt);
}

class EventViewsCompanion extends UpdateCompanion<EventViewRow> {
  final Value<int> id;
  final Value<String> eventId;
  final Value<String> userId;
  final Value<DateTime> viewedAt;
  const EventViewsCompanion({
    this.id = const Value.absent(),
    this.eventId = const Value.absent(),
    this.userId = const Value.absent(),
    this.viewedAt = const Value.absent(),
  });
  EventViewsCompanion.insert({
    this.id = const Value.absent(),
    required String eventId,
    required String userId,
    required DateTime viewedAt,
  }) : eventId = Value(eventId),
       userId = Value(userId),
       viewedAt = Value(viewedAt);
  static Insertable<EventViewRow> custom({
    Expression<int>? id,
    Expression<String>? eventId,
    Expression<String>? userId,
    Expression<DateTime>? viewedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eventId != null) 'event_id': eventId,
      if (userId != null) 'user_id': userId,
      if (viewedAt != null) 'viewed_at': viewedAt,
    });
  }

  EventViewsCompanion copyWith({
    Value<int>? id,
    Value<String>? eventId,
    Value<String>? userId,
    Value<DateTime>? viewedAt,
  }) {
    return EventViewsCompanion(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      userId: userId ?? this.userId,
      viewedAt: viewedAt ?? this.viewedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (eventId.present) {
      map['event_id'] = Variable<String>(eventId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (viewedAt.present) {
      map['viewed_at'] = Variable<DateTime>(viewedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventViewsCompanion(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('userId: $userId, ')
          ..write('viewedAt: $viewedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $OrganizationsTable organizations = $OrganizationsTable(this);
  late final $OrganizationMembersTable organizationMembers =
      $OrganizationMembersTable(this);
  late final $InviteKeysTable inviteKeys = $InviteKeysTable(this);
  late final $EventsTable events = $EventsTable(this);
  late final $EventMediaTable eventMedia = $EventMediaTable(this);
  late final $EventCustomFieldsTable eventCustomFields =
      $EventCustomFieldsTable(this);
  late final $RegistrationsTable registrations = $RegistrationsTable(this);
  late final $FavoritesTable favorites = $FavoritesTable(this);
  late final $RemindersTable reminders = $RemindersTable(this);
  late final $ReportsTable reports = $ReportsTable(this);
  late final $EventViewsTable eventViews = $EventViewsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    users,
    organizations,
    organizationMembers,
    inviteKeys,
    events,
    eventMedia,
    eventCustomFields,
    registrations,
    favorites,
    reminders,
    reports,
    eventViews,
  ];
}

typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      required String id,
      required String name,
      required String email,
      required String role,
      Value<String> phone,
      Value<String> passwordHash,
      Value<bool> banned,
      Value<int> rowid,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> email,
      Value<String> role,
      Value<String> phone,
      Value<String> passwordHash,
      Value<bool> banned,
      Value<int> rowid,
    });

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get banned => $composableBuilder(
    column: $table.banned,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get banned => $composableBuilder(
    column: $table.banned,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get banned =>
      $composableBuilder(column: $table.banned, builder: (column) => column);
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          UserRow,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (UserRow, BaseReferences<_$AppDatabase, $UsersTable, UserRow>),
          UserRow,
          PrefetchHooks Function()
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> passwordHash = const Value.absent(),
                Value<bool> banned = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                name: name,
                email: email,
                role: role,
                phone: phone,
                passwordHash: passwordHash,
                banned: banned,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String email,
                required String role,
                Value<String> phone = const Value.absent(),
                Value<String> passwordHash = const Value.absent(),
                Value<bool> banned = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                name: name,
                email: email,
                role: role,
                phone: phone,
                passwordHash: passwordHash,
                banned: banned,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      UserRow,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (UserRow, BaseReferences<_$AppDatabase, $UsersTable, UserRow>),
      UserRow,
      PrefetchHooks Function()
    >;
typedef $$OrganizationsTableCreateCompanionBuilder =
    OrganizationsCompanion Function({
      required String id,
      required String name,
      required String type,
      required String city,
      required String ownerId,
      Value<String> phone,
      Value<String> email,
      Value<String?> logoPath,
      Value<bool> blocked,
      Value<String?> createdAtByKey,
      Value<int> rowid,
    });
typedef $$OrganizationsTableUpdateCompanionBuilder =
    OrganizationsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> type,
      Value<String> city,
      Value<String> ownerId,
      Value<String> phone,
      Value<String> email,
      Value<String?> logoPath,
      Value<bool> blocked,
      Value<String?> createdAtByKey,
      Value<int> rowid,
    });

class $$OrganizationsTableFilterComposer
    extends Composer<_$AppDatabase, $OrganizationsTable> {
  $$OrganizationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get logoPath => $composableBuilder(
    column: $table.logoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get blocked => $composableBuilder(
    column: $table.blocked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAtByKey => $composableBuilder(
    column: $table.createdAtByKey,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OrganizationsTableOrderingComposer
    extends Composer<_$AppDatabase, $OrganizationsTable> {
  $$OrganizationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get logoPath => $composableBuilder(
    column: $table.logoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get blocked => $composableBuilder(
    column: $table.blocked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAtByKey => $composableBuilder(
    column: $table.createdAtByKey,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OrganizationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrganizationsTable> {
  $$OrganizationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get logoPath =>
      $composableBuilder(column: $table.logoPath, builder: (column) => column);

  GeneratedColumn<bool> get blocked =>
      $composableBuilder(column: $table.blocked, builder: (column) => column);

  GeneratedColumn<String> get createdAtByKey => $composableBuilder(
    column: $table.createdAtByKey,
    builder: (column) => column,
  );
}

class $$OrganizationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrganizationsTable,
          OrganizationRow,
          $$OrganizationsTableFilterComposer,
          $$OrganizationsTableOrderingComposer,
          $$OrganizationsTableAnnotationComposer,
          $$OrganizationsTableCreateCompanionBuilder,
          $$OrganizationsTableUpdateCompanionBuilder,
          (
            OrganizationRow,
            BaseReferences<_$AppDatabase, $OrganizationsTable, OrganizationRow>,
          ),
          OrganizationRow,
          PrefetchHooks Function()
        > {
  $$OrganizationsTableTableManager(_$AppDatabase db, $OrganizationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrganizationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrganizationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrganizationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> city = const Value.absent(),
                Value<String> ownerId = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String?> logoPath = const Value.absent(),
                Value<bool> blocked = const Value.absent(),
                Value<String?> createdAtByKey = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrganizationsCompanion(
                id: id,
                name: name,
                type: type,
                city: city,
                ownerId: ownerId,
                phone: phone,
                email: email,
                logoPath: logoPath,
                blocked: blocked,
                createdAtByKey: createdAtByKey,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String type,
                required String city,
                required String ownerId,
                Value<String> phone = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String?> logoPath = const Value.absent(),
                Value<bool> blocked = const Value.absent(),
                Value<String?> createdAtByKey = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrganizationsCompanion.insert(
                id: id,
                name: name,
                type: type,
                city: city,
                ownerId: ownerId,
                phone: phone,
                email: email,
                logoPath: logoPath,
                blocked: blocked,
                createdAtByKey: createdAtByKey,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OrganizationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrganizationsTable,
      OrganizationRow,
      $$OrganizationsTableFilterComposer,
      $$OrganizationsTableOrderingComposer,
      $$OrganizationsTableAnnotationComposer,
      $$OrganizationsTableCreateCompanionBuilder,
      $$OrganizationsTableUpdateCompanionBuilder,
      (
        OrganizationRow,
        BaseReferences<_$AppDatabase, $OrganizationsTable, OrganizationRow>,
      ),
      OrganizationRow,
      PrefetchHooks Function()
    >;
typedef $$OrganizationMembersTableCreateCompanionBuilder =
    OrganizationMembersCompanion Function({
      required String orgId,
      required String userId,
      required String role,
      required String status,
      required DateTime requestedAt,
      Value<int> rowid,
    });
typedef $$OrganizationMembersTableUpdateCompanionBuilder =
    OrganizationMembersCompanion Function({
      Value<String> orgId,
      Value<String> userId,
      Value<String> role,
      Value<String> status,
      Value<DateTime> requestedAt,
      Value<int> rowid,
    });

class $$OrganizationMembersTableFilterComposer
    extends Composer<_$AppDatabase, $OrganizationMembersTable> {
  $$OrganizationMembersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get orgId => $composableBuilder(
    column: $table.orgId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get requestedAt => $composableBuilder(
    column: $table.requestedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OrganizationMembersTableOrderingComposer
    extends Composer<_$AppDatabase, $OrganizationMembersTable> {
  $$OrganizationMembersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get orgId => $composableBuilder(
    column: $table.orgId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get requestedAt => $composableBuilder(
    column: $table.requestedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OrganizationMembersTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrganizationMembersTable> {
  $$OrganizationMembersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get orgId =>
      $composableBuilder(column: $table.orgId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get requestedAt => $composableBuilder(
    column: $table.requestedAt,
    builder: (column) => column,
  );
}

class $$OrganizationMembersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrganizationMembersTable,
          OrgMemberRow,
          $$OrganizationMembersTableFilterComposer,
          $$OrganizationMembersTableOrderingComposer,
          $$OrganizationMembersTableAnnotationComposer,
          $$OrganizationMembersTableCreateCompanionBuilder,
          $$OrganizationMembersTableUpdateCompanionBuilder,
          (
            OrgMemberRow,
            BaseReferences<
              _$AppDatabase,
              $OrganizationMembersTable,
              OrgMemberRow
            >,
          ),
          OrgMemberRow,
          PrefetchHooks Function()
        > {
  $$OrganizationMembersTableTableManager(
    _$AppDatabase db,
    $OrganizationMembersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrganizationMembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrganizationMembersTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$OrganizationMembersTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> orgId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> requestedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrganizationMembersCompanion(
                orgId: orgId,
                userId: userId,
                role: role,
                status: status,
                requestedAt: requestedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String orgId,
                required String userId,
                required String role,
                required String status,
                required DateTime requestedAt,
                Value<int> rowid = const Value.absent(),
              }) => OrganizationMembersCompanion.insert(
                orgId: orgId,
                userId: userId,
                role: role,
                status: status,
                requestedAt: requestedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OrganizationMembersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrganizationMembersTable,
      OrgMemberRow,
      $$OrganizationMembersTableFilterComposer,
      $$OrganizationMembersTableOrderingComposer,
      $$OrganizationMembersTableAnnotationComposer,
      $$OrganizationMembersTableCreateCompanionBuilder,
      $$OrganizationMembersTableUpdateCompanionBuilder,
      (
        OrgMemberRow,
        BaseReferences<_$AppDatabase, $OrganizationMembersTable, OrgMemberRow>,
      ),
      OrgMemberRow,
      PrefetchHooks Function()
    >;
typedef $$InviteKeysTableCreateCompanionBuilder =
    InviteKeysCompanion Function({
      required String id,
      required String keyHash,
      Value<bool> used,
      Value<int> attempts,
      Value<String?> orgId,
      Value<DateTime?> createdAt,
      Value<int> rowid,
    });
typedef $$InviteKeysTableUpdateCompanionBuilder =
    InviteKeysCompanion Function({
      Value<String> id,
      Value<String> keyHash,
      Value<bool> used,
      Value<int> attempts,
      Value<String?> orgId,
      Value<DateTime?> createdAt,
      Value<int> rowid,
    });

class $$InviteKeysTableFilterComposer
    extends Composer<_$AppDatabase, $InviteKeysTable> {
  $$InviteKeysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get keyHash => $composableBuilder(
    column: $table.keyHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get used => $composableBuilder(
    column: $table.used,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get orgId => $composableBuilder(
    column: $table.orgId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InviteKeysTableOrderingComposer
    extends Composer<_$AppDatabase, $InviteKeysTable> {
  $$InviteKeysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get keyHash => $composableBuilder(
    column: $table.keyHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get used => $composableBuilder(
    column: $table.used,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get orgId => $composableBuilder(
    column: $table.orgId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InviteKeysTableAnnotationComposer
    extends Composer<_$AppDatabase, $InviteKeysTable> {
  $$InviteKeysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get keyHash =>
      $composableBuilder(column: $table.keyHash, builder: (column) => column);

  GeneratedColumn<bool> get used =>
      $composableBuilder(column: $table.used, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<String> get orgId =>
      $composableBuilder(column: $table.orgId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$InviteKeysTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InviteKeysTable,
          InviteKeyRow,
          $$InviteKeysTableFilterComposer,
          $$InviteKeysTableOrderingComposer,
          $$InviteKeysTableAnnotationComposer,
          $$InviteKeysTableCreateCompanionBuilder,
          $$InviteKeysTableUpdateCompanionBuilder,
          (
            InviteKeyRow,
            BaseReferences<_$AppDatabase, $InviteKeysTable, InviteKeyRow>,
          ),
          InviteKeyRow,
          PrefetchHooks Function()
        > {
  $$InviteKeysTableTableManager(_$AppDatabase db, $InviteKeysTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InviteKeysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InviteKeysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InviteKeysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> keyHash = const Value.absent(),
                Value<bool> used = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<String?> orgId = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InviteKeysCompanion(
                id: id,
                keyHash: keyHash,
                used: used,
                attempts: attempts,
                orgId: orgId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String keyHash,
                Value<bool> used = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<String?> orgId = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InviteKeysCompanion.insert(
                id: id,
                keyHash: keyHash,
                used: used,
                attempts: attempts,
                orgId: orgId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InviteKeysTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InviteKeysTable,
      InviteKeyRow,
      $$InviteKeysTableFilterComposer,
      $$InviteKeysTableOrderingComposer,
      $$InviteKeysTableAnnotationComposer,
      $$InviteKeysTableCreateCompanionBuilder,
      $$InviteKeysTableUpdateCompanionBuilder,
      (
        InviteKeyRow,
        BaseReferences<_$AppDatabase, $InviteKeysTable, InviteKeyRow>,
      ),
      InviteKeyRow,
      PrefetchHooks Function()
    >;
typedef $$EventsTableCreateCompanionBuilder =
    EventsCompanion Function({
      required String id,
      required String orgId,
      required String title,
      Value<String> description,
      required String category,
      required DateTime startAt,
      required String place,
      Value<int> capacity,
      required String status,
      Value<String> moderationNote,
      Value<DateTime?> cancelledAt,
      Value<int> rowid,
    });
typedef $$EventsTableUpdateCompanionBuilder =
    EventsCompanion Function({
      Value<String> id,
      Value<String> orgId,
      Value<String> title,
      Value<String> description,
      Value<String> category,
      Value<DateTime> startAt,
      Value<String> place,
      Value<int> capacity,
      Value<String> status,
      Value<String> moderationNote,
      Value<DateTime?> cancelledAt,
      Value<int> rowid,
    });

class $$EventsTableFilterComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get orgId => $composableBuilder(
    column: $table.orgId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startAt => $composableBuilder(
    column: $table.startAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get place => $composableBuilder(
    column: $table.place,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get capacity => $composableBuilder(
    column: $table.capacity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get moderationNote => $composableBuilder(
    column: $table.moderationNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cancelledAt => $composableBuilder(
    column: $table.cancelledAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EventsTableOrderingComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get orgId => $composableBuilder(
    column: $table.orgId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startAt => $composableBuilder(
    column: $table.startAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get place => $composableBuilder(
    column: $table.place,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get capacity => $composableBuilder(
    column: $table.capacity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get moderationNote => $composableBuilder(
    column: $table.moderationNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cancelledAt => $composableBuilder(
    column: $table.cancelledAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get orgId =>
      $composableBuilder(column: $table.orgId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<DateTime> get startAt =>
      $composableBuilder(column: $table.startAt, builder: (column) => column);

  GeneratedColumn<String> get place =>
      $composableBuilder(column: $table.place, builder: (column) => column);

  GeneratedColumn<int> get capacity =>
      $composableBuilder(column: $table.capacity, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get moderationNote => $composableBuilder(
    column: $table.moderationNote,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get cancelledAt => $composableBuilder(
    column: $table.cancelledAt,
    builder: (column) => column,
  );
}

class $$EventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EventsTable,
          EventRow,
          $$EventsTableFilterComposer,
          $$EventsTableOrderingComposer,
          $$EventsTableAnnotationComposer,
          $$EventsTableCreateCompanionBuilder,
          $$EventsTableUpdateCompanionBuilder,
          (EventRow, BaseReferences<_$AppDatabase, $EventsTable, EventRow>),
          EventRow,
          PrefetchHooks Function()
        > {
  $$EventsTableTableManager(_$AppDatabase db, $EventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> orgId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<DateTime> startAt = const Value.absent(),
                Value<String> place = const Value.absent(),
                Value<int> capacity = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> moderationNote = const Value.absent(),
                Value<DateTime?> cancelledAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EventsCompanion(
                id: id,
                orgId: orgId,
                title: title,
                description: description,
                category: category,
                startAt: startAt,
                place: place,
                capacity: capacity,
                status: status,
                moderationNote: moderationNote,
                cancelledAt: cancelledAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String orgId,
                required String title,
                Value<String> description = const Value.absent(),
                required String category,
                required DateTime startAt,
                required String place,
                Value<int> capacity = const Value.absent(),
                required String status,
                Value<String> moderationNote = const Value.absent(),
                Value<DateTime?> cancelledAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EventsCompanion.insert(
                id: id,
                orgId: orgId,
                title: title,
                description: description,
                category: category,
                startAt: startAt,
                place: place,
                capacity: capacity,
                status: status,
                moderationNote: moderationNote,
                cancelledAt: cancelledAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EventsTable,
      EventRow,
      $$EventsTableFilterComposer,
      $$EventsTableOrderingComposer,
      $$EventsTableAnnotationComposer,
      $$EventsTableCreateCompanionBuilder,
      $$EventsTableUpdateCompanionBuilder,
      (EventRow, BaseReferences<_$AppDatabase, $EventsTable, EventRow>),
      EventRow,
      PrefetchHooks Function()
    >;
typedef $$EventMediaTableCreateCompanionBuilder =
    EventMediaCompanion Function({
      required String id,
      required String eventId,
      required String kind,
      required String path,
      Value<String?> previewPath,
      Value<int> position,
      Value<int> durationMs,
      Value<int> bytes,
      Value<int> rowid,
    });
typedef $$EventMediaTableUpdateCompanionBuilder =
    EventMediaCompanion Function({
      Value<String> id,
      Value<String> eventId,
      Value<String> kind,
      Value<String> path,
      Value<String?> previewPath,
      Value<int> position,
      Value<int> durationMs,
      Value<int> bytes,
      Value<int> rowid,
    });

class $$EventMediaTableFilterComposer
    extends Composer<_$AppDatabase, $EventMediaTable> {
  $$EventMediaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventId => $composableBuilder(
    column: $table.eventId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get previewPath => $composableBuilder(
    column: $table.previewPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bytes => $composableBuilder(
    column: $table.bytes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EventMediaTableOrderingComposer
    extends Composer<_$AppDatabase, $EventMediaTable> {
  $$EventMediaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventId => $composableBuilder(
    column: $table.eventId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get previewPath => $composableBuilder(
    column: $table.previewPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bytes => $composableBuilder(
    column: $table.bytes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EventMediaTableAnnotationComposer
    extends Composer<_$AppDatabase, $EventMediaTable> {
  $$EventMediaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get eventId =>
      $composableBuilder(column: $table.eventId, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<String> get previewPath => $composableBuilder(
    column: $table.previewPath,
    builder: (column) => column,
  );

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bytes =>
      $composableBuilder(column: $table.bytes, builder: (column) => column);
}

class $$EventMediaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EventMediaTable,
          EventMediaRow,
          $$EventMediaTableFilterComposer,
          $$EventMediaTableOrderingComposer,
          $$EventMediaTableAnnotationComposer,
          $$EventMediaTableCreateCompanionBuilder,
          $$EventMediaTableUpdateCompanionBuilder,
          (
            EventMediaRow,
            BaseReferences<_$AppDatabase, $EventMediaTable, EventMediaRow>,
          ),
          EventMediaRow,
          PrefetchHooks Function()
        > {
  $$EventMediaTableTableManager(_$AppDatabase db, $EventMediaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EventMediaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EventMediaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EventMediaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> eventId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> path = const Value.absent(),
                Value<String?> previewPath = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<int> durationMs = const Value.absent(),
                Value<int> bytes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EventMediaCompanion(
                id: id,
                eventId: eventId,
                kind: kind,
                path: path,
                previewPath: previewPath,
                position: position,
                durationMs: durationMs,
                bytes: bytes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String eventId,
                required String kind,
                required String path,
                Value<String?> previewPath = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<int> durationMs = const Value.absent(),
                Value<int> bytes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EventMediaCompanion.insert(
                id: id,
                eventId: eventId,
                kind: kind,
                path: path,
                previewPath: previewPath,
                position: position,
                durationMs: durationMs,
                bytes: bytes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EventMediaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EventMediaTable,
      EventMediaRow,
      $$EventMediaTableFilterComposer,
      $$EventMediaTableOrderingComposer,
      $$EventMediaTableAnnotationComposer,
      $$EventMediaTableCreateCompanionBuilder,
      $$EventMediaTableUpdateCompanionBuilder,
      (
        EventMediaRow,
        BaseReferences<_$AppDatabase, $EventMediaTable, EventMediaRow>,
      ),
      EventMediaRow,
      PrefetchHooks Function()
    >;
typedef $$EventCustomFieldsTableCreateCompanionBuilder =
    EventCustomFieldsCompanion Function({
      required String id,
      required String eventId,
      required String label,
      required String type,
      Value<String> value,
      Value<String> options,
      Value<int> position,
      Value<int> rowid,
    });
typedef $$EventCustomFieldsTableUpdateCompanionBuilder =
    EventCustomFieldsCompanion Function({
      Value<String> id,
      Value<String> eventId,
      Value<String> label,
      Value<String> type,
      Value<String> value,
      Value<String> options,
      Value<int> position,
      Value<int> rowid,
    });

class $$EventCustomFieldsTableFilterComposer
    extends Composer<_$AppDatabase, $EventCustomFieldsTable> {
  $$EventCustomFieldsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventId => $composableBuilder(
    column: $table.eventId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get options => $composableBuilder(
    column: $table.options,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EventCustomFieldsTableOrderingComposer
    extends Composer<_$AppDatabase, $EventCustomFieldsTable> {
  $$EventCustomFieldsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventId => $composableBuilder(
    column: $table.eventId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get options => $composableBuilder(
    column: $table.options,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EventCustomFieldsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EventCustomFieldsTable> {
  $$EventCustomFieldsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get eventId =>
      $composableBuilder(column: $table.eventId, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get options =>
      $composableBuilder(column: $table.options, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);
}

class $$EventCustomFieldsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EventCustomFieldsTable,
          CustomFieldRow,
          $$EventCustomFieldsTableFilterComposer,
          $$EventCustomFieldsTableOrderingComposer,
          $$EventCustomFieldsTableAnnotationComposer,
          $$EventCustomFieldsTableCreateCompanionBuilder,
          $$EventCustomFieldsTableUpdateCompanionBuilder,
          (
            CustomFieldRow,
            BaseReferences<
              _$AppDatabase,
              $EventCustomFieldsTable,
              CustomFieldRow
            >,
          ),
          CustomFieldRow,
          PrefetchHooks Function()
        > {
  $$EventCustomFieldsTableTableManager(
    _$AppDatabase db,
    $EventCustomFieldsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EventCustomFieldsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EventCustomFieldsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EventCustomFieldsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> eventId = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<String> options = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EventCustomFieldsCompanion(
                id: id,
                eventId: eventId,
                label: label,
                type: type,
                value: value,
                options: options,
                position: position,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String eventId,
                required String label,
                required String type,
                Value<String> value = const Value.absent(),
                Value<String> options = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EventCustomFieldsCompanion.insert(
                id: id,
                eventId: eventId,
                label: label,
                type: type,
                value: value,
                options: options,
                position: position,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EventCustomFieldsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EventCustomFieldsTable,
      CustomFieldRow,
      $$EventCustomFieldsTableFilterComposer,
      $$EventCustomFieldsTableOrderingComposer,
      $$EventCustomFieldsTableAnnotationComposer,
      $$EventCustomFieldsTableCreateCompanionBuilder,
      $$EventCustomFieldsTableUpdateCompanionBuilder,
      (
        CustomFieldRow,
        BaseReferences<_$AppDatabase, $EventCustomFieldsTable, CustomFieldRow>,
      ),
      CustomFieldRow,
      PrefetchHooks Function()
    >;
typedef $$RegistrationsTableCreateCompanionBuilder =
    RegistrationsCompanion Function({
      required String id,
      required String eventId,
      required String userId,
      required DateTime createdAt,
      Value<DateTime?> checkedInAt,
      Value<int> rowid,
    });
typedef $$RegistrationsTableUpdateCompanionBuilder =
    RegistrationsCompanion Function({
      Value<String> id,
      Value<String> eventId,
      Value<String> userId,
      Value<DateTime> createdAt,
      Value<DateTime?> checkedInAt,
      Value<int> rowid,
    });

class $$RegistrationsTableFilterComposer
    extends Composer<_$AppDatabase, $RegistrationsTable> {
  $$RegistrationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventId => $composableBuilder(
    column: $table.eventId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get checkedInAt => $composableBuilder(
    column: $table.checkedInAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RegistrationsTableOrderingComposer
    extends Composer<_$AppDatabase, $RegistrationsTable> {
  $$RegistrationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventId => $composableBuilder(
    column: $table.eventId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get checkedInAt => $composableBuilder(
    column: $table.checkedInAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RegistrationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RegistrationsTable> {
  $$RegistrationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get eventId =>
      $composableBuilder(column: $table.eventId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get checkedInAt => $composableBuilder(
    column: $table.checkedInAt,
    builder: (column) => column,
  );
}

class $$RegistrationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RegistrationsTable,
          RegistrationRow,
          $$RegistrationsTableFilterComposer,
          $$RegistrationsTableOrderingComposer,
          $$RegistrationsTableAnnotationComposer,
          $$RegistrationsTableCreateCompanionBuilder,
          $$RegistrationsTableUpdateCompanionBuilder,
          (
            RegistrationRow,
            BaseReferences<_$AppDatabase, $RegistrationsTable, RegistrationRow>,
          ),
          RegistrationRow,
          PrefetchHooks Function()
        > {
  $$RegistrationsTableTableManager(_$AppDatabase db, $RegistrationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RegistrationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RegistrationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RegistrationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> eventId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> checkedInAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RegistrationsCompanion(
                id: id,
                eventId: eventId,
                userId: userId,
                createdAt: createdAt,
                checkedInAt: checkedInAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String eventId,
                required String userId,
                required DateTime createdAt,
                Value<DateTime?> checkedInAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RegistrationsCompanion.insert(
                id: id,
                eventId: eventId,
                userId: userId,
                createdAt: createdAt,
                checkedInAt: checkedInAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RegistrationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RegistrationsTable,
      RegistrationRow,
      $$RegistrationsTableFilterComposer,
      $$RegistrationsTableOrderingComposer,
      $$RegistrationsTableAnnotationComposer,
      $$RegistrationsTableCreateCompanionBuilder,
      $$RegistrationsTableUpdateCompanionBuilder,
      (
        RegistrationRow,
        BaseReferences<_$AppDatabase, $RegistrationsTable, RegistrationRow>,
      ),
      RegistrationRow,
      PrefetchHooks Function()
    >;
typedef $$FavoritesTableCreateCompanionBuilder =
    FavoritesCompanion Function({
      required String userId,
      required String eventId,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$FavoritesTableUpdateCompanionBuilder =
    FavoritesCompanion Function({
      Value<String> userId,
      Value<String> eventId,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$FavoritesTableFilterComposer
    extends Composer<_$AppDatabase, $FavoritesTable> {
  $$FavoritesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventId => $composableBuilder(
    column: $table.eventId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FavoritesTableOrderingComposer
    extends Composer<_$AppDatabase, $FavoritesTable> {
  $$FavoritesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventId => $composableBuilder(
    column: $table.eventId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FavoritesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FavoritesTable> {
  $$FavoritesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get eventId =>
      $composableBuilder(column: $table.eventId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$FavoritesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FavoritesTable,
          FavoriteRow,
          $$FavoritesTableFilterComposer,
          $$FavoritesTableOrderingComposer,
          $$FavoritesTableAnnotationComposer,
          $$FavoritesTableCreateCompanionBuilder,
          $$FavoritesTableUpdateCompanionBuilder,
          (
            FavoriteRow,
            BaseReferences<_$AppDatabase, $FavoritesTable, FavoriteRow>,
          ),
          FavoriteRow,
          PrefetchHooks Function()
        > {
  $$FavoritesTableTableManager(_$AppDatabase db, $FavoritesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FavoritesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FavoritesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FavoritesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<String> eventId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FavoritesCompanion(
                userId: userId,
                eventId: eventId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                required String eventId,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => FavoritesCompanion.insert(
                userId: userId,
                eventId: eventId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FavoritesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FavoritesTable,
      FavoriteRow,
      $$FavoritesTableFilterComposer,
      $$FavoritesTableOrderingComposer,
      $$FavoritesTableAnnotationComposer,
      $$FavoritesTableCreateCompanionBuilder,
      $$FavoritesTableUpdateCompanionBuilder,
      (
        FavoriteRow,
        BaseReferences<_$AppDatabase, $FavoritesTable, FavoriteRow>,
      ),
      FavoriteRow,
      PrefetchHooks Function()
    >;
typedef $$RemindersTableCreateCompanionBuilder =
    RemindersCompanion Function({
      required String userId,
      required String eventId,
      required DateTime fireAt,
      required String offset,
      Value<int> rowid,
    });
typedef $$RemindersTableUpdateCompanionBuilder =
    RemindersCompanion Function({
      Value<String> userId,
      Value<String> eventId,
      Value<DateTime> fireAt,
      Value<String> offset,
      Value<int> rowid,
    });

class $$RemindersTableFilterComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventId => $composableBuilder(
    column: $table.eventId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fireAt => $composableBuilder(
    column: $table.fireAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get offset => $composableBuilder(
    column: $table.offset,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventId => $composableBuilder(
    column: $table.eventId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fireAt => $composableBuilder(
    column: $table.fireAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get offset => $composableBuilder(
    column: $table.offset,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get eventId =>
      $composableBuilder(column: $table.eventId, builder: (column) => column);

  GeneratedColumn<DateTime> get fireAt =>
      $composableBuilder(column: $table.fireAt, builder: (column) => column);

  GeneratedColumn<String> get offset =>
      $composableBuilder(column: $table.offset, builder: (column) => column);
}

class $$RemindersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RemindersTable,
          ReminderRow,
          $$RemindersTableFilterComposer,
          $$RemindersTableOrderingComposer,
          $$RemindersTableAnnotationComposer,
          $$RemindersTableCreateCompanionBuilder,
          $$RemindersTableUpdateCompanionBuilder,
          (
            ReminderRow,
            BaseReferences<_$AppDatabase, $RemindersTable, ReminderRow>,
          ),
          ReminderRow,
          PrefetchHooks Function()
        > {
  $$RemindersTableTableManager(_$AppDatabase db, $RemindersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<String> eventId = const Value.absent(),
                Value<DateTime> fireAt = const Value.absent(),
                Value<String> offset = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RemindersCompanion(
                userId: userId,
                eventId: eventId,
                fireAt: fireAt,
                offset: offset,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                required String eventId,
                required DateTime fireAt,
                required String offset,
                Value<int> rowid = const Value.absent(),
              }) => RemindersCompanion.insert(
                userId: userId,
                eventId: eventId,
                fireAt: fireAt,
                offset: offset,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RemindersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RemindersTable,
      ReminderRow,
      $$RemindersTableFilterComposer,
      $$RemindersTableOrderingComposer,
      $$RemindersTableAnnotationComposer,
      $$RemindersTableCreateCompanionBuilder,
      $$RemindersTableUpdateCompanionBuilder,
      (
        ReminderRow,
        BaseReferences<_$AppDatabase, $RemindersTable, ReminderRow>,
      ),
      ReminderRow,
      PrefetchHooks Function()
    >;
typedef $$ReportsTableCreateCompanionBuilder =
    ReportsCompanion Function({
      required String id,
      required String target,
      required String reporterId,
      required String reason,
      required String status,
      required DateTime createdAt,
      Value<String?> eventId,
      Value<String?> organizerId,
      Value<String> comment,
      Value<int> rowid,
    });
typedef $$ReportsTableUpdateCompanionBuilder =
    ReportsCompanion Function({
      Value<String> id,
      Value<String> target,
      Value<String> reporterId,
      Value<String> reason,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<String?> eventId,
      Value<String?> organizerId,
      Value<String> comment,
      Value<int> rowid,
    });

class $$ReportsTableFilterComposer
    extends Composer<_$AppDatabase, $ReportsTable> {
  $$ReportsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get target => $composableBuilder(
    column: $table.target,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reporterId => $composableBuilder(
    column: $table.reporterId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventId => $composableBuilder(
    column: $table.eventId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get organizerId => $composableBuilder(
    column: $table.organizerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get comment => $composableBuilder(
    column: $table.comment,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReportsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReportsTable> {
  $$ReportsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get target => $composableBuilder(
    column: $table.target,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reporterId => $composableBuilder(
    column: $table.reporterId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventId => $composableBuilder(
    column: $table.eventId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get organizerId => $composableBuilder(
    column: $table.organizerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get comment => $composableBuilder(
    column: $table.comment,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReportsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReportsTable> {
  $$ReportsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get target =>
      $composableBuilder(column: $table.target, builder: (column) => column);

  GeneratedColumn<String> get reporterId => $composableBuilder(
    column: $table.reporterId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get eventId =>
      $composableBuilder(column: $table.eventId, builder: (column) => column);

  GeneratedColumn<String> get organizerId => $composableBuilder(
    column: $table.organizerId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get comment =>
      $composableBuilder(column: $table.comment, builder: (column) => column);
}

class $$ReportsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReportsTable,
          ReportRow,
          $$ReportsTableFilterComposer,
          $$ReportsTableOrderingComposer,
          $$ReportsTableAnnotationComposer,
          $$ReportsTableCreateCompanionBuilder,
          $$ReportsTableUpdateCompanionBuilder,
          (ReportRow, BaseReferences<_$AppDatabase, $ReportsTable, ReportRow>),
          ReportRow,
          PrefetchHooks Function()
        > {
  $$ReportsTableTableManager(_$AppDatabase db, $ReportsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReportsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReportsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReportsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> target = const Value.absent(),
                Value<String> reporterId = const Value.absent(),
                Value<String> reason = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> eventId = const Value.absent(),
                Value<String?> organizerId = const Value.absent(),
                Value<String> comment = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReportsCompanion(
                id: id,
                target: target,
                reporterId: reporterId,
                reason: reason,
                status: status,
                createdAt: createdAt,
                eventId: eventId,
                organizerId: organizerId,
                comment: comment,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String target,
                required String reporterId,
                required String reason,
                required String status,
                required DateTime createdAt,
                Value<String?> eventId = const Value.absent(),
                Value<String?> organizerId = const Value.absent(),
                Value<String> comment = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReportsCompanion.insert(
                id: id,
                target: target,
                reporterId: reporterId,
                reason: reason,
                status: status,
                createdAt: createdAt,
                eventId: eventId,
                organizerId: organizerId,
                comment: comment,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReportsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReportsTable,
      ReportRow,
      $$ReportsTableFilterComposer,
      $$ReportsTableOrderingComposer,
      $$ReportsTableAnnotationComposer,
      $$ReportsTableCreateCompanionBuilder,
      $$ReportsTableUpdateCompanionBuilder,
      (ReportRow, BaseReferences<_$AppDatabase, $ReportsTable, ReportRow>),
      ReportRow,
      PrefetchHooks Function()
    >;
typedef $$EventViewsTableCreateCompanionBuilder =
    EventViewsCompanion Function({
      Value<int> id,
      required String eventId,
      required String userId,
      required DateTime viewedAt,
    });
typedef $$EventViewsTableUpdateCompanionBuilder =
    EventViewsCompanion Function({
      Value<int> id,
      Value<String> eventId,
      Value<String> userId,
      Value<DateTime> viewedAt,
    });

class $$EventViewsTableFilterComposer
    extends Composer<_$AppDatabase, $EventViewsTable> {
  $$EventViewsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventId => $composableBuilder(
    column: $table.eventId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get viewedAt => $composableBuilder(
    column: $table.viewedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EventViewsTableOrderingComposer
    extends Composer<_$AppDatabase, $EventViewsTable> {
  $$EventViewsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventId => $composableBuilder(
    column: $table.eventId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get viewedAt => $composableBuilder(
    column: $table.viewedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EventViewsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EventViewsTable> {
  $$EventViewsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get eventId =>
      $composableBuilder(column: $table.eventId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get viewedAt =>
      $composableBuilder(column: $table.viewedAt, builder: (column) => column);
}

class $$EventViewsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EventViewsTable,
          EventViewRow,
          $$EventViewsTableFilterComposer,
          $$EventViewsTableOrderingComposer,
          $$EventViewsTableAnnotationComposer,
          $$EventViewsTableCreateCompanionBuilder,
          $$EventViewsTableUpdateCompanionBuilder,
          (
            EventViewRow,
            BaseReferences<_$AppDatabase, $EventViewsTable, EventViewRow>,
          ),
          EventViewRow,
          PrefetchHooks Function()
        > {
  $$EventViewsTableTableManager(_$AppDatabase db, $EventViewsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EventViewsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EventViewsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EventViewsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> eventId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<DateTime> viewedAt = const Value.absent(),
              }) => EventViewsCompanion(
                id: id,
                eventId: eventId,
                userId: userId,
                viewedAt: viewedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String eventId,
                required String userId,
                required DateTime viewedAt,
              }) => EventViewsCompanion.insert(
                id: id,
                eventId: eventId,
                userId: userId,
                viewedAt: viewedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EventViewsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EventViewsTable,
      EventViewRow,
      $$EventViewsTableFilterComposer,
      $$EventViewsTableOrderingComposer,
      $$EventViewsTableAnnotationComposer,
      $$EventViewsTableCreateCompanionBuilder,
      $$EventViewsTableUpdateCompanionBuilder,
      (
        EventViewRow,
        BaseReferences<_$AppDatabase, $EventViewsTable, EventViewRow>,
      ),
      EventViewRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$OrganizationsTableTableManager get organizations =>
      $$OrganizationsTableTableManager(_db, _db.organizations);
  $$OrganizationMembersTableTableManager get organizationMembers =>
      $$OrganizationMembersTableTableManager(_db, _db.organizationMembers);
  $$InviteKeysTableTableManager get inviteKeys =>
      $$InviteKeysTableTableManager(_db, _db.inviteKeys);
  $$EventsTableTableManager get events =>
      $$EventsTableTableManager(_db, _db.events);
  $$EventMediaTableTableManager get eventMedia =>
      $$EventMediaTableTableManager(_db, _db.eventMedia);
  $$EventCustomFieldsTableTableManager get eventCustomFields =>
      $$EventCustomFieldsTableTableManager(_db, _db.eventCustomFields);
  $$RegistrationsTableTableManager get registrations =>
      $$RegistrationsTableTableManager(_db, _db.registrations);
  $$FavoritesTableTableManager get favorites =>
      $$FavoritesTableTableManager(_db, _db.favorites);
  $$RemindersTableTableManager get reminders =>
      $$RemindersTableTableManager(_db, _db.reminders);
  $$ReportsTableTableManager get reports =>
      $$ReportsTableTableManager(_db, _db.reports);
  $$EventViewsTableTableManager get eventViews =>
      $$EventViewsTableTableManager(_db, _db.eventViews);
}
