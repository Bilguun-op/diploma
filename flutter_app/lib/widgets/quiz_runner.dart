import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/content.dart';
import '../providers/store_provider.dart';
import '../providers/i18n_provider.dart';
import '../app/theme.dart';

class QuizRunner extends StatefulWidget {
  final List<QuizQ> pool;
  final int count;
  final Function(int score, int total)? onDone;

  const QuizRunner({
    super.key,
    required this.pool,
    this.count = 5,
    this.onDone,
  });

  @override
  State<QuizRunner> createState() => _QuizRunnerState();
}

class _QuizRunnerState extends State<QuizRunner> {
  late List<QuizQ> questions;
  int currentIndex = 0;
  int? pickedIndex;
  int score = 0;
  bool done = false;

  @override
  void initState() {
    super.initState();
    questions = Content.pickRandom(widget.pool, widget.count);
  }

  void choose(int idx) {
    if (pickedIndex != null) return;
    setState(() {
      pickedIndex = idx;
      if (idx == questions[currentIndex].answer) {
        score++;
        context.read<StoreProvider>().addExp(10);
      }
    });
  }

  void next() {
    if (pickedIndex == null) return;
    if (currentIndex + 1 >= questions.length) {
      setState(() {
        done = true;
      });
      return;
    }
    setState(() {
      currentIndex++;
      pickedIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final i18n = context.watch<I18nProvider>();

    if (done) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(
                i18n.t('testScore'),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      letterSpacing: 1.5,
                      color: AppTheme._mutedForeground,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                '$score/${questions.length}',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: AppTheme._primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => widget.onDone?.call(score, questions.length),
                child: Text(i18n.t('finish')),
              ),
            ],
          ),
        ),
      );
    }

    final q = questions[currentIndex];
    final correct = pickedIndex != null && pickedIndex == q.answer;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${i18n.t('question')} ${currentIndex + 1} ${i18n.t('of')} ${questions.length}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme._mutedForeground,
                      ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme._primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$score ${i18n.t('exp')}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppTheme._primary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              q.q,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            ...List.generate(q.options.length, (idx) {
              final isPicked = pickedIndex == idx;
              final isCorrect = q.answer == idx;
              final show = pickedIndex != null;

              Color? bgColor;
              Color? textColor;
              BorderSide? borderSide;

              if (show && isCorrect) {
                bgColor = AppTheme._emerald.withOpacity(0.1);
                textColor = const Color(0xFF6EE7B7);
                borderSide = const BorderSide(color: Color(0xFF10B981), width: 0.6);
              } else if (show && isPicked && !isCorrect) {
                bgColor = AppTheme._destructive.withOpacity(0.1);
                textColor = AppTheme._destructive;
                borderSide = BorderSide(color: AppTheme._destructive, width: 0.6);
              } else {
                bgColor = AppTheme._muted.withOpacity(0.4);
                textColor = null;
                borderSide = BorderSide(color: AppTheme._border.withOpacity(0.6));
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  onTap: () => choose(idx),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: bgColor,
                      border: Border.fromBorderSide(borderSide),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            q.options[idx],
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: textColor,
                                ),
                          ),
                        ),
                        if (show && isCorrect)
                          const Icon(Icons.check, size: 16, color: Color(0xFF10B981)),
                        if (show && isPicked && !isCorrect)
                          const Icon(Icons.close, size: 16, color: AppTheme._destructive),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  pickedIndex == null
                      ? ''
                      : correct
                          ? i18n.t('correct')
                          : i18n.t('incorrect'),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: correct ? const Color(0xFF6EE7B7) : AppTheme._destructive,
                      ),
                ),
                ElevatedButton(
                  onPressed: pickedIndex != null ? next : null,
                  child: Text(currentIndex + 1 >= questions.length
                      ? i18n.t('finish')
                      : i18n.t('next')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
