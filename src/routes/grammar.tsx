import { createFileRoute, useNavigate } from "@tanstack/react-router";
import { useEffect, useMemo, useState } from "react";
import { useStore } from "@/lib/store";
import { useI18n } from "@/lib/i18n";
import { GRAMMAR_TOPICS, GRAMMAR_QUIZZES, YOUTUBE_PLACEHOLDER, LEVEL_1_QUESTIONS, LEVEL_2_QUESTIONS, LEVEL_3_QUESTIONS, LEVEL_4_QUESTIONS, LEVEL_5_QUESTIONS, shuffle } from "@/lib/content";
import { QuizRunner } from "@/components/QuizRunner";
import { BookOpen, Zap } from "lucide-react";

export const Route = createFileRoute("/grammar")({
  head: () => ({
    meta: [
      { title: "Grammar — Mongol English Spark" },
      { name: "description", content: "26 grammar topics with video lessons and randomized practice quizzes." },
    ],
  }),
  component: GrammarPage,
});

function GrammarPage() {
  const { user, bootstrapped } = useStore();
  const { t } = useI18n();
  const nav = useNavigate();
  const [topic, setTopic] = useState<string>(GRAMMAR_TOPICS[0]);
  const [difficulty, setDifficulty] = useState<"beginner" | "intermediate" | "advanced">("beginner");
  const [quizKey, setQuizKey] = useState(0);

  useEffect(() => {
    if (bootstrapped && !user.loggedIn) nav({ to: "/login" });
  }, [bootstrapped, user.loggedIn, nav]);

  if (!bootstrapped || !user.loggedIn) return null;

  // Get difficulty-appropriate questions
  const getDifficultyPool = () => {
    switch (difficulty) {
      case "beginner":
        return LEVEL_1_QUESTIONS;
      case "intermediate":
        return LEVEL_3_QUESTIONS;
      case "advanced":
        return LEVEL_5_QUESTIONS;
      default:
        return LEVEL_1_QUESTIONS;
    }
  };

  // Mix grammar topic questions with difficulty pool
  const getTopicQuestions = useMemo(() => {
    const topicQuestions = GRAMMAR_QUIZZES[topic] ?? GRAMMAR_QUIZZES[GRAMMAR_TOPICS[0]];
    const difficultyPool = getDifficultyPool();
    
    // Combine both pools and shuffle
    const combined = [...topicQuestions.slice(0, 3), ...difficultyPool.slice(0, 2)];
    return shuffle(combined);
  }, [topic, difficulty]);

  return (
    <div className="mx-auto max-w-7xl px-4 py-8 md:px-6">
      <header className="mb-6">
        <h1 className="text-3xl font-bold tracking-tight md:text-4xl">{t("grammarHub")}</h1>
        <p className="mt-1 text-sm text-muted-foreground">{t("selectTopic")}</p>
      </header>
      <div className="grid gap-6 lg:grid-cols-[260px_1fr]">
        <aside className="rounded-2xl border border-border/60 bg-card/80 p-2 lg:max-h-[80vh] lg:overflow-y-auto">
          {GRAMMAR_TOPICS.map((tp) => (
            <button
              key={tp}
              onClick={() => { setTopic(tp); setQuizKey((k) => k + 1); }}
              className={`flex w-full items-center gap-2 rounded-lg px-3 py-2 text-left text-sm transition ${
                topic === tp ? "bg-primary/15 text-primary" : "text-muted-foreground hover:bg-muted hover:text-foreground"
              }`}
            >
              <BookOpen className="h-3.5 w-3.5" />
              {tp}
            </button>
          ))}
        </aside>
        <div className="space-y-6">
          {/* YouTube Video */}
          <div className="overflow-hidden rounded-2xl border border-border/60 bg-card">
            <div className="border-b border-border/60 px-5 py-3">
              <h2 className="font-semibold">{topic}</h2>
            </div>
            <div className="aspect-video w-full bg-black">
              <iframe
                key={topic}
                className="h-full w-full"
                src={YOUTUBE_PLACEHOLDER}
                title={topic}
                allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                allowFullScreen
              />
            </div>
          </div>

          {/* Difficulty Level Selector */}
          <div className="rounded-2xl border border-border/60 bg-card p-4">
            <h3 className="mb-3 font-semibold flex items-center gap-2">
              <Zap className="h-4 w-4" />
              Select Difficulty
            </h3>
            <div className="grid grid-cols-3 gap-2">
              {(["beginner", "intermediate", "advanced"] as const).map((level) => (
                <button
                  key={level}
                  onClick={() => {
                    setDifficulty(level);
                    setQuizKey((k) => k + 1);
                  }}
                  className={`rounded-lg px-3 py-2 text-sm font-medium transition ${
                    difficulty === level
                      ? "bg-primary/20 text-primary border border-primary/50"
                      : "bg-muted/50 text-muted-foreground hover:bg-muted hover:text-foreground border border-transparent"
                  }`}
                >
                  {level === "beginner" ? "🟢 Beginner" : level === "intermediate" ? "🟡 Medium" : "🔴 Advanced"}
                </button>
              ))}
            </div>
          </div>

          {/* Practice Quiz */}
          <section>
            <h3 className="mb-3 text-lg font-semibold">{t("practiceQuiz")}</h3>
            <QuizRunner
              key={`${topic}-${difficulty}-${quizKey}`}
              pool={getTopicQuestions}
              count={5}
              onDone={() => setQuizKey((k) => k + 1)}
            />
          </section>
        </div>
      </div>
    </div>
  );
}
