import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/store_provider.dart';
import '../providers/i18n_provider.dart';
import '../models/content.dart';
import '../widgets/quiz_runner.dart';
import '../app/theme.dart';

class ArcadePage extends StatefulWidget {
  const ArcadePage({super.key});

  @override
  State<ArcadePage> createState() => _ArcadePageState();
}

class _ArcadePageState extends State<ArcadePage> {
  String _game = 'menu';

  @override
  Widget build(BuildContext context) {
    final i18n = context.watch<I18nProvider>();
    final store = context.watch<StoreProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            i18n.t('arcadeTitle'),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.games, size: 16),
              const SizedBox(width: 4),
              Text(
                '+10 EXP ${i18n.t('correct')}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme._mutedForeground,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (_game == 'menu')
            Row(
              children: [
                Expanded(
                  child: _buildGameCard(
                    context,
                    i18n,
                    Icons.shuffle,
                    i18n.t('wordScramble'),
                    i18n.t('scrambleDesc'),
                    'primary',
                    () => setState(() => _game = 'scramble'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildGameCard(
                    context,
                    i18n,
                    Icons.extension,
                    i18n.t('wordPuzzle'),
                    i18n.t('puzzleDesc'),
                    'accent',
                    () => setState(() => _game = 'puzzle'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildGameCard(
                    context,
                    i18n,
                    Icons.bolt,
                    i18n.t('syntaxBlaster'),
                    i18n.t('blasterDesc'),
                    'amber',
                    () => setState(() => _game = 'blaster'),
                  ),
                ),
              ],
            ),
          if (_game != 'menu') ...[
            OutlinedButton.icon(
              onPressed: () => setState(() => _game = 'menu'),
              icon: const Icon(Icons.arrow_back),
              label: Text(i18n.t('back')),
            ),
            const SizedBox(height: 16),
            if (_game == 'scramble') const WordScramble(),
            if (_game == 'puzzle') const WordPuzzle(),
            if (_game == 'blaster')
              QuizRunner(
                pool: Content.blasterQuestions,
                count: 8,
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildGameCard(
    BuildContext context,
    I18nProvider i18n,
    IconData icon,
    String title,
    String desc,
    String color,
    VoidCallback onTap,
  ) {
    BoxDecoration? decoration;
    if (color == 'primary') {
      decoration = AppTheme.heroGradient.copyWith(
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppTheme.glowShadow,
      );
    } else if (color == 'accent') {
      decoration = BoxDecoration(
        color: AppTheme._accent,
        borderRadius: BorderRadius.circular(24),
      );
    } else {
      decoration = AppTheme.amberGradient.copyWith(
        borderRadius: BorderRadius.circular(24),
      );
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme._card,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppTheme._border.withOpacity(0.6)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: decoration?.copyWith(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color == 'accent' ? AppTheme._accentForeground : AppTheme._primaryForeground),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              desc,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme._mutedForeground,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              '${i18n.t('play')} →',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppTheme._primary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class WordScramble extends StatefulWidget {
  const WordScramble({super.key});

  @override
  State<WordScramble> createState() => _WordScrambleState();
}

class _WordScrambleState extends State<WordScramble> {
  int _round = 0;
  late List<String> _pool;
  late List<String> _built;
  bool? _done;

  @override
  void initState() {
    super.initState();
    _initRound();
  }

  void _initRound() {
    final sentence = Content.pickRandom(Content.scrambleSentences, 1).first;
    final words = sentence.split(' ');
    _pool = Content.shuffle(words);
    _built = [];
    _done = null;
  }

  void _check() {
    final sentence = Content.pickRandom(Content.scrambleSentences, 1).first;
    final ok = _built.join(' ') == sentence;
    setState(() {
      _done = ok;
      if (ok) {
        context.read<StoreProvider>().addExp(10);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final i18n = context.watch<I18nProvider>();

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppTheme._border.withOpacity(0.6)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              i18n.t('wordScramble'),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    letterSpacing: 1.5,
                    color: AppTheme._mutedForeground,
                  ),
            ),
            const SizedBox(height: 16),
            // Built area
            Container(
              constraints: const BoxConstraints(minHeight: 64),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme._background.withOpacity(0.4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme._border.withOpacity(0.6),
                  style: BorderStyle.solid,
                ),
              ),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(_built.length, (i) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _pool.add(_built[i]);
                        _built.removeAt(i);
                        _done = null;
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme._primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _built[i],
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme._primary,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),
            // Pool area
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(_pool.length, (i) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      _built.add(_pool[i]);
                      _pool.removeAt(i);
                    });
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme._muted.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme._border.withOpacity(0.6)),
                    ),
                    child: Text(
                      _pool[i],
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _built.length == _pool.length + _built.length ? _check : null,
                  child: Text(i18n.t('submit')),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _round++;
                      _initRound();
                    });
                  },
                  child: Text('${i18n.t('next')} →'),
                ),
                const SizedBox(width: 8),
                if (_done == true)
                  Text(
                    '${i18n.t('correct')} +10 EXP',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF6EE7B7),
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                if (_done == false)
                  Text(
                    i18n.t('incorrect'),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme._destructive,
                        ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class WordPuzzle extends StatefulWidget {
  const WordPuzzle({super.key});

  @override
  State<WordPuzzle> createState() => _WordPuzzleState();
}

class _WordPuzzleState extends State<WordPuzzle> {
  int _round = 0;
  late List<VocabItem> _set;
  late List<String> _defs;
  final Map<String, String> _matches = {};
  String? _picked;

  @override
  void initState() {
    super.initState();
    _initRound();
  }

  void _initRound() {
    _set = Content.pickRandom(Content.vocabPool, 4);
    _defs = Content.shuffle(_set.map((s) => s.def).toList());
    _matches.clear();
    _picked = null;
  }

  void _pickWord(String word) {
    setState(() {
      _picked = word;
    });
  }

  void _pickDef(String def) {
    if (_picked == null) return;
    setState(() {
      _matches[_picked!] = def;
      final target = _set.firstWhere((s) => s.word == _picked);
      if (target.def == def) {
        context.read<StoreProvider>().addExp(10);
      }
      _picked = null;
    });
  }

  bool get _allDone => _matches.length == _set.length;

  @override
  Widget build(BuildContext context) {
    final i18n = context.watch<I18nProvider>();

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppTheme._border.withOpacity(0.6)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              i18n.t('wordPuzzle'),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    letterSpacing: 1.5,
                    color: AppTheme._mutedForeground,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                // Words column
                Expanded(
                  child: Column(
                    children: List.generate(_set.length, (index) {
                      final item = _set[index];
                      final matched = _matches[item.word];
                      final correct = matched != null && matched == item.def;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: InkWell(
                          onTap: matched == null ? () => _pickWord(item.word) : null,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: matched != null
                                  ? correct
                                      ? AppTheme._emerald.withOpacity(0.1)
                                      : AppTheme._destructive.withOpacity(0.1)
                                  : _picked == item.word
                                      ? AppTheme._primary.withOpacity(0.15)
                                      : AppTheme._muted.withOpacity(0.4),
                              border: Border.all(
                                color: matched != null
                                    ? correct
                                        ? AppTheme._emerald.withOpacity(0.6)
                                        : AppTheme._destructive.withOpacity(0.6)
                                    : _picked == item.word
                                        ? AppTheme._primary
                                        : AppTheme._border.withOpacity(0.6),
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              item.word,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(width: 16),
                // Definitions column
                Expanded(
                  child: Column(
                    children: List.generate(_defs.length, (index) {
                      final def = _defs[index];
                      final used = _matches.values.contains(def);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: InkWell(
                          onTap: used ? null : () => _pickDef(def),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: used
                                  ? AppTheme._muted.withOpacity(0.2)
                                  : AppTheme._muted.withOpacity(0.4),
                              border: Border.all(
                                color: used
                                    ? AppTheme._border.withOpacity(0.3)
                                    : AppTheme._border.withOpacity(0.6),
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              def,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: used ? AppTheme._mutedForeground.withOpacity(0.6) : null,
                                  ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                OutlinedButton(
                  onPressed: _allDone
                      ? () {
                          setState(() {
                            _round++;
                            _initRound();
                          });
                        }
                      : null,
                  child: Text('${i18n.t('next')} →'),
                ),
                const SizedBox(width: 8),
                if (_allDone)
                  Text(
                    i18n.t('correct'),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF6EE7B7),
                          fontWeight: FontWeight.w600,
                        ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
