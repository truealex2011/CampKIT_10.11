import 'dart:async';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/di.dart';
import '../../app/theme.dart';
import '../../domain/entities.dart';
import '../entry/entry_widgets.dart';
import '../feed/event_sheet.dart';
import '../shared/event_preview_screen.dart';
import '../shared/fish.dart';
import '../shared/kit.dart';
import '../shared/pixel.dart';
import '../shared/video_source.dart';
import 'organizer_common.dart';

class EventWizard extends ConsumerStatefulWidget {
  const EventWizard({super.key, required this.orgId, this.eventId});

  final String orgId;
  final String? eventId;

  @override
  ConsumerState<EventWizard> createState() => _EventWizardState();
}

class _EventWizardState extends ConsumerState<EventWizard> {
  static const int _total = 6;
  static const List<String> _stepLabels = [
    'афиша',
    'время и место',
    'медиа',
    'анкета на вход',
    'проверка',
    'публикация',
  ];

  late final String _eventId;
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();
  final TextEditingController _placeCtrl = TextEditingController();
  final TextEditingController _capacityCtrl = TextEditingController();
  final List<_FieldDraft> _fields = [];
  final List<EventMedia> _photos = [];

  EventCategory? _category;
  EventMedia? _video;
  EventStatus _status = EventStatus.draft;
  bool _autoApprove = false;
  DateTime _startAt = DateTime.now().add(const Duration(days: 3));
  int _step = 0;
  bool _ready = false;
  bool _busy = false;
  bool _left = false;
  String? _hint;
  CampusEvent? _resultEvent;
  bool _resultPublished = false;

  @override
  void initState() {
    super.initState();
    _eventId = widget.eventId ?? Ids.next('ev');
    unawaited(_load());
  }

  @override
  void dispose() {
    for (final c in [_titleCtrl, _descCtrl, _placeCtrl, _capacityCtrl]) {
      c.dispose();
    }
    for (final f in _fields) {
      f.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    final id = widget.eventId;
    if (id != null) {
      final event = await ref.read(repositoryProvider).eventById(id);
      if (event != null) _apply(event);
    }
    if (!mounted) return;
    setState(() => _ready = true);
  }

  void _apply(CampusEvent event) {
    _titleCtrl.text = event.title;
    _descCtrl.text = event.description;
    _placeCtrl.text = event.place;
    _capacityCtrl.text = event.capacity > 0 ? '${event.capacity}' : '';
    _category = event.category;
    _startAt = event.startAt;
    _status = event.status;
    _autoApprove = event.autoApprove;
    _photos
      ..clear()
      ..addAll(event.photos);
    _video = event.video;
    _fields
      ..clear()
      ..addAll([for (final f in event.fields) _FieldDraft.fromField(f)]);
  }

  int get _capacityValue {
    final raw = int.tryParse(_capacityCtrl.text.trim());
    return raw == null || raw <= 0 ? -1 : raw;
  }

  bool get _hasContent => _titleCtrl.text.trim().isNotEmpty;

  bool get _canNext => switch (_step) {
    0 => _titleCtrl.text.trim().length >= 3 && _category != null,
    1 => _placeCtrl.text.trim().isNotEmpty,
    3 => _fields.every((f) => f.labelCtrl.text.trim().isNotEmpty),
    _ => true,
  };

  CampusEvent _buildEvent(EventStatus status) {
    final media = <EventMedia>[?_video, ..._photos];
    return CampusEvent(
      id: _eventId,
      orgId: widget.orgId,
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      category: _category ?? EventCategory.contest,
      startAt: _startAt,
      place: _placeCtrl.text.trim(),
      capacity: _capacityValue,
      status: status,
      autoApprove: _autoApprove,
      media: [for (var i = 0; i < media.length; i++) _at(media[i], i)],
      fields: [
        for (var i = 0; i < _fields.length; i++)
          _fields[i].toField(_eventId, i),
      ],
    );
  }

  EventMedia _at(EventMedia m, int position) => EventMedia(
    id: m.id,
    eventId: _eventId,
    kind: m.kind,
    path: m.path,
    previewPath: m.previewPath,
    position: position,
    durationMs: m.durationMs,
    bytes: m.bytes,
  );

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const Scaffold(
        body: SafeArea(child: Center(child: FishLoader(size: 40))),
      );
    }
    final result = _resultEvent;
    if (result != null) return _successView(result);
    final width = MediaQuery.sizeOf(context).width;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        unawaited(_saveAndExit());
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Scale.gutter(width)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MicroLabel(
                            widget.eventId == null
                                ? 'новое событие'
                                : 'редактор · ${_status.label}',
                          ),
                          Text(
                            _stepLabels[_step],
                            style: Fonts.sansStyle(
                              size: 21,
                              weight: 700,
                              height: 1.12,
                              color: context.colors.ink,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextLink(
                      'выйти',
                      onTap: _busy ? null : () => unawaited(_saveAndExit()),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                PixelProgress(value: (_step + 1) / _total, cells: _total * 4),
                const SizedBox(height: 12),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: MediaQuery.disableAnimationsOf(context)
                        ? Duration.zero
                        : AppMotion.slow,
                    switchInCurve: AppMotion.ease,
                    switchOutCurve: AppMotion.ease,
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.06, 0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    ),
                    child: SingleChildScrollView(
                      key: ValueKey(_step),
                      child: _content(),
                    ),
                  ),
                ),
                _footer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _successView(CampusEvent event) {
    final published = _resultPublished;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Scale.gutter(MediaQuery.sizeOf(context).width),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 26),
              Icon(
                published
                    ? Icons.check_circle_outline_rounded
                    : Icons.edit_note_rounded,
                size: 58,
                color: published ? Palette.mint : Palette.gold,
              ),
              const SizedBox(height: 18),
              MicroLabel(
                published ? 'отправлено на модерацию' : 'черновик сохранён',
              ),
              const SizedBox(height: 4),
              Text(
                published ? 'Событие создано' : 'Черновик сохранён',
                style: Fonts.sansStyle(size: 24, weight: 700, height: 1.15),
              ),
              const SizedBox(height: 10),
              Text(
                event.title.trim().isEmpty ? 'Без названия' : event.title.trim(),
                style: Fonts.sansStyle(size: 16, weight: 600),
              ),
              const SizedBox(height: 6),
              Text(
                '${event.place.isEmpty ? 'место не указано' : event.place} · ${event.status.label}',
                style: Fonts.sansStyle(size: 12.5, color: Palette.ink2),
              ),
              const SizedBox(height: 14),
              NoteBlock(
                lead: published ? 'Модерация.' : 'Черновик.',
                text: published
                    ? 'Событие уйдёт в общую ленту после подтверждения модератором. Сейчас оно видно в кабинете организатора.'
                    : 'Событие не видно участникам. Вернись в кабинет и продолжи редактирование в удобное время.',
              ),
              const Spacer(),
              PrimaryButton(
                label: 'Открыть событие',
                icon: Icons.visibility_outlined,
                arrow: false,
                onPressed: () {
                  final id = event.id;
                  Navigator.of(context).pop();
                  openEventSheet(context, id);
                },
              ),
              const SizedBox(height: 10),
              GhostButton(
                label: 'Вернуться в кабинет',
                expand: true,
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _content() => switch (_step) {
    0 => _basicsStep(),
    1 => _whenStep(),
    2 => _mediaStep(),
    3 => _fieldsStep(),
    4 => _reviewStep(),
    _ => _publishStep(),
  };

  Widget _basicsStep() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      GlassField(
        label: 'Название',
        controller: _titleCtrl,
        hint: 'Квест «Комната 24»',
        icon: Icons.title_rounded,
        textCapitalization: TextCapitalization.sentences,
        maxLength: 80,
        onChanged: (_) => setState(() {}),
      ),
      GlassField(
        label: 'Описание',
        controller: _descCtrl,
        hint: 'Что происходит, для кого, что взять с собой',
        icon: Icons.notes_rounded,
        textCapitalization: TextCapitalization.sentences,
        maxLength: 600,
        maxLines: 4,
      ),
      GlassSelect(
        label: 'Категория',
        value: _category?.label,
        items: const [
          'Спорт',
          'Творчество',
          'Наука',
          'Конкурсы',
          'Лекции',
          'Музыка',
          'Волонтёрство',
          'Выезды',
        ],
        icon: Icons.category_outlined,
        placeholder: 'Выбери категорию',
        onChanged: (value) =>
            setState(() => _category = _categoryByLabel(value)),
      ),
      const NoteBlock(
        lead: 'Без категории',
        text: '— событие не уйдёт на проверку: оно нужно ленте для фильтра.',
      ),
    ],
  );

  Widget _whenStep() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _PickRow(
        label: 'Дата',
        value: RuFmt.date(_startAt),
        icon: Icons.calendar_today_rounded,
        onTap: _pickDate,
      ),
      _PickRow(
        label: 'Время начала',
        value: RuFmt.time(_startAt),
        icon: Icons.schedule_rounded,
        onTap: _pickTime,
      ),
      GlassField(
        label: 'Место',
        controller: _placeCtrl,
        hint: 'Актовый зал, корпус 2',
        icon: Icons.place_rounded,
        textCapitalization: TextCapitalization.sentences,
        maxLength: 120,
        onChanged: (_) => setState(() {}),
      ),
      GlassField(
        label: 'Мест всего',
        controller: _capacityCtrl,
        hint: 'пусто — без лимита',
        icon: Icons.local_see_rounded,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        maxLength: 4,
        onChanged: (_) => setState(() {}),
      ),
      if (_capacityValue > 0)
        Text(
          'Запись закроется, когда свободных мест не останется.',
          style: Fonts.sansStyle(size: 11.5, color: Palette.muted),
        ),
      const SizedBox(height: 12),
      DecoratedBox(
        decoration: BoxDecoration(
          color: context.colors.glassField,
          borderRadius: BorderRadius.circular(Scale.fieldRadius),
          border: Border.all(color: context.colors.line),
        ),
        child: SwitchListTile(
          value: _autoApprove,
          onChanged: (v) => setState(() => _autoApprove = v),
          title: Text(
            'Автоматическое подтверждение заявок',
            style: Fonts.sansStyle(
              size: 13.5,
              weight: 600,
              color: context.colors.ink,
            ),
          ),
          subtitle: Text(
            _autoApprove
                ? 'Заявки участников одобряются автоматически'
                : 'Организатор вручную одобряет/отклоняет заявки во вкладке «Анкеты»',
            style: Fonts.sansStyle(size: 11.5, color: Palette.muted),
          ),
          activeThumbColor: Palette.accent,
        ),
      ),
      if (_startAt.isBefore(DateTime.now()))
        const Padding(
          padding: EdgeInsets.only(top: 8),
          child: NoteBlock(
            lead: 'Дата в прошлом.',
            text: 'Такое событие уйдёт в архив ленты — выбери будущий день.',
          ),
        ),
    ],
  );

  Widget _mediaStep() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Row(
        children: GhostButton.pair(
          GhostButton(
            label: _video == null ? 'Видео до 30 сек' : 'Заменить видео',
            onPressed: _busy ? null : _pickVideo,
          ),
          GhostButton(
            label: 'Добавить фото',
            onPressed: _busy ? null : _pickPhotos,
          ),
        ),
      ),
      const SizedBox(height: 8),
      Row(
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: 16,
            color: context.colors.muted,
          ),
          const SizedBox(width: 6),
          Text(
            'Загружено: ${_photos.length}/20',
            style: Fonts.monoStyle(size: 11, color: context.colors.muted),
          ),
        ],
      ),
      const SizedBox(height: 12),
      if (_video == null && _photos.isEmpty)
        const NoteBlock(
          lead: 'Можно и без медиа.',
          text:
              'В ленте тогда сыграет цветная подложка категории. Видео одно, фото — до 20.',
        ),
      if (_video != null) _videoCard(_video!),
      if (_photos.isNotEmpty)
        DividerLabel('Порядок фото · тащи за руку', top: 12),
      if (_photos.isNotEmpty)
        ReorderableListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          onReorder: (oldIndex, newIndex) => setState(
            () => _photos.insert(
              newIndex > oldIndex ? newIndex - 1 : newIndex,
              _photos.removeAt(oldIndex),
            ),
          ),
          children: [
            for (var i = 0; i < _photos.length; i++) _mediaRow(_photos[i], i),
          ],
        ),
      const SizedBox(height: 8),
    ],
  );

  Widget _videoCard(EventMedia media) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.fromLTRB(10, 10, 4, 10),
    decoration: _rowDecoration(),
    child: Row(
      children: [
        _thumb(media.path, 52),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Видео в карусели',
                style: Fonts.sansStyle(size: 13, weight: 600),
              ),
              const SizedBox(height: 3),
              Text(
                '${_durationLabel(media.durationMs)} · ${_bytesLabel(media.bytes)}',
                style: Fonts.monoStyle(size: 9.5, color: Palette.muted),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: _busy
              ? null
              : () => unawaited(_removeMedia(media.id, isVideo: true)),
          icon: const Icon(
            Icons.delete_outline_rounded,
            size: 19,
            color: Palette.rose,
          ),
        ),
      ],
    ),
  );

  Widget _mediaRow(EventMedia media, int index) => Container(
    key: ValueKey(media.id),
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.fromLTRB(6, 8, 4, 8),
    decoration: _rowDecoration(),
    child: Row(
      children: [
        ReorderableDragStartListener(
          index: index,
          child: const Icon(
            Icons.drag_handle_rounded,
            size: 20,
            color: Palette.muted,
          ),
        ),
        const SizedBox(width: 6),
        _thumb(media.path, 42),
        const SizedBox(width: 11),
        Expanded(
          child: Text(
            'Фото ${index + 1}',
            style: Fonts.sansStyle(size: 12.5, color: Palette.ink2),
          ),
        ),
        Text(
          _bytesLabel(media.bytes),
          style: Fonts.monoStyle(size: 9.5, color: Palette.muted),
        ),
        IconButton(
          onPressed: _busy
              ? null
              : () => unawaited(_removeMedia(media.id, isVideo: false)),
          icon: const Icon(Icons.close_rounded, size: 18, color: Palette.muted),
        ),
      ],
    ),
  );

  BoxDecoration _rowDecoration() => BoxDecoration(
    color: Palette.wash,
    borderRadius: BorderRadius.circular(Scale.fieldRadius),
    border: Border.all(color: Palette.line),
  );

  Widget _thumb(String path, double size) => ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: SizedBox(
      height: size,
      width: size,
      child: mediaImage(
        path,
        placeholder: const ColoredBox(
          color: Palette.washDeep,
          child: Icon(Icons.image_outlined, size: 18, color: Palette.muted),
        ),
      ),
    ),
  );

  Widget _fieldsStep() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      if (_fields.isEmpty)
        const NoteBlock(
          lead: 'Анкета не обязательна.',
          text: 'Добавь до 10 вопросов — ответы участники впишут при записи.',
        ),
      if (_fields.isNotEmpty)
        ReorderableListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          onReorder: (oldIndex, newIndex) => setState(() {
            final target = newIndex > oldIndex ? newIndex - 1 : newIndex;
            _fields.insert(target, _fields.removeAt(oldIndex));
          }),
          children: [
            for (var i = 0; i < _fields.length; i++) _fieldCard(_fields[i], i),
          ],
        ),
      const SizedBox(height: 4),
      GhostButton(
        label: _fields.length >= 10
            ? 'Лимит: 10 полей'
            : '+ Добавить поле (${_fields.length}/10)',
        expand: true,
        onPressed: _fields.length >= 10
            ? null
            : () => setState(() => _fields.add(_FieldDraft())),
      ),
      const SizedBox(height: 8),
    ],
  );

  Widget _fieldCard(_FieldDraft draft, int index) => Container(
    key: ValueKey(draft.id),
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.fromLTRB(6, 4, 8, 2),
    decoration: _rowDecoration(),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 22),
          child: ReorderableDragStartListener(
            index: index,
            child: const Icon(
              Icons.drag_handle_rounded,
              size: 20,
              color: Palette.muted,
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GlassField(
                label: 'Вопрос ${index + 1}',
                controller: draft.labelCtrl,
                hint: 'ФИО участника',
                icon: Icons.help_outline_rounded,
                textCapitalization: TextCapitalization.sentences,
                maxLength: 80,
                onChanged: (_) => setState(() {}),
              ),
              GlassSelect(
                label: 'Тип ответа',
                value: draft.type.label,
                items: const [
                  'Текст',
                  'Число',
                  'Ссылка',
                  'Да/нет',
                  'Выбор из списка',
                ],
                icon: Icons.tune_rounded,
                placeholder: 'Выбери тип',
                onChanged: (value) =>
                    setState(() => draft.type = _typeByLabel(value)),
              ),
               if (draft.type == FieldType.choice)
                 GlassField(
                   label: 'Варианты через запятую',
                   controller: draft.optionsCtrl,
                   hint: '10 класс, 11 класс',
                   icon: Icons.list_alt_rounded,
                   onChanged: (_) => setState(() {}),
                 ),
               SwitchListTile.adaptive(
                 contentPadding: EdgeInsets.zero,
                 title: Text(
                   'Обязательный вопрос',
                   style: Fonts.sansStyle(size: 12.5, color: Palette.ink2),
                 ),
                 value: draft.required,
                 onChanged: (value) => setState(() => draft.required = value),
               ),

            ],
          ),
        ),
        IconButton(
          onPressed: _busy
              ? null
              : () => setState(() => _fields.removeAt(index).dispose()),
          icon: const Icon(Icons.close_rounded, size: 18, color: Palette.muted),
        ),
      ],
    ),
  );

  Widget _reviewStep() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      GhostButton(
        label: 'Посмотреть как в ленте (полный экран)',
        icon: Icons.visibility_outlined,
        expand: true,
        onPressed: () => EventPreviewScreen.show(context, _buildEvent(_status)),
      ),
      const SizedBox(height: 12),
      ParticipantPreview(event: _buildEvent(_status)),
      const SizedBox(height: 10),
      const NoteBlock(
        lead: 'Вот так',
        text:
            'это увидит участник в ленте. Вернись на любой шаг кнопкой «Назад», если что-то не так.',
      ),
    ],
  );

  Widget _publishStep() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 4),
            MicroLabel('итог'),
            Text(
              _titleCtrl.text.trim().isEmpty
                  ? 'Без названия'
                  : _titleCtrl.text.trim(),
              style: Fonts.sansStyle(size: 17, weight: 700, height: 1.2),
            ),
            const SizedBox(height: 7),
            Text(
              '${RuFmt.dateTime(_startAt)} · ${_placeCtrl.text.trim()}',
              style: Fonts.sansStyle(size: 12.5, color: Palette.ink2),
            ),
            const SizedBox(height: 7),
            Text(
              '${_category?.label ?? 'без категории'} · '
              '${_video == null ? 'без видео' : 'видео'} · '
              '${_photos.length} фото · ${_fields.length} полей · '
              '${_capacityValue > 0 ? 'мест: $_capacityValue' : 'без лимита'}',
              style: Fonts.monoStyle(size: 9.5, color: Palette.muted),
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
      const SizedBox(height: 12),
      const NoteBlock(
        lead: 'Модерация.',
        text:
            'После отправки событие появится в общей ленте, только когда его подтвердит модератор. До этого оно видно тебе в кабинете.',
      ),
      if (_hint != null) ...[
        const SizedBox(height: 10),
        Text(
          _hint!,
          style: Fonts.sansStyle(size: 12.5, weight: 500, color: Palette.rose),
        ),
      ],
      const SizedBox(height: 14),
      PrimaryButton(
        label: 'Отправить на проверку',
        busy: _busy,
        arrow: false,
        onPressed: _busy ? null : () => unawaited(_publish()),
      ),
      const SizedBox(height: 10),
      GhostButton(
        label: 'Сохранить как черновик',
        expand: true,
        onPressed: _busy ? null : () => unawaited(_saveDraft()),
      ),
    ],
  );

  Widget _footer() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const SizedBox(height: 10),
      _step == _total - 1
          ? GhostButton(
              label: 'Назад к проверке',
              expand: true,
              onPressed: _busy ? null : _back,
            )
          : Row(
              children: GhostButton.pair(
                GhostButton(
                  label: 'Назад',
                  onPressed: _step == 0 ? null : _back,
                ),
                PrimaryButton(
                  label: _step == _total - 2 ? 'К публикации' : 'Далее',
                  onPressed: _canNext && !_busy ? _next : null,
                ),
              ),
            ),
      const SizedBox(height: 14),
    ],
  );

  void _next() {
    if (!_canNext) return;
    setState(() {
      _hint = null;
      _step = min(_step + 1, _total - 1);
    });
  }

  void _back() => setState(() {
    _hint = null;
    _step = max(_step - 1, 0);
  });

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _startAt,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 3),
      helpText: 'Дата события',
    );
    if (picked == null || !mounted) return;
    setState(
      () => _startAt = DateTime(
        picked.year,
        picked.month,
        picked.day,
        _startAt.hour,
        _startAt.minute,
      ),
    );
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_startAt),
      helpText: 'Время начала',
    );
    if (picked == null || !mounted) return;
    setState(
      () => _startAt = DateTime(
        _startAt.year,
        _startAt.month,
        _startAt.day,
        picked.hour,
        picked.minute,
      ),
    );
  }

  Future<void> _pickVideo() async {
    setState(() => _busy = true);
    try {
      final files = await FilePicker.pickFiles(
        type: FileType.video,
      );
      if (files.isEmpty) return;
      final file = files.first;
      final bytes = await file.readAsBytes();
      if (bytes.isEmpty) {
        _fail('Файл не читается — попробуй другой');
        return;
      }
      if (bytes.length > 50 * 1024 * 1024) {
        _fail('Видео больше 50 МБ');
        return;
      }
      final old = _video;
      if (old != null) await ref.read(repositoryProvider).removeMedia(old.id);
      final media = await ref.read(repositoryProvider).uploadMedia(
        _eventId,
        bytes,
        name: file.name,
        kind: MediaKind.video,
      );
      if (!mounted) return;
      setState(() {
        _video = media;
        _hint = null;
      });
    } catch (_) {
      _fail('Не удалось добавить видео');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _pickPhotos() async {
    setState(() => _busy = true);
    try {
      final room = 20 - _photos.length;
      if (room <= 0) {
        _fail('Не больше 20 фотографий');
        return;
      }
      final files = await FilePicker.pickFiles(
        type: FileType.image,
      );
      if (files.isEmpty) return;
      final added = <EventMedia>[];
      for (final file in files) {
        if (_photos.length + added.length >= 20) break;
        final bytes = await file.readAsBytes();
        if (bytes.isEmpty) continue;
        final media = await ref.read(repositoryProvider).uploadMedia(
          _eventId,
          bytes,
          name: file.name,
          kind: MediaKind.photo,
        );
        added.add(media);
      }
      if (added.isEmpty) {
        _fail('Ничего не выбрали');
        return;
      }
      if (!mounted) return;
      setState(() {
        _photos.addAll(added);
        _hint = null;
      });
      ToastController.show(
        context,
        added.length == room
            ? 'Добавлено ${added.length} · дальше лимит 20'
            : 'Добавлено фото: ${added.length}',
      );
    } catch (_) {
      _fail('Не удалось добавить фото');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _removeMedia(String id, {required bool isVideo}) async {
    try {
      await ref.read(repositoryProvider).removeMedia(id);
    } catch (_) {
      if (!mounted) return;
      _fail('Не удалось удалить файл');
      return;
    }
    if (!mounted) return;
    setState(() {
      if (isVideo) {
        _video = null;
      } else {
        _photos.removeWhere((m) => m.id == id);
      }
    });
  }

  void _fail(String message) => setState(() => _hint = message);

  Future<void> _publish() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _hint = null;
    });
    try {
      final repository = ref.read(repositoryProvider);
      final saved = await repository.saveDraft(_buildEvent(EventStatus.draft));
      final published = await repository.publish(saved.id);
      ref.read(revisionProvider.notifier).bump();
      if (!mounted) return;
      setState(() {
        _busy = false;
        _left = true;
        _resultEvent = published;
        _resultPublished = true;
      });
    } on AppException catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _hint = e.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _hint = 'Не удалось отправить событие на проверку';
      });
    }
  }

  Future<void> _saveDraft() async {
    if (_busy) return;
    if (!_hasContent) {
      if (!mounted) return;
      setState(() => _hint = 'Заполни название на первом шаге');
      return;
    }
    setState(() => _busy = true);
    final saved = await _persist(EventStatus.draft);
    if (!mounted) return;
    if (saved == null) {
      setState(() => _busy = false);
      return;
    }
    setState(() {
      _busy = false;
      _left = true;
      _resultEvent = saved;
      _resultPublished = false;
    });
  }

  Future<void> _saveAndExit() async {
    if (_left) {
      if (Navigator.of(context).canPop()) Navigator.of(context).pop();
      return;
    }
    if (_busy) {
      Navigator.of(context).pop();
      return;
    }
    if (!_hasContent) {
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _busy = true;
      _left = true;
    });
    final navigator = Navigator.of(context);
    await _persist(_status);
    if (!mounted) return;
    setState(() => _busy = false);
    navigator.pop();
  }

  Future<CampusEvent?> _persist(EventStatus status) async {
    try {
      final saved = await ref
          .read(repositoryProvider)
          .saveDraft(_buildEvent(status));
      ref.read(revisionProvider.notifier).bump();
      return saved;
    } on AppException catch (e) {
      if (!mounted) return null;
      setState(() => _hint = e.message);
    } catch (_) {
      if (!mounted) return null;
      setState(() => _hint = 'Черновик не сохранился');
    }
    return null;
  }

  String _bytesLabel(int bytes) =>
      bytes <= 0 ? '—' : '${(bytes / 1048576).toStringAsFixed(1)} МБ';

  String _durationLabel(int ms) => ms <= 0
      ? 'длительность не определилась'
      : '${(ms / 1000).toStringAsFixed(1)} сек';

  static EventCategory _categoryByLabel(String? label) => EventCategory.values
      .firstWhere((c) => c.label == label, orElse: () => EventCategory.contest);

  static FieldType _typeByLabel(String? label) => FieldType.values.firstWhere(
    (t) => t.label == label,
    orElse: () => FieldType.text,
  );
}

class _PickRow extends StatelessWidget {
  const _PickRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;
  final Future<void> Function() onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MicroLabel(label),
        InkWell(
          onTap: () => unawaited(onTap()),
          borderRadius: BorderRadius.circular(Scale.fieldRadius),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
            decoration: BoxDecoration(
              color: Palette.glassField,
              borderRadius: BorderRadius.circular(Scale.fieldRadius),
              border: Border.all(color: Palette.line),
            ),
            child: Row(
              children: [
                Icon(icon, size: 16, color: Palette.icon),
                const SizedBox(width: 11),
                Expanded(
                  child: Text(
                    value,
                    style: Fonts.sansStyle(size: 14, weight: 500),
                  ),
                ),
                const Icon(
                  Icons.expand_more_rounded,
                  size: 18,
                  color: Palette.icon,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class _FieldDraft {
  _FieldDraft({
    String? id,
    String label = '',
    String options = '',
  }) : id = id ?? Ids.next('fld') {
    labelCtrl.text = label;
    optionsCtrl.text = options;
  }

  _FieldDraft.fromField(CustomField field)
    : id = field.id,
      type = field.type,
      required = field.required {
    labelCtrl.text = field.label;
    optionsCtrl.text = field.options.join(', ');
  }

  final String id;
  final TextEditingController labelCtrl = TextEditingController();
  final TextEditingController optionsCtrl = TextEditingController();
  FieldType type = FieldType.text;
  bool required = true;

  void dispose() {
    labelCtrl.dispose();
    optionsCtrl.dispose();
  }

  CustomField toField(String eventId, int position) => CustomField(
    id: id,
    eventId: eventId,
    label: labelCtrl.text.trim(),
    type: type,
    options: _split(optionsCtrl.text),
    position: position,
    required: required,
  );

  static List<String> _split(String raw) => [
    for (final part in raw.split(RegExp(r'[,\n;]')))
      if (part.trim().isNotEmpty) part.trim(),
  ];
}
