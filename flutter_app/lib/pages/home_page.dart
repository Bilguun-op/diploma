import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/store_provider.dart';
import '../providers/i18n_provider.dart';
import '../models/content.dart';
import '../widgets/quiz_runner.dart';
import '../app/theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer? _timer;
  int _seconds = 0;
  bool _running = false;
  bool _placementOpen = false;
  int? _openLevel;
  ActiveModule? _active;
  int? _levelTestFor;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggleTimer() {
    setState(() {
      _running = !_running;
    });
    if (_running) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _seconds++;
          if (_seconds % 60 == 0) {
            context.read<StoreProvider>().addStudyMinutes(1);
          }
        });
      });
    } else {
      _timer?.cancel();
    }
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _seconds = 0;
      _running = false;
    });
  }

  String _formatTime(int s) {
    final m = s ~/ 60;
    final sec = s % 60;
    return '${m.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final i18n = context.watch<I18nProvider>();
    final store = context.watch<StoreProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero greeting
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${i18n.t('greeting')}, ${store.user.name}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme._mutedForeground,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    i18n.t('home'),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme._card.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme._border.withOpacity(0.6)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.emoji_events, size: 16, color: AppTheme._amber),
                    const SizedBox(width: 8),
                    Text(
                      '${store.user.exp}',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      i18n.t('totalExp'),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme._mutedForeground,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Placement banner + study tracker
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildPlacementCard(context, i18n),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStudyTracker(context, i18n, store),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Roadmap
          Text(
            i18n.t('levels'),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          ...List.generate(5, (lvlIdx) {
            final status = store.user.levelStatuses[lvlIdx];
            final isOpen = _openLevel == lvlIdx;
            final locked = status == LevelStatus.locked;
            final completedUnits = store.user.unitsCompleted[lvlIdx].where((u) => u >= 3).length;
            final allDone = completedUnits == 5;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              color: AppTheme._card.withOpacity(locked ? 0.6 : 0.8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: locked
                      ? AppTheme._border.withOpacity(0.4)
                      : AppTheme._border.withOpacity(0.6),
                ),
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: locked
                        ? null
                        : () {
                            setState(() {
                              _openLevel = isOpen ? null : lvlIdx;
                            });
                          },
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: status == LevelStatus.completed
                                  ? AppTheme._emerald.withOpacity(0.2)
                                  : status == LevelStatus.unlocked
                                      ? null
                                      : AppTheme._muted,
                              gradient: status == LevelStatus.unlocked
                                  ? AppTheme.heroGradient
                                  : null,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: status == LevelStatus.locked
                                  ? const Icon(Icons.lock, size: 20, color: AppTheme._mutedForeground)
                                  : status == LevelStatus.completed
                                      ? const Icon(Icons.check, size: 20, color: Color(0xFF6EE7B7))
                                      : Text(
                                          '${lvlIdx + 1}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme._primaryForeground,
                                          ),
                                        ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${i18n.t('level')} ${lvlIdx + 1}',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                Text(
                                  '$completedUnits/5 ${i18n.t('unit')} · ${status == LevelStatus.locked ? i18n.t('locked') : status == LevelStatus.completed ? i18n.t('completed') : i18n.t('unlocked')}',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppTheme._mutedForeground,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          if (!locked)
                            Icon(
                              Icons.expand_more,
                              size: 16,
                              color: AppTheme._mutedForeground,
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (isOpen && !locked) ...[
                    const Divider(height: 1, color: AppTheme._border),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          ...List.generate(5, (unitIdx) {
                            final done = store.user.unitsCompleted[lvlIdx][unitIdx];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              color: AppTheme._background.withOpacity(0.4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: AppTheme._border.withOpacity(0.4)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${i18n.t('unit')} ${unitIdx + 1}',
                                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                        Text(
                                          '$done/3',
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                color: AppTheme._mutedForeground,
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        _buildModuleButton(
                                          context,
                                          Icons.menu_book,
                                          i18n.t('reading'),
                                          done > 0,
                                          () => setState(() {
                                            _active = ActiveModule(level: lvlIdx, unit: unitIdx, kind: 'reading');
                                          }),
                                        ),
                                        const SizedBox(width: 8),
                                        _buildModuleButton(
                                          context,
                                          Icons.psychology,
                                          i18n.t('grammar'),
                                          done > 1,
                                          () => setState(() {
                                            _active = ActiveModule(level: lvlIdx, unit: unitIdx, kind: 'grammar');
                                          }),
                                        ),
                                        const SizedBox(width: 8),
                                        _buildModuleButton(
                                          context,
                                          Icons.auto_awesome,
                                          i18n.t('vocabulary'),
                                          done > 2,
                                          () => setState(() {
                                            _active = ActiveModule(level: lvlIdx, unit: unitIdx, kind: 'vocab');
                                          }),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: allDone
                                  ? () {
                                      setState(() {
                                        _levelTestFor = lvlIdx;
                                      });
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme._amber,
                                foregroundColor: AppTheme._amberForeground,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.emoji_events, size: 16),
                                  const SizedBox(width: 8),
                                  Text(i18n.t('levelTest')),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPlacementCard(BuildContext context, I18nProvider i18n) {
    return InkWell(
      onTap: () {
        setState(() {
          _placementOpen = true;
        });
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: AppTheme.heroGradient,
          borderRadius: BorderRadius.circular(24),
          boxShadow: AppTheme.glowShadow,
        ),
        child: Stack(
          children: [
            Positioned(
              right: -24,
              top: -24,
              child: Container(
                width: 128,
                height: 128,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.auto_awesome, color: AppTheme._primaryForeground, size: 24),
                const SizedBox(height: 12),
                Text(
                  i18n.t('placementTest'),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppTheme._primaryForeground,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  i18n.t('placementDesc'),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme._primaryForeground.withOpacity(0.8),
                      ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme._background.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${i18n.t('startTest')} →',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppTheme._primaryForeground,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudyTracker(BuildContext context, I18nProvider i18n, StoreProvider store) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: AppTheme._border.withOpacity(0.6)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              i18n.t('dailyStudy'),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    letterSpacing: 1.5,
                    color: AppTheme._mutedForeground,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              _formatTime(_seconds),
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: AppTheme._accent,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              '${store.user.studyMinutes} ${i18n.t('minutesToday')}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme._mutedForeground,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _toggleTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _running ? AppTheme._secondary : AppTheme._primary,
                    foregroundColor: AppTheme._primaryForeground,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  child: Row(
                    children: [
                      Icon(_running ? Icons.pause : Icons.play_arrow, size: 12),
                      const SizedBox(width: 4),
                      Text(_running ? i18n.t('pause') : i18n.t('start')),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: _resetTimer,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.refresh, size: 12),
                      const SizedBox(width: 4),
                      Text(i18n.t('reset')),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleButton(
    BuildContext context,
    IconData icon,
    String label,
    bool isDone,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isDone
                ? AppTheme._emerald.withOpacity(0.1)
                : AppTheme._muted.withOpacity(0.4),
            border: Border.all(
              color: isDone
                  ? AppTheme._emerald.withOpacity(0.4)
                  : AppTheme._border.withOpacity(0.5),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 16,
                color: isDone ? const Color(0xFF6EE7B7) : AppTheme._foreground,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDone ? const Color(0xFF6EE7B7) : AppTheme._foreground,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Show modals if they're open
    if (_placementOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showPlacementModal(context);
      });
    }
    if (_active != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showModuleModal(context);
      });
    }
    if (_levelTestFor != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showLevelTestModal(context);
      });
    }
  }

  void _showPlacementModal(BuildContext context) {
    final i18n = context.read<I18nProvider>();
    final store = context.read<StoreProvider>();

    showDialog(
      context: context,
      barrierColor: AppTheme._background.withOpacity(0.8),
      builder: (context) => AlertDialog(
        title: Text(i18n.t('placementTest')),
        content: SizedBox(
          width: double.maxFinite,
          child: QuizRunner(
            pool: Content.placementQuestions,
            count: 12,
            onDone: (score, total) {
              final level = (4).clamp(0, (score / 3).floor() - 1 + 1);
              store.setPlacementLevel(level);
              setState(() {
                _placementOpen = false;
              });
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    ).then((_) {
      setState(() {
        _placementOpen = false;
      });
    });
  }

  void _showModuleModal(BuildContext context) {
    final i18n = context.read<I18nProvider>();
    final store = context.read<StoreProvider>();
    final active = _active!;

    showDialog(
      context: context,
      barrierColor: AppTheme._background.withOpacity(0.8),
      builder: (context) => AlertDialog(
        title: Text('${i18n.t('level')} ${active.level + 1} · ${i18n.t('unit')} ${active.unit + 1}'),
        content: SizedBox(
          width: double.maxFinite,
          child: ModuleRunner(
            kind: active.kind,
            onComplete: () {
              store.completeModule(active.level, active.unit);
              setState(() {
                _active = null;
              });
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    ).then((_) {
      setState(() {
        _active = null;
      });
    });
  }

  void _showLevelTestModal(BuildContext context) {
    final i18n = context.read<I18nProvider>();
    final store = context.read<StoreProvider>();
    final levelTestFor = _levelTestFor!;

    showDialog(
      context: context,
      barrierColor: AppTheme._background.withOpacity(0.8),
      builder: (context) => AlertDialog(
        title: Text('${i18n.t('levelTest')} — ${i18n.t('level')} ${levelTestFor + 1}'),
        content: SizedBox(
          width: double.maxFinite,
          child: QuizRunner(
            pool: Content.pickRandom(
              Content.grammarQuizzes.values.expand((e) => e).toList(),
              10,
            ),
            count: 10,
            onDone: (score, total) {
              final pass = score / total >= 0.7;
              if (pass) {
                store.setLevelStatus(levelTestFor, LevelStatus.completed);
                store.addExp(50);
              }
              setState(() {
                _levelTestFor = null;
              });
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    ).then((_) {
      setState(() {
        _levelTestFor = null;
      });
    });
  }
}

class ActiveModule {
  final int level;
  final int unit;
  final String kind;

  ActiveModule({
    required this.level,
    required this.unit,
    required this.kind,
  });
}

class ModuleRunner extends StatelessWidget {
  final String kind;
  final VoidCallback onComplete;

  const ModuleRunner({
    super.key,
    required this.kind,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final i18n = context.watch<I18nProvider>();

    if (kind == 'reading') {
      final passage = Content.pickRandom(Content.readingPassages, 1).first;
      return Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    passage.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme._accent,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    passage.text,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme._mutedForeground,
                          height: 1.5,
                        ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          QuizRunner(
            pool: passage.questions,
            count: 3,
            onDone: (score, total) => onComplete(),
          ),
        ],
      );
    }

    if (kind == 'grammar') {
      final pool = Content.pickRandom(
        Content.grammarQuizzes.values.expand((e) => e).toList(),
        12,
      );
      return QuizRunner(
        pool: pool,
        count: 5,
        onDone: (score, total) => onComplete(),
      );
    }

    // vocab matching
    final items = Content.pickRandom(Content.vocabPool, 5);
    final pool = items.map((it) {
      final others = Content.pickRandom(
        Content.vocabPool.where((v) => v.word != it.word).toList(),
        3,
      );
      final options = Content.pickRandom([it.def, ...others.map((v) => v.def)], 4);
      return QuizQ(
        q: '"${it.word}" — ${i18n.t('vocabulary')}',
        options: options,
        answer: options.indexOf(it.def),
      );
    }).toList();

    return QuizRunner(
      pool: pool,
      count: 5,
      onDone: (score, total) => onComplete(),
    );
  }
}
