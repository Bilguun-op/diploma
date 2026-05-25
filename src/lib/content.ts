// All English educational content pools - randomized per session.

export interface QuizQ {
  q: string;
  options: string[];
  answer: number; // index
}

export const GRAMMAR_TOPICS: string[] = [
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

export const YOUTUBE_PLACEHOLDER = "https://www.youtube.com/embed/dQw4w9WgXcQ";

// Generate a pool of quizzes per topic (at least 6 each so we can shuffle).
function makeQuizPool(topic: string): QuizQ[] {
  const base: Record<string, QuizQ[]> = {
    "Present Simple": [
      { q: "She ___ to school every day.", options: ["go", "goes", "going", "gone"], answer: 1 },
      { q: "They ___ football on Sundays.", options: ["plays", "playing", "play", "played"], answer: 2 },
      { q: "Water ___ at 100°C.", options: ["boil", "boils", "boiling", "boiled"], answer: 1 },
      { q: "I ___ coffee in the morning.", options: ["drink", "drinks", "drinking", "drank"], answer: 0 },
      { q: "He ___ in Ulaanbaatar.", options: ["live", "lives", "living", "lived"], answer: 1 },
      { q: "We ___ English twice a week.", options: ["studies", "study", "studying", "studied"], answer: 1 },
    ],
    "Present Continuous": [
      { q: "Listen! The baby ___.", options: ["cries", "is crying", "cry", "cried"], answer: 1 },
      { q: "I ___ my homework right now.", options: ["do", "did", "am doing", "does"], answer: 2 },
      { q: "They ___ TV at the moment.", options: ["watch", "are watching", "watches", "watched"], answer: 1 },
      { q: "Why ___ you ___?", options: ["are/laughing", "do/laugh", "is/laughing", "did/laugh"], answer: 0 },
      { q: "She ___ a new book this week.", options: ["reads", "is reading", "read", "reading"], answer: 1 },
      { q: "We ___ for the bus now.", options: ["wait", "waits", "are waiting", "waited"], answer: 2 },
    ],
  };
  if (base[topic]) return base[topic];
  // Generic fallback pool customized with topic name
  return [
    { q: `Choose the correct use of ${topic}: "She ___ very well."`, options: ["sing", "sings", "singing", "sang"], answer: 1 },
    { q: `Identify correct sentence (${topic}).`, options: ["He don't know.", "He doesn't knows.", "He doesn't know.", "He not know."], answer: 2 },
    { q: `${topic}: "I have ___ apple."`, options: ["a", "an", "the", "-"], answer: 1 },
    { q: `${topic}: pick the right modal: "You ___ smoke here."`, options: ["should", "must not", "can", "would"], answer: 1 },
    { q: `${topic}: comparative of "good".`, options: ["gooder", "more good", "better", "best"], answer: 2 },
    { q: `${topic}: "If I ___ rich, I would travel."`, options: ["am", "was", "were", "be"], answer: 2 },
    { q: `${topic}: passive of "They built it."`, options: ["It built.", "It was built.", "It is build.", "It built was."], answer: 1 },
    { q: `${topic}: preposition: "I'm good ___ math."`, options: ["in", "on", "at", "for"], answer: 2 },
  ];
}

export const GRAMMAR_QUIZZES: Record<string, QuizQ[]> = Object.fromEntries(
  GRAMMAR_TOPICS.map((t) => [t, makeQuizPool(t)]),
);

export const READING_PASSAGES = [
  {
    title: "Naadam Festival",
    text: "Naadam is Mongolia's largest summer festival. It features three traditional sports: wrestling, horse racing, and archery. People wear colorful deels and gather in Ulaanbaatar.",
    questions: [
      { q: "How many sports does Naadam feature?", options: ["2", "3", "4", "5"], answer: 1 },
      { q: "When is Naadam held?", options: ["Winter", "Spring", "Summer", "Autumn"], answer: 2 },
      { q: "What do people wear?", options: ["Jeans", "Deels", "Suits", "Uniforms"], answer: 1 },
      { q: "Where do people gather for Naadam?", options: ["Ulaanbaatar", "London", "Tokyo", "Sydney"], answer: 0 },
      { q: "Which sport is part of Naadam?", options: ["Swimming", "Archery", "Basketball", "Tennis"], answer: 1 },
    ],
  },
  {
    title: "The Gobi Desert",
    text: "The Gobi is one of the largest deserts in the world. It is cold in winter and hot in summer. Camels and snow leopards live there.",
    questions: [
      { q: "What animals live in the Gobi?", options: ["Lions and tigers", "Camels and leopards", "Bears", "Wolves only"], answer: 1 },
      { q: "Gobi is one of the ___ deserts.", options: ["smallest", "largest", "wettest", "coldest only"], answer: 1 },
      { q: "How is Gobi in summer?", options: ["Cold", "Hot", "Snowy", "Rainy"], answer: 1 },
      { q: "How is the Gobi in winter?", options: ["Cold", "Tropical", "Rainy", "Humid"], answer: 0 },
      { q: "What type of place is the Gobi?", options: ["A forest", "A desert", "A city", "An ocean"], answer: 1 },
    ],
  },
  {
    title: "Modern Ulaanbaatar",
    text: "Ulaanbaatar is the capital of Mongolia. It is home to over 1.5 million people. The city blends modern skyscrapers with traditional ger districts.",
    questions: [
      { q: "What is Ulaanbaatar?", options: ["A river", "The capital", "A mountain", "A desert"], answer: 1 },
      { q: "Population is over...", options: ["500,000", "1 million", "1.5 million", "5 million"], answer: 2 },
      { q: "City blends modern with...", options: ["jungles", "ger districts", "beaches", "farms"], answer: 1 },
      { q: "What modern buildings are mentioned?", options: ["Skyscrapers", "Castles", "Igloos", "Temples only"], answer: 0 },
      { q: "Ulaanbaatar is home to over ___ people.", options: ["1.5 million", "10,000", "100,000", "20 million"], answer: 0 },
    ],
  },
];

export const VOCAB_POOL: { word: string; def: string }[] = [
  { word: "achieve", def: "to successfully reach a goal" },
  { word: "brave", def: "showing courage" },
  { word: "curious", def: "eager to learn or know" },
  { word: "diligent", def: "showing care and effort in work" },
  { word: "eager", def: "wanting very much to do something" },
  { word: "fragile", def: "easily broken" },
  { word: "generous", def: "willing to give" },
  { word: "honest", def: "truthful and sincere" },
  { word: "improve", def: "to become better" },
  { word: "journey", def: "an act of traveling" },
  { word: "knowledge", def: "information and understanding" },
  { word: "loyal", def: "faithful to a person or cause" },
  { word: "modest", def: "not boastful" },
  { word: "novel", def: "new and original" },
  { word: "opportunity", def: "a chance for progress" },
  { word: "persuade", def: "to convince someone" },
  { word: "quiet", def: "making little noise" },
  { word: "reliable", def: "able to be trusted" },
  { word: "sincere", def: "free from pretense" },
  { word: "talented", def: "having a natural skill" },
];

export const SCRAMBLE_SENTENCES: string[] = [
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

export const BLASTER_QUESTIONS: QuizQ[] = [
  { q: "Pick correct: ___ apple a day keeps the doctor away.", options: ["A", "An", "The", "-"], answer: 1 },
  { q: "She ___ to the market yesterday.", options: ["go", "goes", "went", "gone"], answer: 2 },
  { q: "There ___ many books on the shelf.", options: ["is", "are", "was", "be"], answer: 1 },
  { q: "He runs ___ than me.", options: ["fast", "faster", "fastest", "more fast"], answer: 1 },
  { q: "I ___ never been to Japan.", options: ["has", "have", "had", "having"], answer: 1 },
  { q: "If it ___, we will stay home.", options: ["rains", "rained", "rain", "raining"], answer: 0 },
  { q: "The book ___ by many students.", options: ["read", "reads", "is read", "reading"], answer: 2 },
  { q: "She asked where I ___.", options: ["live", "lived", "living", "lives"], answer: 1 },
  { q: "I'm interested ___ music.", options: ["on", "at", "in", "for"], answer: 2 },
  { q: "He enjoys ___ swimming.", options: ["go", "to go", "going", "gone"], answer: 2 },
  { q: "Neither John ___ Mary came.", options: ["or", "nor", "and", "but"], answer: 1 },
  { q: "This is ___ best day ever.", options: ["a", "an", "the", "-"], answer: 2 },
];

export const PLACEMENT_QUESTIONS: QuizQ[] = [
  { q: "I ___ a student.", options: ["am", "is", "are", "be"], answer: 0 },
  { q: "She ___ from Mongolia.", options: ["am", "is", "are", "be"], answer: 1 },
  { q: "They ___ playing now.", options: ["is", "am", "are", "be"], answer: 2 },
  { q: "I ___ to school yesterday.", options: ["go", "goes", "went", "going"], answer: 2 },
  { q: "She ___ her homework already.", options: ["finish", "finishes", "has finished", "finishing"], answer: 2 },
  { q: "If I ___ time, I will help.", options: ["have", "had", "has", "having"], answer: 0 },
  { q: "He is taller ___ his brother.", options: ["that", "than", "then", "as"], answer: 1 },
  { q: "The cake ___ by my mom.", options: ["bake", "baked", "was baked", "is baking"], answer: 2 },
  { q: "I look forward ___ you.", options: ["to see", "seeing", "to seeing", "see"], answer: 2 },
  { q: "She said she ___ tired.", options: ["is", "was", "be", "are"], answer: 1 },
  { q: "Neither answer ___ correct.", options: ["are", "is", "be", "were"], answer: 1 },
  { q: "By next year, I ___ here for 10 years.", options: ["will live", "will have lived", "lived", "live"], answer: 1 },
];

export function shuffle<T>(arr: T[]): T[] {
  const a = [...arr];
  for (let i = a.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [a[i], a[j]] = [a[j], a[i]];
  }
  return a;
}

export function pickRandom<T>(arr: T[], n: number): T[] {
  return shuffle(arr).slice(0, n);
}
