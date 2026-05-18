class QuizQ {
  final String q;
  final List<String> options;
  final int answer;

  QuizQ({
    required this.q,
    required this.options,
    required this.answer,
  });

  QuizQ copyWith({
    String? q,
    List<String>? options,
    int? answer,
  }) {
    return QuizQ(
      q: q ?? this.q,
      options: options ?? this.options,
      answer: answer ?? this.answer,
    );
  }
}

class VocabItem {
  final String word;
  final String def;

  VocabItem({
    required this.word,
    required this.def,
  });
}

class ReadingPassage {
  final String title;
  final String text;
  final List<QuizQ> questions;

  ReadingPassage({
    required this.title,
    required this.text,
    required this.questions,
  });
}

class Content {
  static const List<String> grammarTopics = [
    "Present Simple",
    "Present Continuous",
    "Present Perfect",
    "Present Perfect Continuous",
    "Past Simple",
    "Past Continuous",
    "Past Perfect",
    "Past Perfect Continuous",
    "Future Simple (will)",
    "Future with (be going to)",
    "Future Continuous",
    "Future Perfect",
    "Articles (a/an/the)",
    "Nouns & Plurals",
    "Pronouns",
    "Adjectives & Adverbs",
    "Comparatives & Superlatives",
    "Modal Verbs",
    "Conditionals",
    "Passive Voice",
    "Reported Speech",
    "Prepositions",
    "Conjunctions",
    "Question Forms",
    "Phrasal Verbs",
    "Gerunds & Infinitives",
  ];

  static const String youtubePlaceholder = "https://www.youtube.com/embed/dQw4w9WgXcQ";

  static Map<String, List<QuizQ>> get grammarQuizzes {
    return {
      for (var topic in grammarTopics) topic: _makeQuizPool(topic),
    };
  }

  static List<QuizQ> _makeQuizPool(String topic) {
    final base = {
      "Present Simple": [
        QuizQ(q: "She ___ to school every day.", options: ["go", "goes", "going", "gone"], answer: 1),
        QuizQ(q: "They ___ football on Sundays.", options: ["plays", "playing", "play", "played"], answer: 2),
        QuizQ(q: "Water ___ at 100°C.", options: ["boil", "boils", "boiling", "boiled"], answer: 1),
        QuizQ(q: "I ___ coffee in the morning.", options: ["drink", "drinks", "drinking", "drank"], answer: 0),
        QuizQ(q: "He ___ in Ulaanbaatar.", options: ["live", "lives", "living", "lived"], answer: 1),
        QuizQ(q: "We ___ English twice a week.", options: ["studies", "study", "studying", "studied"], answer: 1),
      ],
      "Present Continuous": [
        QuizQ(q: "Listen! The baby ___.", options: ["cries", "is crying", "cry", "cried"], answer: 1),
        QuizQ(q: "I ___ my homework right now.", options: ["do", "did", "am doing", "does"], answer: 2),
        QuizQ(q: "They ___ TV at the moment.", options: ["watch", "are watching", "watches", "watched"], answer: 1),
        QuizQ(q: "Why ___ you ___?", options: ["are/laughing", "do/laugh", "is/laughing", "did/laugh"], answer: 0),
        QuizQ(q: "She ___ a new book this week.", options: ["reads", "is reading", "read", "reading"], answer: 1),
        QuizQ(q: "We ___ for the bus now.", options: ["wait", "waits", "are waiting", "waited"], answer: 2),
      ],
    };

    if (base.containsKey(topic)) {
      return base[topic]!;
    }

    // Generic fallback pool
    return [
      QuizQ(q: "Choose the correct use of $topic: \"She ___ very well.\"", options: ["sing", "sings", "singing", "sang"], answer: 1),
      QuizQ(q: "Identify correct sentence ($topic).", options: ["He don't know.", "He doesn't knows.", "He doesn't know.", "He not know."], answer: 2),
      QuizQ(q: "$topic: \"I have ___ apple.\"", options: ["a", "an", "the", "-"], answer: 1),
      QuizQ(q: "$topic: pick the right modal: \"You ___ smoke here.\"", options: ["should", "must not", "can", "would"], answer: 1),
      QuizQ(q: "$topic: comparative of \"good\".", options: ["gooder", "more good", "better", "best"], answer: 2),
      QuizQ(q: "$topic: \"If I ___ rich, I would travel.\"", options: ["am", "was", "were", "be"], answer: 2),
      QuizQ(q: "$topic: passive of \"They built it.\"", options: ["It built.", "It was built.", "It is build.", "It built was."], answer: 1),
      QuizQ(q: "$topic: preposition: \"I'm good ___ math.\"", options: ["in", "on", "at", "for"], answer: 2),
    ];
  }

  static const List<ReadingPassage> readingPassages = [
    ReadingPassage(
      title: "Naadam Festival",
      text: "Naadam is Mongolia's largest summer festival. It features three traditional sports: wrestling, horse racing, and archery. People wear colorful deels and gather in Ulaanbaatar.",
      questions: [
        QuizQ(q: "How many sports does Naadam feature?", options: ["2", "3", "4", "5"], answer: 1),
        QuizQ(q: "When is Naadam held?", options: ["Winter", "Spring", "Summer", "Autumn"], answer: 2),
        QuizQ(q: "What do people wear?", options: ["Jeans", "Deels", "Suits", "Uniforms"], answer: 1),
      ],
    ),
    ReadingPassage(
      title: "The Gobi Desert",
      text: "The Gobi is one of the largest deserts in the world. It is cold in winter and hot in summer. Camels and snow leopards live there.",
      questions: [
        QuizQ(q: "What animals live in the Gobi?", options: ["Lions and tigers", "Camels and leopards", "Bears", "Wolves only"], answer: 1),
        QuizQ(q: "Gobi is one of the ___ deserts.", options: ["smallest", "largest", "wettest", "coldest only"], answer: 1),
        QuizQ(q: "How is Gobi in summer?", options: ["Cold", "Hot", "Snowy", "Rainy"], answer: 1),
      ],
    ),
    ReadingPassage(
      title: "Modern Ulaanbaatar",
      text: "Ulaanbaatar is the capital of Mongolia. It is home to over 1.5 million people. The city blends modern skyscrapers with traditional ger districts.",
      questions: [
        QuizQ(q: "What is Ulaanbaatar?", options: ["A river", "The capital", "A mountain", "A desert"], answer: 1),
        QuizQ(q: "Population is over...", options: ["500,000", "1 million", "1.5 million", "5 million"], answer: 2),
        QuizQ(q: "City blends modern with...", options: ["jungles", "ger districts", "beaches", "farms"], answer: 1),
      ],
    ),
  ];

  static const List<VocabItem> vocabPool = [
    VocabItem(word: "achieve", def: "to successfully reach a goal"),
    VocabItem(word: "brave", def: "showing courage"),
    VocabItem(word: "curious", def: "eager to learn or know"),
    VocabItem(word: "diligent", def: "showing care and effort in work"),
    VocabItem(word: "eager", def: "wanting very much to do something"),
    VocabItem(word: "fragile", def: "easily broken"),
    VocabItem(word: "generous", def: "willing to give"),
    VocabItem(word: "honest", def: "truthful and sincere"),
    VocabItem(word: "improve", def: "to become better"),
    VocabItem(word: "journey", def: "an act of traveling"),
    VocabItem(word: "knowledge", def: "information and understanding"),
    VocabItem(word: "loyal", def: "faithful to a person or cause"),
    VocabItem(word: "modest", def: "not boastful"),
    VocabItem(word: "novel", def: "new and original"),
    VocabItem(word: "opportunity", def: "a chance for progress"),
    VocabItem(word: "persuade", def: "to convince someone"),
    VocabItem(word: "quiet", def: "making little noise"),
    VocabItem(word: "reliable", def: "able to be trusted"),
    VocabItem(word: "sincere", def: "free from pretense"),
    VocabItem(word: "talented", def: "having a natural skill"),
  ];

  static const List<String> scrambleSentences = [
    "I eat rice every day",
    "She reads books in the library",
    "We play football on Sundays",
    "They watch movies at home",
    "He drinks coffee every morning",
    "My brother teaches English",
    "The cat catches the mouse",
    "Students study grammar carefully",
    "Mongolian children love horses",
    "Tourists visit Ulaanbaatar often",
  ];

  static const List<QuizQ> blasterQuestions = [
    QuizQ(q: "Pick correct: ___ apple a day keeps the doctor away.", options: ["A", "An", "The", "-"], answer: 1),
    QuizQ(q: "She ___ to the market yesterday.", options: ["go", "goes", "went", "gone"], answer: 2),
    QuizQ(q: "There ___ many books on the shelf.", options: ["is", "are", "was", "be"], answer: 1),
    QuizQ(q: "He runs ___ than me.", options: ["fast", "faster", "fastest", "more fast"], answer: 1),
    QuizQ(q: "I ___ never been to Japan.", options: ["has", "have", "had", "having"], answer: 1),
    QuizQ(q: "If it ___, we will stay home.", options: ["rains", "rained", "rain", "raining"], answer: 0),
    QuizQ(q: "The book ___ by many students.", options: ["read", "reads", "is read", "reading"], answer: 2),
    QuizQ(q: "She asked where I ___.", options: ["live", "lived", "living", "lives"], answer: 1),
    QuizQ(q: "I'm interested ___ music.", options: ["on", "at", "in", "for"], answer: 2),
    QuizQ(q: "He enjoys ___ swimming.", options: ["go", "to go", "going", "gone"], answer: 2),
    QuizQ(q: "Neither John ___ Mary came.", options: ["or", "nor", "and", "but"], answer: 1),
    QuizQ(q: "This is ___ best day ever.", options: ["a", "an", "the", "-"], answer: 2),
  ];

  static const List<QuizQ> placementQuestions = [
    QuizQ(q: "I ___ a student.", options: ["am", "is", "are", "be"], answer: 0),
    QuizQ(q: "She ___ from Mongolia.", options: ["am", "is", "are", "be"], answer: 1),
    QuizQ(q: "They ___ playing now.", options: ["is", "am", "are", "be"], answer: 2),
    QuizQ(q: "I ___ to school yesterday.", options: ["go", "goes", "went", "going"], answer: 2),
    QuizQ(q: "She ___ her homework already.", options: ["finish", "finishes", "has finished", "finishing"], answer: 2),
    QuizQ(q: "If I ___ time, I will help.", options: ["have", "had", "has", "having"], answer: 0),
    QuizQ(q: "He is taller ___ his brother.", options: ["that", "than", "then", "as"], answer: 1),
    QuizQ(q: "The cake ___ by my mom.", options: ["bake", "baked", "was baked", "is baking"], answer: 2),
    QuizQ(q: "I look forward ___ you.", options: ["to see", "seeing", "to seeing", "see"], answer: 2),
    QuizQ(q: "She said she ___ tired.", options: ["is", "was", "be", "are"], answer: 1),
    QuizQ(q: "Neither answer ___ correct.", options: ["are", "is", "be", "were"], answer: 1),
    QuizQ(q: "By next year, I ___ here for 10 years.", options: ["will live", "will have lived", "lived", "live"], answer: 1),
  ];

  static List<T> shuffle<T>(List<T> arr) {
    final a = List<T>.from(arr);
    for (int i = a.length - 1; i > 0; i--) {
      final j = (DateTime.now().millisecondsSinceEpoch + i) % (i + 1);
      final temp = a[i];
      a[i] = a[j];
      a[j] = temp;
    }
    return a;
  }

  static List<T> pickRandom<T>(List<T> arr, int n) {
    return shuffle(arr).take(n).toList();
  }
}
