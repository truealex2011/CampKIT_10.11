import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/theme.dart';
import 'app_icons.dart';
import 'glass_sheet.dart';
import 'kit.dart';

/// Keys for onboarding state.
const _kOnboardingCompleted = 'onboarding_completed';
const _kFishEnabled = 'fish_enabled';

/// Returns whether the onboarding has been completed.
Future<bool> isOnboardingCompleted() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(_kOnboardingCompleted) ?? false;
}

/// Marks the onboarding as completed.
Future<void> completeOnboarding() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_kOnboardingCompleted, true);
}

/// Returns whether fish animation is enabled in the ocean backdrop.
Future<bool> isFishEnabled() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(_kFishEnabled) ?? true;
}

/// Sets whether fish animation is enabled.
Future<void> setFishEnabled(bool enabled) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_kFishEnabled, enabled);
}

/// The onboarding tutorial that teaches users how to interact with the feed.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _step = 0;
  bool _taskCompleted = false;

  static const _steps = [
    _OnboardingStep(
      title: 'Добро пожаловать!',
      description: 'Проведи по экрану, чтобы листать события.',
      task: 'Сделай свайп вверх или вниз',
      icon: null,
    ),
    _OnboardingStep(
      title: 'Напоминания',
      description: 'Нажми на колокольчик, чтобы не пропустить событие.',
      task: 'Нажми кнопку напоминания',
      icon: 'reminder',
    ),
    _OnboardingStep(
      title: 'Лайки и запись',
      description:
          'Нажми на сердце, чтобы сохранить событие. Зажми и потяни влево, чтобы записаться.',
      task: 'Попробуй нажать или зажать сердце',
      icon: 'like',
    ),
    _OnboardingStep(
      title: 'Описание',
      description: 'Узнай подробности о событии — где, когда и что будет.',
      task: 'Открой описание события',
      icon: 'description',
    ),
    _OnboardingStep(
      title: 'Поделись с друзьями',
      description: 'Отправь QR-код или ссылку на событие друзьям.',
      task: 'Нажми кнопку поделиться',
      icon: 'share',
    ),
    _OnboardingStep(
      title: 'Жалоба',
      description: 'Если что-то не так, сообщи модераторам.',
      task: 'Открой форму жалобы',
      icon: 'report',
    ),
    _OnboardingStep(
      title: 'Готово!',
      description:
          'Теперь ты знаешь, как пользоваться приложением. Удачи на мероприятиях!',
      task: null,
      icon: null,
    ),
  ];

  void _completeTask() {
    if (!_taskCompleted && _steps[_step].task != null) {
      setState(() => _taskCompleted = true);
      HapticFeedback.mediumImpact();
    }
  }

  void _nextStep() {
    if (_step < _steps.length - 1) {
      setState(() {
        _step++;
        _taskCompleted = false;
      });
      HapticFeedback.lightImpact();
    } else {
      _finish();
    }
  }

  void _skip() => _finish();

  Future<void> _finish() async {
    await completeOnboarding();
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final step = _steps[_step];
    return Scaffold(
      backgroundColor: Palette.ink,
      body: Stack(
        children: [
          // Mock feed background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0A1628),
                  Color(0xFF0D2137),
                  Color(0xFF081320),
                ],
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: _buildMockFeed(step),
                ),
                // Bottom panel
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    border: Border(
                      top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Progress dots
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _steps.length,
                          (i) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: i == _step ? 20 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: i <= _step
                                  ? Palette.accent
                                  : Colors.white.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Title and description
                      Text(
                        step.title,
                        textAlign: TextAlign.center,
                        style: Fonts.sansStyle(
                          size: 20,
                          weight: 700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        step.description,
                        textAlign: TextAlign.center,
                        style: Fonts.sansStyle(
                          size: 14,
                          height: 1.4,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                      if (step.task != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: _taskCompleted
                                ? Palette.mint.withValues(alpha: 0.2)
                                : Palette.accent.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _taskCompleted
                                  ? Palette.mint
                                  : Palette.accent.withValues(alpha: 0.5),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _taskCompleted
                                    ? Icons.check_circle_rounded
                                    : Icons.assignment_rounded,
                                size: 16,
                                color: _taskCompleted
                                    ? Palette.mint
                                    : Palette.accent,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _taskCompleted ? 'Выполнено!' : step.task!,
                                style: Fonts.sansStyle(
                                  size: 12.5,
                                  weight: _taskCompleted ? 600 : 400,
                                  color: _taskCompleted
                                      ? Palette.mint
                                      : Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      // Buttons
                      Row(
                        children: [
                          if (_step > 0 && _step < _steps.length - 1)
                            Expanded(
                              child: GhostButton(
                                label: 'Пропустить',
                                onPressed: _skip,
                              ),
                            ),
                          if (_step > 0 && _step < _steps.length - 1)
                            const SizedBox(width: 12),
                          Expanded(
                            flex: _step == 0 || _step == _steps.length - 1 ? 1 : 2,
                            child: PrimaryButton(
                              label: _step == _steps.length - 1
                                  ? 'Начать'
                                  : 'Далее',
                              onPressed: step.task == null || _taskCompleted
                                  ? _nextStep
                                  : null,
                              arrow: _step == _steps.length - 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMockFeed(_OnboardingStep step) {
    return Stack(
      children: [
        // Mock event card
        Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.event_rounded,
                  size: 48,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 12),
                Text(
                  'Пример события',
                  style: Fonts.sansStyle(
                    size: 18,
                    weight: 600,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Это демонстрационный экран',
                  style: Fonts.sansStyle(
                    size: 13,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Right rail with action buttons
        Positioned(
          right: 12,
          bottom: 100,
          child: _buildMockRail(step),
        ),
      ],
    );
  }

  Widget _buildMockRail(_OnboardingStep step) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildMockButton('reminder', step),
        const SizedBox(height: Scale.railGap),
        _buildMockButton('like', step),
        const SizedBox(height: Scale.railGap),
        _buildMockButton('description', step),
        const SizedBox(height: Scale.railGap),
        _buildMockButton('share', step),
        const SizedBox(height: Scale.railGap),
        _buildMockButton('report', step),
      ],
    );
  }

  Widget _buildMockButton(String name, _OnboardingStep step) {
    final isCurrent = step.icon == name;
    final iconPath = switch (name) {
      'reminder' => AppIcons.reminderLight,
      'like' => AppIcons.likeLight,
      'description' => AppIcons.descriptionLight,
      'share' => AppIcons.shareLight,
      'report' => AppIcons.reportLight,
      _ => null,
    };

    return GestureDetector(
      onTap: isCurrent ? _completeTask : null,
      onLongPress: name == 'like' && isCurrent ? _completeTask : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: Scale.railIcon,
        height: Scale.railIcon,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isCurrent
              ? Palette.accent.withValues(alpha: 0.9)
              : Colors.white.withValues(alpha: 0.12),
          border: Border.all(
            color: isCurrent
                ? Palette.accent
                : Colors.white.withValues(alpha: 0.24),
            width: isCurrent ? 2 : 1,
          ),
          boxShadow: isCurrent
              ? [
                  BoxShadow(
                    color: Palette.accent.withValues(alpha: 0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: iconPath != null
            ? Center(
                child: Image.asset(
                  iconPath,
                  width: 22,
                  height: 22,
                  color: Colors.white,
                  colorBlendMode: BlendMode.srcIn,
                ),
              )
            : null,
      ),
    );
  }
}

class _OnboardingStep {
  const _OnboardingStep({
    required this.title,
    required this.description,
    required this.task,
    required this.icon,
  });

  final String title;
  final String description;
  final String? task;
  final String? icon;
}

/// Shows the onboarding if it hasn't been completed yet.
Future<void> showOnboardingIfNeeded(BuildContext context) async {
  if (await isOnboardingCompleted()) return;
  if (!context.mounted) return;
  await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => const OnboardingScreen(),
      fullscreenDialog: true,
    ),
  );
}
