import { createFileRoute, useNavigate } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { useStore } from "@/lib/store";
import { useI18n } from "@/lib/i18n";
import { GRAMMAR_TOPICS, GRAMMAR_QUIZZES, YOUTUBE_PLACEHOLDER } from "@/lib/content";
import { QuizRunner } from "@/components/QuizRunner";
import { BookOpen } from "lucide-react";

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
  const { user } = useStore();
  const { t } = useI18n();
  const nav = useNavigate();
  const [topic, setTopic] = useState<string>(GRAMMAR_TOPICS[0]);
  const [quizKey, setQuizKey] = useState(0);

  useEffect(() => {
    if (!user.loggedIn) nav({ to: "/login" });
  }, [user.loggedIn, nav]);

  if (!user.loggedIn) return null;

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
          <section>
            <h3 className="mb-3 text-lg font-semibold">{t("practiceQuiz")}</h3>
            <QuizRunner
              key={`${topic}-${quizKey}`}
              pool={GRAMMAR_QUIZZES[topic] ?? GRAMMAR_QUIZZES[GRAMMAR_TOPICS[0]]}
              count={5}
              onDone={() => setQuizKey((k) => k + 1)}
            />
          </section>
        </div>
      </div>
    </div>
  );
}