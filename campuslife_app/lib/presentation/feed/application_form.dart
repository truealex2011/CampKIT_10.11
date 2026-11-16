import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../domain/entities.dart';
import 'media_pool.dart';
import '../entry/entry_widgets.dart' show GlassSelect;
import '../shared/kit.dart';

/// A form that collects answers to event fields for registration.
class ApplicationForm extends StatefulWidget {
  const ApplicationForm({
    super.key,
    required this.event,
    required this.onSubmit,
  });

  final CampusEvent event;
  final Future<void> Function(Map<String, String> answers) onSubmit;

  /// Shows the application form and returns true if submitted successfully.
  static Future<bool> show(
    BuildContext context, {
    required CampusEvent event,
    required Future<void> Function(Map<String, String> answers) onSubmit,
  }) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ApplicationForm(event: event, onSubmit: onSubmit),
    );
    return result ?? false;
  }

  @override
  State<ApplicationForm> createState() => _ApplicationFormState();
}

class _ApplicationFormState extends State<ApplicationForm> {
  final _controllers = <String, TextEditingController>{};
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    for (final field in widget.event.fields) {
      _controllers[field.id] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    // Validate required fields
    for (final field in widget.event.fields) {
      if (field.required) {
        final value = _controllers[field.id]?.text.trim() ?? '';
        if (value.isEmpty) {
          ToastController.show(
            context,
            'Заполни обязательное поле: ${field.label}',
            error: true,
          );
          return;
        }
      }
    }

    setState(() => _loading = true);

    try {
      final answers = <String, String>{};
      for (final field in widget.event.fields) {
        answers[field.id] = _controllers[field.id]?.text.trim() ?? '';
      }
      await widget.onSubmit(answers);
      if (mounted) {
        Navigator.of(context).pop(true);
        ToastController.show(context, 'Заявка отправлена!');
      }
    } catch (e) {
      if (mounted) {
        ToastController.show(
          context,
          e is Exception ? e.toString() : 'Не удалось отправить заявку',
          error: true,
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.85,
      ),
      decoration: BoxDecoration(
        color: context.colors.paper,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: context.colors.line)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              children: [
                Icon(
                  FeedVisuals.iconFor(widget.event.category),
                  size: 16,
                  color: FeedVisuals.colorFor(widget.event.category),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.event.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Fonts.sansStyle(size: 17, weight: 700),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  icon: Icon(Icons.close_rounded, color: context.colors.muted),
                ),
              ],
            ),
          ),
          const DividerLabel('анкета участника'),
          // Fields
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 16 + bottom),
              children: [
                Text(
                  'Чтобы записаться, заполни поля ниже. Организатор рассмотрит заявку.',
                  style: Fonts.sansStyle(
                    size: 13,
                    height: 1.4,
                    color: context.colors.muted,
                  ),
                ),
                const SizedBox(height: 12),
                for (final field in widget.event.fields) ...[
                  _FieldInput(
                    field: field,
                    controller: _controllers[field.id]!,
                  ),
                  const SizedBox(height: 12),
                ],
                if (widget.event.fields.isEmpty)
                  Text(
                    'Организатор не указал дополнительных полей.',
                    style: Fonts.sansStyle(
                      size: 13,
                      color: context.colors.muted,
                    ),
                  ),
                const SizedBox(height: 8),
                PrimaryButton(
                  label: 'Отправить заявку',
                  busy: _loading,
                  onPressed: _submit,
                ),
                const SizedBox(height: 8),
                GhostButton(
                  label: 'Отмена',
                  onPressed:
                      _loading ? null : () => Navigator.of(context).pop(false),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldInput extends StatelessWidget {
  const _FieldInput({
    required this.field,
    required this.controller,
  });

  final CustomField field;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final label = field.required ? '${field.label} *' : field.label;
    if (field.type == FieldType.choice) {
      return GlassSelect(
        label: label,
        value: controller.text.isEmpty ? null : controller.text,
        items: field.options,
        icon: _iconForType(field.type),
        placeholder: 'Выбери вариант',
        onChanged: (value) => controller.text = value ?? '',
      );
    }
    if (field.type == FieldType.yesNo) {
      return GlassSelect(
        label: label,
        value: controller.text.isEmpty ? null : controller.text,
        items: const ['Да', 'Нет'],
        icon: _iconForType(field.type),
        placeholder: 'Выбери ответ',
        onChanged: (value) => controller.text = value ?? '',
      );
    }
    return GlassField(
      label: label,
      controller: controller,
      hint: _hintForType(field.type),
      icon: _iconForType(field.type),
      maxLines: field.type == FieldType.text ? 3 : 1,
      keyboardType: field.type == FieldType.number
          ? TextInputType.number
          : field.type == FieldType.url
          ? TextInputType.url
          : TextInputType.text,
    );
  }

  String _hintForType(FieldType type) => switch (type) {
        FieldType.text => 'Введи текст',
        FieldType.number => 'Введи число',
        FieldType.url => 'https://...',
        FieldType.yesNo => 'Да или нет',
        FieldType.choice => 'Выбери вариант',
      };

  IconData _iconForType(FieldType type) => switch (type) {
        FieldType.text => Icons.text_fields_rounded,
        FieldType.number => Icons.pin_rounded,
        FieldType.url => Icons.link_rounded,
        FieldType.yesNo => Icons.check_circle_outline_rounded,
        FieldType.choice => Icons.list_rounded,
      };
}
