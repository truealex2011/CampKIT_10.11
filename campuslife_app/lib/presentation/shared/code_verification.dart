import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme.dart';
import 'kit.dart';

/// A dialog that asks for a verification code.
/// For demo purposes, the code is always "0000".
class CodeVerificationDialog extends StatefulWidget {
  const CodeVerificationDialog({
    super.key,
    required this.title,
    required this.description,
    this.codeLength = 4,
  });

  final String title;
  final String description;
  final int codeLength;

  /// Shows the verification dialog and returns true if the code is correct.
  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String description,
    int codeLength = 4,
  }) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CodeVerificationDialog(
        title: title,
        description: description,
        codeLength: codeLength,
      ),
    );
    return result ?? false;
  }

  @override
  State<CodeVerificationDialog> createState() => _CodeVerificationDialogState();
}

class _CodeVerificationDialogState extends State<CodeVerificationDialog> {
  final _controller = TextEditingController();
  bool _loading = false;
  bool _error = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    if (_controller.text.length != widget.codeLength) {
      setState(() => _error = true);
      return;
    }

    setState(() {
      _loading = true;
      _error = false;
    });

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Demo: code is always "0000"
    final success = _controller.text == '0' * widget.codeLength;

    if (mounted) {
      if (success) {
        Navigator.of(context).pop(true);
      } else {
        setState(() {
          _loading = false;
          _error = true;
        });
        HapticFeedback.heavyImpact();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 16 + bottom),
      decoration: BoxDecoration(
        color: context.colors.paper,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: context.colors.line)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.title,
            style: Fonts.sansStyle(size: 17, weight: 700),
          ),
          const SizedBox(height: 4),
          Text(
            widget.description,
            style: Fonts.sansStyle(size: 13, color: context.colors.muted),
          ),
          const SizedBox(height: 16),
          _CodeInput(
            controller: _controller,
            length: widget.codeLength,
            error: _error,
            onChanged: () {
              if (_error) setState(() => _error = false);
            },
          ),
          if (_error) ...[
            const SizedBox(height: 8),
            Text(
              'Неверный код. Попробуй 0000',
              style: Fonts.sansStyle(size: 12, color: context.colors.rose),
            ),
          ],
          const SizedBox(height: 16),
          PrimaryButton(
            label: 'Подтвердить',
            busy: _loading,
            onPressed: _verify,
          ),
          const SizedBox(height: 8),
          GhostButton(
            label: 'Отмена',
            onPressed: _loading ? null : () => Navigator.of(context).pop(false),
          ),
        ],
      ),
    );
  }
}

class _CodeInput extends StatelessWidget {
  const _CodeInput({
    required this.controller,
    required this.length,
    required this.error,
    required this.onChanged,
  });

  final TextEditingController controller;
  final int length;
  final bool error;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      maxLength: length,
      style: Fonts.monoStyle(size: 24, weight: 600, letterSpacing: 8),
      decoration: InputDecoration(
        counterText: '',
        hintText: '0' * length,
        hintStyle: Fonts.monoStyle(
          size: 24,
          weight: 600,
          letterSpacing: 8,
          color: context.colors.muted.withValues(alpha: 0.3),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: error ? context.colors.rose : context.colors.line,
            width: 2,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: error ? context.colors.rose : context.colors.accent,
            width: 2,
          ),
        ),
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: (_) => onChanged(),
    );
  }
}
