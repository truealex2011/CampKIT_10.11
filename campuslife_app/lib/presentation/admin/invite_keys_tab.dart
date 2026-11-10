import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/di.dart';
import '../../app/theme.dart';
import '../../domain/entities.dart';
import '../entry/entry_widgets.dart';
import '../shared/kit.dart';
import 'admin_common.dart';

class InviteKeysTab extends ConsumerStatefulWidget {
  const InviteKeysTab({super.key});

  @override
  ConsumerState<InviteKeysTab> createState() => _InviteKeysTabState();
}

class _InviteKeysTabState extends ConsumerState<InviteKeysTab> {
  final TextEditingController _value = TextEditingController();

  InviteKey? _issued;
  bool _busy = false;

  @override
  void dispose() {
    _value.dispose();
    super.dispose();
  }

  Future<void> _mint() async {
    setState(() => _busy = true);
    InviteKey? minted;
    try {
      minted = await ref.read(repositoryProvider).mintInviteKey();
      ref.read(revisionProvider.notifier).bump();
    } on Object catch (error) {
      if (mounted) {
        ToastController.show(
          context,
          AdminUi.failureMessage(error),
          error: true,
        );
      }
    }
    if (!mounted) return;
    setState(() {
      _busy = false;
      _issued = minted;
    });
    if (minted == null) return;
    _value.text = minted.plainKey ?? minted.keyHash;
    ToastController.show(
      context,
      'Ключ выпущен. Покажи его организатору один раз — в базе остаётся только хеш.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final keys = ref.watch(inviteKeysProvider);
    return ListView(
      padding: AdminUi.page(context),
      children: [
        AdminCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const MicroLabel('Выдача ключа организатора'),
              PrimaryButton(
                label: 'Выдать ключ',
                busy: _busy,
                arrow: false,
                icon: Icons.vpn_key_rounded,
                onPressed: _busy ? null : _mint,
              ),
              const SizedBox(height: 8),
              const NoteBlock(
                lead: 'Как это работает:',
                text:
                    'Организатор вводит ключ при регистрации. Значение выдаётся один раз и не хранится в открытом виде — '
                    'в локальной базе лежит только хеш, поэтому повторный показ невозможен. Лимита на число ключей в требованиях нет.',
              ),
              if (_issued != null) ...[
                const SizedBox(height: 4),
                _IssuedCard(
                  invite: _issued!,
                  controller: _value,
                  onCopy: () =>
                      adminCopy(context, _value.text, done: 'Ключ скопирован'),
                ),
              ],
            ],
          ),
        ),
        keys.when(
          loading: () => const AdminLoading(text: 'Читаем список ключей…'),
          error: (error, _) => AdminFailure(
            message: AdminUi.failureMessage(error),
            onRetry: () => ref.invalidate(inviteKeysProvider),
          ),
          data: (list) => _KeysTable(keys: list),
        ),
      ],
    );
  }
}

class _IssuedCard extends StatelessWidget {
  const _IssuedCard({
    required this.invite,
    required this.controller,
    required this.onCopy,
  });

  final InviteKey invite;
  final TextEditingController controller;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(top: 6),
    padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
    decoration: BoxDecoration(
      color: Palette.accentSoft,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Palette.accentLine),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MicroLabel('только что выдан · id ${invite.id}'),
        GlassField(
          label: 'ключ · показывается один раз',
          controller: controller,
          icon: Icons.key_rounded,
          enabled: false,
          suffixIcon: Icons.copy_rounded,
          onSuffixTap: onCopy,
        ),
        AdminKeyValue(label: 'Идентификатор', value: invite.id),
        AdminKeyValue(
          label: 'Статус',
          value: invite.used ? 'Использован' : 'Не активирован',
          color: invite.used ? Palette.mint : Palette.gold,
        ),
        AdminKeyValue(
          label: 'Попытки',
          value: '${invite.attempts} из ${InviteKey.maxAttempts}',
        ),
        if (invite.orgId != null)
          AdminKeyValue(label: 'Организация', value: invite.orgId!),
        Text(
          'Одноразовый ключ. Выдан один раз, в базе хранится только хеш.',
          style: Fonts.sansStyle(size: 11.5, height: 1.45, color: Palette.ink2),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 2, bottom: 4),
            child: TextLink('Скопировать ключ', onTap: onCopy),
          ),
        ),
      ],
    ),
  );
}

class _KeysTable extends StatelessWidget {
  const _KeysTable({required this.keys});

  final List<InviteKey> keys;

  @override
  Widget build(BuildContext context) {
    final sorted = [...keys]
      ..sort((a, b) {
        final left = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final right = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return right.compareTo(left);
      });
    final free = keys.where((k) => !k.used).length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DividerLabel('все ключи · свободно $free из ${keys.length}'),
        AdminCard(
          child: sorted.isEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Ключей ещё нет',
                      style: Fonts.sansStyle(
                        size: 13.5,
                        weight: 600,
                        color: Palette.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const NoteBlock(
                      text:
                          'Выпусти первый ключ — он понадобится новому организатору при регистрации.',
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _TableHead(),
                    for (final item in sorted) _TableRow(invite: item),
                  ],
                ),
        ),
      ],
    );
  }
}

class _TableHead extends StatelessWidget {
  const _TableHead();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: const [
        _HeadCell(text: 'ID', flex: 4),
        _HeadCell(text: 'СОСТОЯНИЕ', flex: 5),
        _HeadCell(text: 'ПОПЫТКИ', flex: 3),
        _HeadCell(text: 'ОРГАНИЗАЦИЯ', flex: 3, last: true),
      ],
    ),
  );
}

class _HeadCell extends StatelessWidget {
  const _HeadCell({required this.text, required this.flex, this.last = false});

  final String text;
  final int flex;
  final bool last;

  @override
  Widget build(BuildContext context) => Expanded(
    flex: flex,
    child: Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: last ? TextAlign.right : TextAlign.left,
      style: Fonts.monoStyle(
        size: 8.5,
        weight: 600,
        letterSpacing: 0.12 * 8.5,
        color: Palette.placeholder,
      ),
    ),
  );
}

class _TableRow extends StatelessWidget {
  const _TableRow({required this.invite});

  final InviteKey invite;

  @override
  Widget build(BuildContext context) {
    final exhausted = invite.attempts >= InviteKey.maxAttempts;
    final color = invite.used
        ? Palette.mint
        : exhausted
        ? Palette.rose
        : Palette.gold;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Palette.line2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: _Cell(
              text: invite.id,
              hint: invite.createdAt == null
                  ? 'дата не записана'
                  : AdminDate.stamp(invite.createdAt!),
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.only(top: 1),
              child: AdminTag(
                text: invite.used ? 'АКТИВИРОВАН' : 'СВОБОДЕН',
                color: color,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              '${invite.attempts}/${InviteKey.maxAttempts}',
              style: Fonts.monoStyle(
                size: 11,
                weight: exhausted ? 600 : 400,
                color: exhausted ? Palette.rose : Palette.ink2,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              invite.orgId ?? '—',
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Fonts.monoStyle(size: 9.5, color: Palette.muted),
            ),
          ),
        ],
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({required this.text, required this.hint});

  final String text;
  final String hint;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Fonts.monoStyle(size: 10, color: Palette.ink),
      ),
      Text(
        hint,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Fonts.monoStyle(size: 8.5, color: Palette.placeholder),
      ),
    ],
  );
}
