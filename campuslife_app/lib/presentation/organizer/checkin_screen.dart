import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../app/di.dart';
import '../../app/theme.dart';
import '../../domain/entities.dart';
import '../shared/kit.dart';

class CheckinScreen extends ConsumerStatefulWidget {
  const CheckinScreen({super.key, required this.eventId});

  final String eventId;

  @override
  ConsumerState<CheckinScreen> createState() => _CheckinScreenState();
}

class _CheckinScreenState extends ConsumerState<CheckinScreen> {
  MobileScannerController? _controller;
  bool _cameraBroken = false;
  bool _busy = false;
  String? _result;
  bool _resultError = false;
  DateTime? _lastScan;
  final TextEditingController _manual = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _cameraBroken = true;
      return;
    }
    try {
      _controller = MobileScannerController(
        detectionSpeed: DetectionSpeed.noDuplicates,
        formats: const [BarcodeFormat.qrCode],
      );
    } catch (_) {
      _controller = null;
      _cameraBroken = true;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _manual.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Scale.gutter(MediaQuery.sizeOf(context).width),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              MicroLabel('проход по qr'),
              Text(
                'Сканируй билет участника',
                style: Fonts.sansStyle(size: 20, weight: 700, height: 1.15),
              ),
              const SizedBox(height: 6),
              Text(
                'Событие: ${widget.eventId}',
                style: Fonts.monoStyle(size: 10, color: Palette.muted),
              ),
              const SizedBox(height: 12),
              if (_cameraBroken || _controller == null) ...[
                GlassCard(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.videocam_off_rounded,
                            size: 16,
                            color: Palette.rose,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Камера недоступна на этом устройстве. Введи код билета вручную ниже.',
                              style: Fonts.sansStyle(
                                size: 12.5,
                                height: 1.4,
                                color: Palette.ink2,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ] else
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      Scale.cardRadiusNarrow,
                    ),
                    child: MobileScanner(
                      controller: _controller!,
                      onDetect: _onDetect,
                      errorBuilder: (context, error) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted && !_cameraBroken) {
                            setState(() => _cameraBroken = true);
                          }
                        });
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
              const SizedBox(height: 10),
              if (_result != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    color: _resultError
                        ? Palette.rose.withValues(alpha: 0.1)
                        : Palette.mint.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(Scale.fieldRadius),
                    border: Border.all(
                      color: _resultError ? Palette.roseLine : Palette.mint,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _resultError
                            ? Icons.error_outline_rounded
                            : Icons.check_circle_outline_rounded,
                        size: 16,
                        color: _resultError ? Palette.rose : Palette.mint,
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: Text(
                          _result!,
                          style: Fonts.sansStyle(
                            size: 12.5,
                            weight: 500,
                            color: _resultError ? Palette.rose : Palette.mint,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
              GlassField(
                label: 'код билета вручную',
                controller: _manual,
                hint: 'eventId:userId',
                icon: Icons.confirmation_number_outlined,
                onChanged: (_) {
                  if (_result != null) setState(() => _result = null);
                },
              ),
              PrimaryButton(
                label: 'Проверить',
                icon: Icons.how_to_reg_rounded,
                arrow: false,
                busy: _busy,
                onPressed: _busy
                    ? null
                    : () => unawaited(_process(_manual.text, manual: true)),
              ),
              if (_cameraBroken || _controller == null) ...[
                const SizedBox(height: 12),
                Text(
                  'Код билета совпадает с QR: eventId:userId. Отметка о проходе сохраняется сразу и попадает в статистику события.',
                  style: Fonts.monoStyle(size: 10, color: Palette.muted),
                ),
              ],
              const SizedBox(height: 14),
            ],
          ),
        ),
      ),
    );
  }

  void _onDetect(BarcodeCapture capture) {
    if (capture.barcodes.isEmpty) return;
    final code = capture.barcodes.first.rawValue;
    if (code == null || code.trim().isEmpty) return;
    final now = DateTime.now();
    if (_lastScan != null && now.difference(_lastScan!).inMilliseconds < 1500) {
      return;
    }
    _lastScan = now;
    unawaited(_process(code));
  }

  Future<void> _process(String raw, {bool manual = false}) async {
    if (_busy) return;
    var code = raw.trim();
    if (code.isEmpty) {
      setState(() {
        _result = 'Введи код билета';
        _resultError = true;
      });
      return;
    }
    if (!code.contains(':')) code = '${widget.eventId}:$code';
    setState(() => _busy = true);
    try {
      final registration = await ref.read(repositoryProvider).checkIn(code);
      ref.read(revisionProvider.notifier).bump();
      if (!mounted) return;
      setState(() {
        _busy = false;
        _resultError = registration == null;
        _result = registration == null
            ? 'Не найдена запись с кодом $code'
            : 'Пришёл: ${registration.userId}';
        if (manual) _manual.clear();
      });
    } on AppException catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _resultError = true;
        _result = e.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _resultError = true;
        _result = 'Не удалось проверить код';
      });
    }
  }
}
