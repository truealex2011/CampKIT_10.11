import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../domain/entities.dart';
import '../../domain/repositories.dart';
import '../shared/kit.dart';
import 'entry_widgets.dart';

class LoginIntent {
  const LoginIntent({required this.account, required this.password});

  final String account;
  final String password;
}

class ParticipantSignup {
  const ParticipantSignup({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });

  final String name;
  final String email;
  final String phone;
  final String password;
}

class JoinIntent {
  const JoinIntent({required this.orgId});

  final String orgId;
}

typedef LoginSubmit = Future<String?> Function(LoginIntent intent);
typedef ParticipantSubmit = Future<String?> Function(ParticipantSignup signup);
typedef OrganizerSubmit = Future<String?> Function(OrganizerSignup signup);
typedef JoinSubmit = Future<String?> Function(JoinIntent intent);

abstract final class Formats {
  static final email = RegExp(r'^[^@\s]+@[^@\s]+\.[A-Za-zа-яА-ЯёЁ]{2,}$');
  static final phone = RegExp(
    r'^\+?[78][\s(-]*\d{3}[\s)-]*\d{3}[\s-]*\d{2}[\s-]*\d{2}$',
  );
  static final inviteKey = RegExp(r'^CL-[A-Z0-9]{4}-[A-Z0-9]{4}$');
  static final orgId = RegExp(r'^org[-_][a-z0-9]+$');

  static int passwordScore(String value) {
    var s = 0;
    if (value.length >= 6) s++;
    if (value.length >= 10) s++;
    if (RegExp(r'\d').hasMatch(value) &&
        RegExp(r'[a-zа-я]', caseSensitive: false).hasMatch(value)) {
      s++;
    }
    if (RegExp(r'[A-ZА-Я]').hasMatch(value) &&
        RegExp(r'[^\w\s]').hasMatch(value)) {
      s++;
    }
    return s;
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    super.key,
    required this.onLogin,
    required this.onParticipantSignup,
    required this.onOrganizerSignup,
    required this.onJoinRequest,
    this.onTabChanged,
    this.onGuest,
    this.onForgot,
    this.onQuickLogin,
  });

  final LoginSubmit onLogin;
  final ParticipantSubmit onParticipantSignup;
  final OrganizerSubmit onOrganizerSignup;
  final JoinSubmit onJoinRequest;
  final ValueChanged<bool>? onTabChanged;
  final VoidCallback? onGuest;
  final VoidCallback? onForgot;
  final void Function(UserRole role)? onQuickLogin;

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) => GlassCard(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SegTabs(
          items: const ['Вход', 'Регистрация'],
          index: _tab,
          onSelect: (index) {
            setState(() => _tab = index);
            widget.onTabChanged?.call(index == 1);
          },
        ),
        // Switch directly: animating the card's height also shifts the
        // surrounding vertically centred content on small screens.
        if (_tab == 0)
          _LoginForm(
            key: const ValueKey('login'),
            onLogin: widget.onLogin,
            onGuest: widget.onGuest,
            onForgot: widget.onForgot,
            onQuickLogin: widget.onQuickLogin,
          )
        else
          _SignupForm(
            key: const ValueKey('signup'),
            onParticipantSignup: widget.onParticipantSignup,
            onOrganizerSignup: widget.onOrganizerSignup,
            onJoinRequest: widget.onJoinRequest,
          ),
      ],
    ),
  );
}

class _LoginForm extends StatefulWidget {
  const _LoginForm({
    super.key,
    required this.onLogin,
    this.onGuest,
    this.onForgot,
    this.onQuickLogin,
  });

  final LoginSubmit onLogin;
  final VoidCallback? onGuest;
  final VoidCallback? onForgot;
  final void Function(UserRole role)? onQuickLogin;

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final TextEditingController _account = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final Map<String, String> _errors = {};
  bool _busy = false;

  @override
  void dispose() {
    _account.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_busy) return;
    final errors = <String, String>{};
    if (_account.text.trim().isEmpty) {
      errors['account'] = 'Введи почту или телефон';
    }
    if (_password.text.length < 6) errors['password'] = 'Минимум 6 символов';
    setState(() {
      _errors
        ..clear()
        ..addAll(errors);
    });
    if (errors.isNotEmpty) return;

    setState(() => _busy = true);
    final failure = await widget.onLogin(
      LoginIntent(account: _account.text.trim(), password: _password.text),
    );
    if (!mounted) return;
    setState(() => _busy = false);
    _report(failure);
  }

  void _report(String? failure) {
    if (!mounted) return;
    ToastController.show(context, failure ?? 'Готово', error: failure != null);
  }

  @override
  Widget build(BuildContext context) => FormSection(
    children: [
      GlassField(
        label: 'Почта или телефон',
        controller: _account,
        hint: 'uchastnik@campus.life',
        icon: Icons.alternate_email_rounded,
        keyboardType: TextInputType.emailAddress,
        error: _errors['account'],
        onChanged: (_) => _errors.remove('account'),
      ),
      GlassField(
        label: 'Пароль',
        controller: _password,
        hint: '••••••••',
        icon: Icons.lock_outline_rounded,
        obscure: true,
        error: _errors['password'],
        onChanged: (_) => _errors.remove('password'),
      ),
      PrimaryButton(label: 'Войти', busy: _busy, onPressed: _submit),
      const SizedBox(height: 12),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: TextLink('Забыли пароль?', onTap: widget.onForgot)),
          Flexible(
            child: TextLink('Продолжить как гость', onTap: widget.onGuest),
          ),
        ],
      ),
      const DividerLabel('быстрый вход'),
      Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          for (final role in UserRole.values)
            RoleChip(
              label: role.label.toLowerCase(),
              dot: Palette.roleDot(role),
              onTap: () => widget.onQuickLogin?.call(role),
            ),
        ],
      ),
    ],
  );
}

class _SignupForm extends StatefulWidget {
  const _SignupForm({
    super.key,
    required this.onParticipantSignup,
    required this.onOrganizerSignup,
    required this.onJoinRequest,
  });

  final ParticipantSubmit onParticipantSignup;
  final OrganizerSubmit onOrganizerSignup;
  final JoinSubmit onJoinRequest;

  @override
  State<_SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<_SignupForm> {
  int _role = 0;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 12, 0, 2),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: RoleCard(
                  title: 'Участник',
                  description: 'Смотришь афишу и ходишь на события',
                  selected: _role == 0,
                  icon: Icons.person_outline_rounded,
                  onTap: () => setState(() => _role = 0),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: RoleCard(
                  title: 'Организатор',
                  description: 'Создаёшь события и ведёшь свою организацию',
                  selected: _role == 1,
                  icon: Icons.campaign_outlined,
                  onTap: () => setState(() => _role = 1),
                ),
              ),
            ],
          ),
        ),
      ),
      AnimatedSize(
        duration: const Duration(milliseconds: 260),
        curve: Palette.ease,
        alignment: Alignment.topCenter,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 380),
          switchInCurve: Palette.ease,
          child: _role == 0
              ? _MemberForm(
                  key: const ValueKey('member'),
                  onSubmit: widget.onParticipantSignup,
                )
              : _OrgPane(
                  key: const ValueKey('org'),
                  onOrganizer: widget.onOrganizerSignup,
                  onJoin: widget.onJoinRequest,
                ),
        ),
      ),
    ],
  );
}

class _MemberForm extends StatefulWidget {
  const _MemberForm({super.key, required this.onSubmit});

  final ParticipantSubmit onSubmit;

  @override
  State<_MemberForm> createState() => _MemberFormState();
}

class _MemberFormState extends State<_MemberForm> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final Map<String, String> _errors = {};
  bool _busy = false;

  @override
  void dispose() {
    for (final c in [_name, _email, _phone, _password]) {
      c.dispose();
    }
    super.dispose();
  }

  bool _check() {
    final errors = <String, String>{};
    if (_name.text.trim().length < 3) errors['name'] = 'Имя и фамилия';
    if (!Formats.email.hasMatch(_email.text.trim())) {
      errors['email'] = 'Проверь формат почты';
    }
    if (_phone.text.trim().isNotEmpty &&
        !Formats.phone.hasMatch(_phone.text.trim())) {
      errors['phone'] = 'Телефон в формате +7 900 123-45-67';
    }
    if (_password.text.length < 6) errors['password'] = 'Минимум 6 символов';
    setState(() {
      _errors
        ..clear()
        ..addAll(errors);
    });
    return errors.isEmpty;
  }

  Future<void> _submit() async {
    if (_busy || !_check()) return;
    setState(() => _busy = true);
    final failure = await widget.onSubmit(
      ParticipantSignup(
        name: _name.text.trim(),
        email: _email.text.trim(),
        phone: _phone.text.trim(),
        password: _password.text,
      ),
    );
    if (!mounted) return;
    setState(() => _busy = false);
    ToastController.show(
      context,
      failure ?? 'Аккаунт участника создан',
      error: failure != null,
    );
  }

  @override
  Widget build(BuildContext context) => FormSection(
    children: [
      GlassField(
        label: 'Имя и фамилия',
        controller: _name,
        hint: 'Алексей Петров',
        icon: Icons.person_outline_rounded,
        textCapitalization: TextCapitalization.words,
        error: _errors['name'],
        onChanged: (_) => _errors.remove('name'),
      ),
      GlassField(
        label: 'Почта',
        controller: _email,
        hint: 'me@example.com',
        icon: Icons.alternate_email_rounded,
        keyboardType: TextInputType.emailAddress,
        error: _errors['email'],
        onChanged: (_) => _errors.remove('email'),
      ),
      GlassField(
        label: 'Телефон',
        controller: _phone,
        hint: '+7 900 123-45-67',
        icon: Icons.phone_outlined,
        keyboardType: TextInputType.phone,
        error: _errors['phone'],
        onChanged: (_) => _errors.remove('phone'),
      ),
      GlassField(
        label: 'Пароль',
        controller: _password,
        hint: 'минимум 6 символов',
        icon: Icons.lock_outline_rounded,
        obscure: true,
        error: _errors['password'],
        onChanged: (_) => setState(() => _errors.remove('password')),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: PasswordStrength(
          score: Formats.passwordScore(_password.text),
          focused: _password.text.isNotEmpty,
        ),
      ),
      PrimaryButton(label: 'Создать аккаунт', busy: _busy, onPressed: _submit),
      const NoteBlock(
        lead: 'Ключ не нужен',
        text: '— участник регистрируется сам.',
      ),
    ],
  );
}

class _OrgPane extends StatefulWidget {
  const _OrgPane({super.key, required this.onOrganizer, required this.onJoin});

  final OrganizerSubmit onOrganizer;
  final JoinSubmit onJoin;

  @override
  State<_OrgPane> createState() => _OrgPaneState();
}

class _OrgPaneState extends State<_OrgPane> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      MiniTabs(
        items: const ['Создать организацию', 'Вступить по id'],
        index: _tab,
        onSelect: (index) => setState(() => _tab = index),
      ),
      AnimatedSize(
        duration: const Duration(milliseconds: 260),
        curve: Palette.ease,
        alignment: Alignment.topCenter,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 380),
          switchInCurve: Palette.ease,
          child: _tab == 0
              ? _OrgWizard(
                  key: const ValueKey('wizard'),
                  onSubmit: widget.onOrganizer,
                )
              : _JoinForm(key: const ValueKey('join'), onSubmit: widget.onJoin),
        ),
      ),
    ],
  );
}

class _OrgWizard extends StatefulWidget {
  const _OrgWizard({super.key, required this.onSubmit});

  final OrganizerSubmit onSubmit;

  @override
  State<_OrgWizard> createState() => _OrgWizardState();
}

class _OrgWizardState extends State<_OrgWizard> {
  static OrgType _typeByLabel(String? label) => OrgType.values.firstWhere(
    (type) => type.label == label,
    orElse: () => OrgType.school,
  );

  final TextEditingController _key = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _city = TextEditingController(text: 'Москва');
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final Map<String, String> _errors = {};

  int _step = 0;
  String? _typeLabel;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _key.text = 'CL-';
  }

  @override
  void dispose() {
    for (final c in [_key, _name, _city, _phone, _email, _password]) {
      c.dispose();
    }
    super.dispose();
  }

  bool _validateStep() {
    final errors = <String, String>{};
    if (_step == 0) {
      if (!Formats.inviteKey.hasMatch(_key.text.trim().toUpperCase())) {
        errors['key'] = 'Формат ключа CL-XXXX-XXXX';
      }
    } else {
      if (_name.text.trim().length < 3) {
        errors['name'] = 'Название от 3 символов';
      }
      if (_typeLabel == null) errors['type'] = 'Выбери тип организации';
      if (!Formats.phone.hasMatch(_phone.text.trim())) {
        errors['phone'] = 'Телефон в формате +7 900 123-45-67';
      }
      if (!Formats.email.hasMatch(_email.text.trim())) {
        errors['email'] = 'Проверь формат почты';
      }
      if (_password.text.length < 6) errors['password'] = 'Минимум 6 символов';
    }
    setState(() {
      _errors
        ..clear()
        ..addAll(errors);
    });
    return errors.isEmpty;
  }

  Future<void> _submit() async {
    if (_busy || !_validateStep()) return;
    setState(() => _busy = true);
    final failure = await widget.onSubmit(
      OrganizerSignup(
        inviteKey: _key.text.trim().toUpperCase(),
        orgName: _name.text.trim(),
        orgType: _typeByLabel(_typeLabel),
        city: _city.text.trim(),
        phone: _phone.text.trim(),
        email: _email.text.trim(),
        password: _password.text,
      ),
    );
    if (!mounted) return;
    setState(() => _busy = false);
    ToastController.show(
      context,
      failure ?? 'Организация создана',
      error: failure != null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final keyReady = Formats.inviteKey.hasMatch(_key.text.trim().toUpperCase());
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        WizardSteps(step: _step, total: 2),
        AnimatedSize(
          duration: const Duration(milliseconds: 260),
          curve: Palette.ease,
          alignment: Alignment.topCenter,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 450),
            switchInCurve: Palette.ease,
            child: _step == 0
                ? FormSection(
                    key: const ValueKey('step-0'),
                    children: [
                      GlassField(
                        label: 'Ключ администратора',
                        controller: _key,
                        hint: 'CL-XXXX-XXXX',
                        icon: Icons.vpn_key_outlined,
                        uppercase: true,
                        maxLength: 13,
                        error: _errors['key'],
                        onChanged: (_) => setState(() => _errors.remove('key')),
                      ),
                      const NoteBlock(
                        lead: 'Одноразовый ключ выдаёт админ.',
                        text: 'В базе хранится только хеш, попытки ограничены.',
                      ),
                      const SizedBox(height: 12),
                      PrimaryButton(
                        label: 'Далее',
                        arrow: true,
                        onPressed: keyReady && !_busy
                            ? () {
                                if (_validateStep()) setState(() => _step = 1);
                              }
                            : null,
                      ),
                    ],
                  )
                : FormSection(
                    key: const ValueKey('step-1'),
                    children: [
                      GlassField(
                        label: 'Название организации',
                        controller: _name,
                        hint: 'Студсовет школы №24',
                        icon: Icons.flag_outlined,
                        textCapitalization: TextCapitalization.sentences,
                        error: _errors['name'],
                        onChanged: (_) =>
                            setState(() => _errors.remove('name')),
                      ),
                      GlassSelect(
                        label: 'Тип',
                        value: _typeLabel,
                        items: [for (final t in OrgType.values) t.label],
                        placeholder: _errors['type'] ?? 'Выбери тип',
                        onChanged: (value) => setState(() {
                          _typeLabel = value;
                          _errors.remove('type');
                        }),
                      ),
                      GlassField(
                        label: 'Город',
                        controller: _city,
                        hint: 'Москва',
                        icon: Icons.location_on_outlined,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                      GlassField(
                        label: 'Телефон организации',
                        controller: _phone,
                        hint: '+7 900 123-45-67',
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        error: _errors['phone'],
                        onChanged: (_) => _errors.remove('phone'),
                      ),
                      GlassField(
                        label: 'Почта организации',
                        controller: _email,
                        hint: 'studio@example.com',
                        icon: Icons.alternate_email_rounded,
                        keyboardType: TextInputType.emailAddress,
                        error: _errors['email'],
                        onChanged: (_) => _errors.remove('email'),
                      ),
                      GlassField(
                        label: 'Пароль для входа',
                        controller: _password,
                        hint: 'минимум 6 символов',
                        icon: Icons.lock_outline_rounded,
                        obscure: true,
                        error: _errors['password'],
                        onChanged: (_) =>
                            setState(() => _errors.remove('password')),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: PasswordStrength(
                          score: Formats.passwordScore(_password.text),
                          focused: _password.text.isNotEmpty,
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 110,
                            child: GhostButton(
                              label: 'Назад',
                              onPressed: _busy
                                  ? null
                                  : () => setState(() => _step = 0),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: PrimaryButton(
                              label: 'Создать',
                              busy: _busy,
                              onPressed: _submit,
                            ),
                          ),
                        ],
                      ),
                      const NoteBlock(
                        lead: 'Станешь владельцем организации',
                        text: '— логотип добавишь позже в профиле.',
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}

class _JoinForm extends StatefulWidget {
  const _JoinForm({super.key, required this.onSubmit});

  final JoinSubmit onSubmit;

  @override
  State<_JoinForm> createState() => _JoinFormState();
}

class _JoinFormState extends State<_JoinForm> {
  final TextEditingController _orgId = TextEditingController();
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _orgId.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_busy) return;
    final value = _orgId.text.trim().toLowerCase();
    if (!Formats.orgId.hasMatch(value)) {
      setState(
        () =>
            _error = 'id начинается с org, возьми его из карточки организации',
      );
      return;
    }
    setState(() {
      _error = null;
      _busy = true;
    });
    final failure = await widget.onSubmit(JoinIntent(orgId: value));
    if (!mounted) return;
    setState(() => _busy = false);
    ToastController.show(
      context,
      failure ?? 'Заявка отправлена владельцу',
      error: failure != null,
    );
  }

  @override
  Widget build(BuildContext context) => FormSection(
    children: [
      GlassField(
        label: 'id организации',
        controller: _orgId,
        hint: 'org_1',
        icon: Icons.tag,
        error: _error,
        onChanged: (_) => setState(() => _error = null),
      ),
      PrimaryButton(label: 'Отправить заявку', busy: _busy, onPressed: _submit),
      const NoteBlock(
        lead: 'Ключ не нужен',
        text: '— заявку одобряет владелец организации в своём профиле.',
      ),
    ],
  );
}

class FormSection extends StatelessWidget {
  const FormSection({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 14),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    ),
  );
}
