import { createFileRoute, useNavigate } from "@tanstack/react-router";
import { useEffect, useState, useMemo } from "react";
import { useStore } from "@/lib/store";
import { useI18n } from "@/lib/i18n";
import { Button } from "@/components/ui/button";
import { PLACEMENT_QUESTIONS, READING_PASSAGES, GRAMMAR_QUIZZES, VOCAB_POOL, shuffle, LEVEL_1_QUESTIONS, LEVEL_2_QUESTIONS, LEVEL_3_QUESTIONS, LEVEL_4_QUESTIONS, LEVEL_5_QUESTIONS } from "@/lib/content";
import { QuizRunner } from "@/components/QuizRunner";
import {
  Sparkles, Lock, Check, ChevronDown, BookOpen, Brain, Trophy,
} from "lucide-react";

export const Route = createFileRoute("/")({
  head: () => ({
    meta: [
      { title: "Home — Mongol English Spark" },
      { name: "description", content: "Placement test, daily study tracker, and your English learning roadmap." },
    ],
  }),
  component: HomePage,
});

type ActiveModule = { level: number; unit: number; kind: "reading" | "grammar" | "vocab" } | null;

function HomePage() {
  const { user, bootstrapped, setPlacementLevel, completeModule, setLevelStatus, addExp } = useStore();
  const { t, lang } = useI18n();
  const nav = useNavigate();

  useEffect(() => {
    if (bootstrapped && !user.loggedIn) nav({ to: "/login" });
  }, [bootstrapped, user.loggedIn, nav]);

  const [placementOpen, setPlacementOpen] = useState(false);
  const [placementResult, setPlacementResult] = useState<number | null>(null);
  const [openLevel, setOpenLevel] = useState<number | null>(0);
  const [active, setActive] = useState<ActiveModule>(null);
  const [levelTestFor, setLevelTestFor] = useState<number | null>(null);

  if (!bootstrapped || !user.loggedIn) return null;

  const fmt = (minutes: number) => {
    const h = Math.floor(minutes / 60);
    const m = minutes % 60;
    return `${h.toString().padStart(2, "0")}:${m.toString().padStart(2, "0")}`;
  };

  return (
    <div className="mx-auto max-w-7xl space-y-8 px-4 py-8 md:px-6">
      {/* Hero greeting */}
      <div className="flex flex-wrap items-end justify-between gap-4">
        <div>
          <p className="text-sm text-muted-foreground">{t("greeting")}, <span className="text-foreground font-semibold">{user.name}</span></p>
          <h1 className="mt-1 text-3xl font-bold tracking-tight md:text-4xl">{t("home")}</h1>
        </div>
        <div className="flex items-center gap-2 rounded-full border border-border/60 bg-card/60 px-4 py-2 text-sm">
          <Trophy className="h-4 w-4 text-amber" />
          <span className="font-semibold">{user.exp}</span>
          <span className="text-muted-foreground">{t("totalExp")}</span>
        </div>
      </div>

      {/* Placement banner + study tracker */}
      <div className="grid gap-4 md:grid-cols-3">
        <button
          onClick={() => setPlacementOpen(true)}
          className="group relative col-span-2 overflow-hidden rounded-3xl border border-border/60 bg-(image:--gradient-hero) p-6 text-left shadow-(--shadow-glow) transition-transform hover:scale-[1.01]"
        >
          <div className="absolute -right-6 -top-6 h-32 w-32 rounded-full bg-white/10 blur-2xl" />
          <Sparkles className="h-6 w-6 text-primary-foreground" />
          <h2 className="mt-3 text-2xl font-bold text-primary-foreground md:text-3xl">
            {t("placementTest")}
          </h2>
          <p className="mt-2 max-w-md text-sm text-primary-foreground/80">{t("placementDesc")}</p>
          <span className="mt-4 inline-flex items-center gap-2 rounded-full bg-background/20 px-3 py-1 text-xs font-semibold text-primary-foreground backdrop-blur">
            {t("startTest")} →
          </span>
        </button>

        <div className="rounded-3xl border border-border/60 bg-card p-6">
          <div className="grid grid-cols-2 gap-4">
            {/* Daily Study Time */}
            <div>
              <p className="text-xs uppercase tracking-widest text-muted-foreground">{t("dailyStudy")}</p>
              <p className="mt-2 font-mono text-3xl font-bold text-accent">{fmt(user.studyMinutes)}</p>
              <p className="text-xs text-muted-foreground mt-1">
                {user.studyMinutes} {t("minutesToday")}
              </p>
            </div>
            
            {/* Total Study Time */}
            <div>
              <p className="text-xs uppercase tracking-widest text-muted-foreground">{t("totalStudy")}</p>
              <p className="mt-2 font-mono text-3xl font-bold text-primary">
                {fmt(user.totalStudyMinutes)}
              </p>
              <p className="text-xs text-muted-foreground mt-1">
                {user.totalStudyMinutes} min total
              </p>
            </div>
          </div>
          <p className="text-xs text-muted-foreground mt-4 italic">
            ⏱️ {t("timerAutomatic")}
          </p>
        </div>
      </div>

      {/* Roadmap */}
      <section>
        <h2 className="mb-4 text-xl font-bold tracking-tight">{t("levels")}</h2>
        <div className="space-y-3">
          {user.levelStatuses.map((status, lvlIdx) => {
            const isOpen = openLevel === lvlIdx;
            const locked = status === "locked";
            const completedUnits = user.unitsCompleted[lvlIdx].filter((u) => u >= 3).length;
            const allDone = completedUnits === 5;
            return (
              <div key={lvlIdx} className={`rounded-2xl border ${locked ? "border-border/40 opacity-60" : "border-border/60"} bg-card/80 transition-all`}>
                <button
                  disabled={locked}
                  onClick={() => setOpenLevel(isOpen ? null : lvlIdx)}
                  className="flex w-full items-center justify-between gap-4 px-5 py-4 text-left"
                >
                  <div className="flex items-center gap-4">
                    <div className={`grid h-12 w-12 place-items-center rounded-xl ${status === "completed" ? "bg-emerald-500/20 text-emerald-300" : status === "unlocked" ? "bg-(image:--gradient-hero) text-primary-foreground" : "bg-muted text-muted-foreground"}`}>
                      {status === "locked" ? <Lock className="h-5 w-5" /> : status === "completed" ? <Check className="h-5 w-5" /> : <span className="font-bold">{lvlIdx + 1}</span>}
                    </div>
                    <div>
                      <p className="font-semibold">{t("level")} {lvlIdx + 1}</p>
                      <p className="text-xs text-muted-foreground">
                        {completedUnits}/5 {t("unit")} · {status === "locked" ? t("locked") : status === "completed" ? t("completed") : t("unlocked")}
                      </p>
                    </div>
                  </div>
                  {!locked && <ChevronDown className={`h-4 w-4 transition ${isOpen ? "rotate-180" : ""}`} />}
                </button>
                {isOpen && !locked && (
                  <div className="border-t border-border/60 px-5 py-4 space-y-3">
                    {[0, 1, 2, 3, 4].map((unitIdx) => {
                      const done = user.unitsCompleted[lvlIdx][unitIdx];
                      return (
                        <div key={unitIdx} className="rounded-xl border border-border/40 bg-background/40 p-3">
                          <div className="mb-2 flex items-center justify-between">
                            <p className="text-sm font-semibold">{t("unit")} {unitIdx + 1}</p>
                            <span className="text-xs text-muted-foreground">{done}/3</span>
                          </div>
                          <div className="grid grid-cols-3 gap-2">
                            {(["reading", "grammar", "vocab"] as const).map((k, ki) => {
                              const Icon = k === "reading" ? BookOpen : k === "grammar" ? Brain : Sparkles;
                              const label = k === "reading" ? t("reading") : k === "grammar" ? t("grammar") : t("vocabulary");
                              const isDone = ki < done;
                              return (
                                <button
                                  key={k}
                                  onClick={() => setActive({ level: lvlIdx, unit: unitIdx, kind: k })}
                                  className={`flex flex-col items-center gap-1 rounded-lg border px-2 py-3 text-xs transition-all ${isDone ? "border-emerald-500/40 bg-emerald-500/10 text-emerald-200" : "border-border/50 hover:border-primary/60 hover:bg-primary/5"}`}
                                >
                                  <Icon className="h-4 w-4" />
                                  <span>{label}</span>
                                </button>
                              );
                            })}
                          </div>
                        </div>
                      );
                    })}
                    <Button
                      disabled={!allDone}
                      className="w-full bg-(image:--gradient-amber) text-amber-foreground hover:opacity-90"
                      onClick={() => setLevelTestFor(lvlIdx)}
                    >
                      <Trophy className="mr-2 h-4 w-4" />
                      {t("levelTest")}
                    </Button>
                  </div>
                )}
              </div>
            );
          })}
        </div>
      </section>

      {placementOpen && placementResult === null && (
        <Modal onClose={() => setPlacementOpen(false)} title={t("placementTest")}>
          <QuizRunner
            pool={PLACEMENT_QUESTIONS}
            count={12}
            onDone={(score) => {
              const level = Math.min(4, Math.max(0, Math.floor(score / 3) - 1 + 1));
              setPlacementLevel(level);
              setPlacementResult(level);
            }}
          />
          <p className="mt-3 text-center text-xs text-muted-foreground">
            {t("tip")}: {lang === "en" ? "Your score determines your starting level." : "Таны оноо эхлэх түвшинг тогтооно."}
          </p>
        </Modal>
      )}

      {placementResult !== null && (
        <Modal onClose={() => { setPlacementResult(null); setPlacementOpen(false); }} title={t("placementTest")}>
          <div className="text-center space-y-6">
            <div>
              <p className="text-sm text-muted-foreground mb-2">{lang === "en" ? "Your Placement Level" : "Таны түвшин"}</p>
              <div className="inline-flex items-center justify-center h-24 w-24 rounded-full bg-(image:--gradient-hero) text-primary-foreground">
                <span className="text-5xl font-bold">{placementResult + 1}</span>
              </div>
            </div>
            <div className="space-y-2">
              <p className="font-semibold">{lang === "en" ? `Welcome to Level ${placementResult + 1}!` : `${placementResult + 1}-р түвшинд сургалт эхэл!`}</p>
              <p className="text-sm text-muted-foreground">
                {lang === "en" 
                  ? `Levels 1-${placementResult + 1} are now unlocked for you.` 
                  : `${placementResult + 1}-р түвшин хүртэлх бүх түвшинүүд нээлээ.`}
              </p>
            </div>
            <Button 
              className="w-full bg-(image:--gradient-hero)"
              onClick={() => { setPlacementResult(null); setPlacementOpen(false); }}
            >
              {lang === "en" ? "Start Learning" : "Сурах эхлэх"}
            </Button>
          </div>
        </Modal>
      )}

      {active && (
        <Modal onClose={() => setActive(null)} title={`${t("level")} ${active.level + 1} · ${t("unit")} ${active.unit + 1}`}>
          <ModuleRunner
            level={active.level}
            kind={active.kind}
            onComplete={() => {
              completeModule(active.level, active.unit);
              setActive(null);
            }}
          />
        </Modal>
      )}

      {levelTestFor !== null && (
        <Modal onClose={() => setLevelTestFor(null)} title={`${t("levelTest")} — ${t("level")} ${levelTestFor + 1}`}>
          <QuizRunner
            pool={shuffle(Object.values(GRAMMAR_QUIZZES).flat()).slice(0, 10)}
            count={10}
            onDone={(score, total) => {
              const pass = score / total >= 0.7;
              if (pass) {
                setLevelStatus(levelTestFor, "completed");
                addExp(50);
              }
              setLevelTestFor(null);
            }}
          />
        </Modal>
      )}
    </div>
  );
}

function Modal({ title, children, onClose }: { title: string; children: React.ReactNode; onClose: () => void }) {
  return (
    <div className="fixed inset-0 z-50 grid place-items-center bg-background/80 p-4 backdrop-blur-sm" onClick={onClose}>
      <div className="w-full max-w-2xl rounded-3xl border border-border/60 bg-card p-6 shadow-(--shadow-glow)" onClick={(e) => e.stopPropagation()}>
        <div className="mb-4 flex items-center justify-between">
          <h3 className="font-bold">{title}</h3>
          <button className="text-muted-foreground hover:text-foreground" onClick={onClose}>✕</button>
        </div>
        {children}
      </div>
    </div>
  );
}

function ModuleRunner({ level, kind, onComplete }: { level: number; kind: "reading" | "grammar" | "vocab"; onComplete: () => void }) {
  const { t } = useI18n();
  
  // Get level-appropriate question pool
  const getLevelPool = () => {
    switch (level) {
      case 0:
        return LEVEL_1_QUESTIONS;
      case 1:
        return LEVEL_2_QUESTIONS;
      case 2:
        return LEVEL_3_QUESTIONS;
      case 3:
        return LEVEL_4_QUESTIONS;
      case 4:
        return LEVEL_5_QUESTIONS;
      default:
        return LEVEL_1_QUESTIONS;
    }
  };

  const passage = useMemo(() => shuffle(READING_PASSAGES)[0], []);
  const grammarPool = useMemo(() => shuffle(getLevelPool()).slice(0, 12), [level]);
  const vocabItems = useMemo(() => shuffle(VOCAB_POOL).slice(0, 5), []);
  const vocabPool = useMemo(() => {
    return vocabItems.map((it) => {
      const others = shuffle(VOCAB_POOL.filter((v) => v.word !== it.word)).slice(0, 3).map((v) => v.def);
      const options = shuffle([it.def, ...others]);
      return { q: `"${it.word}" — ${t("vocabulary")}`, options, answer: options.indexOf(it.def) };
    });
  }, [vocabItems, t]);
  
  if (kind === "reading") {
    return (
      <div className="space-y-4">
        <div className="rounded-xl border border-border/60 bg-background/40 p-4">
          <h4 className="mb-2 font-semibold text-accent">{passage.title}</h4>
          <p className="text-sm leading-relaxed text-muted-foreground">{passage.text}</p>
        </div>
        <QuizRunner pool={passage.questions} count={3} onDone={onComplete} />
      </div>
    );
  }
  if (kind === "grammar") {
    return <QuizRunner pool={grammarPool} count={5} onDone={onComplete} />;
  }
  
  return <QuizRunner pool={vocabPool} count={5} onDone={onComplete} />;
}
