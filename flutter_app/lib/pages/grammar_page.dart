import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../providers/store_provider.dart';
import '../providers/i18n_provider.dart';
import '../models/content.dart';
import '../widgets/quiz_runner.dart';
import '../app/theme.dart';

class GrammarPage extends StatefulWidget {
  const GrammarPage({super.key});

  @override
  State<GrammarPage> createState() => _GrammarPageState();
}

class _GrammarPageState extends State<GrammarPage> {
  String _selectedTopic = Content.grammarTopics[0];
  int _quizKey = 0;
  late YoutubePlayerController _youtubeController;

  @override
  void initState() {
    super.initState();
    _youtubeController = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(Content.youtubePlaceholder) ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _youtubeController.dispose();
    super.dispose();
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
          // Header
          Text(
            i18n.t('grammarHub'),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            i18n.t('selectTopic'),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme._mutedForeground,
                ),
          ),
          const SizedBox(height: 24),
          // Main content grid
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sidebar
              SizedBox(
                width: 260,
                child: Card(
                  color: AppTheme._card.withOpacity(0.8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: AppTheme._border.withOpacity(0.6)),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: Content.grammarTopics.length,
                    itemBuilder: (context, index) {
                      final topic = Content.grammarTopics[index];
                      final isSelected = topic == _selectedTopic;
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedTopic = topic;
                            _quizKey++;
                          });
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? AppTheme._primary.withOpacity(0.15) : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.menu_book, size: 14),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  topic,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: isSelected ? AppTheme._primary : AppTheme._mutedForeground,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 24),
              // Main content area
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Video player
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: AppTheme._border.withOpacity(0.6)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: AppTheme._border.withOpacity(0.6)),
                              ),
                            ),
                            child: Text(
                              _selectedTopic,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: YoutubePlayer(
                                controller: _youtubeController,
                                showVideoProgressIndicator: true,
                                progressIndicatorColor: AppTheme._primary,
                                progressColors: const ProgressBarColors(
                                  playedColor: AppTheme._primary,
                                  handleColor: AppTheme._primary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Practice quiz section
                    Text(
                      i18n.t('practiceQuiz'),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 16),
                    QuizRunner(
                      key: ValueKey('$_selectedTopic-$_quizKey'),
                      pool: Content.grammarQuizzes[_selectedTopic] ?? Content.grammarQuizzes[Content.grammarTopics[0]]!,
                      count: 5,
                      onDone: (score, total) {
                        setState(() {
                          _quizKey++;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
