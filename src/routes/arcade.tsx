import { createFileRoute, useNavigate } from "@tanstack/react-router";
import { useEffect, useMemo, useState } from "react";
import { useStore } from "@/lib/store";
import { useI18n } from "@/lib/i18n";
import { Button } from "@/components/ui/button";
import { BLASTER_QUESTIONS, SCRAMBLE_SENTENCES, VOCAB_POOL, shuffle } from "@/lib/content";
import { QuizRunner } from "@/components/QuizRunner";
import { Gamepad2, Shuffle, Puzzle, Zap } from "lucide-react";

export const Route = createFileRoute("/arcade")({
  head: () => ({
    meta: [
      { title: "Arcade — Mongol English Spark" },
      { name: "description", content: "Word Scramble, Word Puzzle and Syntax Blaster — practice through play." },
    ],
  }),
  component: ArcadePage,
});

function ArcadePage() {
  const { user, bootstrapped } = useStore();
  const { t } = useI18n();
  const nav = useNavigate();
  const [game, setGame] = useState<"menu" | "scramble" | "puzzle" | "blaster">("menu");

  useEffect(() => {
    if (bootstrapped && !user.loggedIn) nav({ to: "/login" });
  }, [bootstrapped, user.loggedIn, nav]);
  if (!bootstrapped || !user.loggedIn) return null;

  return (
    <div className="mx-auto max-w-6xl px-4 py-8 md:px-6">
      <header className="mb-6">
        <h1 className="text-3xl font-bold tracking-tight md:text-4xl">{t("arcadeTitle")}</h1>
        <p className="mt-1 text-sm text-muted-foreground">
          <Gamepad2 className="mr-1 inline h-4 w-4" /> +10 EXP {t("correct")}
        </p>
      </header>

      {game === "menu" && (
        <div className="grid gap-4 md:grid-cols-3">
          <GameCard color="primary" icon={Shuffle} title={t("wordScramble")} desc={t("scrambleDesc")} onClick={() => setGame("scramble")} />
          <GameCard color="accent" icon={Puzzle} title={t("wordPuzzle")} desc={t("puzzleDesc")} onClick={() => setGame("puzzle")} />
          <GameCard color="amber" icon={Zap} title={t("syntaxBlaster")} desc={t("blasterDesc")} onClick={() => setGame("blaster")} />
        </div>
      )}

      {game !== "menu" && (
        <div className="space-y-4">
          <Button variant="ghost" onClick={() => setGame("menu")}>← {t("back")}</Button>
          {game === "scramble" && <WordScramble />}
          {game === "puzzle" && <WordPuzzle />}
          {game === "blaster" && <SyntaxBlaster />}
        </div>
      )}
    </div>
  );
}

function GameCard({ icon: Icon, title, desc, color, onClick }: { icon: any; title: string; desc: string; color: "primary" | "accent" | "amber"; onClick: () => void }) {
  const { t } = useI18n();
  const ring = color === "primary" ? "shadow-[var(--shadow-glow)]" : color === "accent" ? "shadow-[var(--shadow-cyan)]" : "";
  const bg = color === "primary" ? "bg-[image:var(--gradient-hero)]" : color === "accent" ? "bg-accent text-accent-foreground" : "bg-[image:var(--gradient-amber)] text-amber-foreground";
  return (
    <button onClick={onClick} className={`group rounded-3xl border border-border/60 bg-card p-6 text-left transition-all hover:-translate-y-1 ${ring}`}>
      <div className={`mb-4 grid h-12 w-12 place-items-center rounded-xl ${bg}`}>
        <Icon className="h-6 w-6" />
      </div>
      <h3 className="text-lg font-bold">{title}</h3>
      <p className="mt-1 text-sm text-muted-foreground">{desc}</p>
      <span className="mt-4 inline-block text-xs font-semibold text-primary group-hover:underline">{t("play")} →</span>
    </button>
  );
}

function WordScramble() {
  const { addExp } = useStore();
  const { t } = useI18n();
  const [round, setRound] = useState(0);
  const sentence = useMemo(() => shuffle(SCRAMBLE_SENTENCES)[0], [round]);
  const words = useMemo(() => sentence.split(" "), [sentence]);
  const [pool, setPool] = useState<string[]>(() => shuffle(words));
  const [built, setBuilt] = useState<string[]>([]);
  const [done, setDone] = useState<null | boolean>(null);

  useEffect(() => {
    setPool(shuffle(words));
    setBuilt([]);
    setDone(null);
  }, [words]);

  const check = () => {
    const ok = built.join(" ") === sentence;
    setDone(ok);
    if (ok) addExp(10);
  };

  return (
    <div className="rounded-2xl border border-border/60 bg-card p-6">
      <p className="mb-2 text-xs uppercase tracking-widest text-muted-foreground">{t("wordScramble")}</p>
      <div className="min-h-[64px] rounded-xl border border-dashed border-border/60 bg-background/40 p-3">
        <div className="flex flex-wrap gap-2">
          {built.map((w, i) => (
            <button
              key={`b-${i}-${w}`}
              onClick={() => { setPool((p) => [...p, w]); setBuilt((b) => b.filter((_, j) => j !== i)); setDone(null); }}
              className="rounded-lg bg-primary/20 px-3 py-1 text-sm font-medium text-primary"
            >
              {w}
            </button>
          ))}
        </div>
      </div>
      <div className="my-4 flex flex-wrap gap-2">
        {pool.map((w, i) => (
          <button
            key={`p-${i}-${w}`}
            onClick={() => { setBuilt((b) => [...b, w]); setPool((p) => p.filter((_, j) => j !== i)); }}
            className="rounded-lg border border-border/60 bg-muted/50 px-3 py-1 text-sm hover:border-primary/60 hover:bg-primary/10"
          >
            {w}
          </button>
        ))}
      </div>
      <div className="flex items-center gap-2">
        <Button onClick={check} disabled={built.length !== words.length}>{t("submit")}</Button>
        <Button variant="ghost" onClick={() => setRound((r) => r + 1)}>{t("next")} →</Button>
        {done === true && <span className="text-sm font-semibold text-emerald-300">{t("correct")} +10 EXP</span>}
        {done === false && <span className="text-sm text-destructive">{t("incorrect")}</span>}
      </div>
    </div>
  );
}

function WordPuzzle() {
  const { addExp } = useStore();
  const { t } = useI18n();
  const [round, setRound] = useState(0);
  const set = useMemo(() => shuffle(VOCAB_POOL).slice(0, 4), [round]);
  const defs = useMemo(() => shuffle(set.map((s) => s.def)), [set]);
  const [matches, setMatches] = useState<Record<string, string>>({});
  const [picked, setPicked] = useState<string | null>(null);

  useEffect(() => { setMatches({}); setPicked(null); }, [set]);

  const pickWord = (w: string) => setPicked(w);
  const pickDef = (d: string) => {
    if (!picked) return;
    setMatches((m) => ({ ...m, [picked]: d }));
    const target = set.find((s) => s.word === picked);
    if (target && target.def === d) addExp(10);
    setPicked(null);
  };

  const allDone = Object.keys(matches).length === set.length;

  return (
    <div className="rounded-2xl border border-border/60 bg-card p-6">
      <p className="mb-4 text-xs uppercase tracking-widest text-muted-foreground">{t("wordPuzzle")}</p>
      <div className="grid gap-4 md:grid-cols-2">
        <div className="space-y-2">
          {set.map((s) => {
            const matched = matches[s.word];
            const correct = matched && matched === s.def;
            return (
              <button
                key={s.word}
                onClick={() => pickWord(s.word)}
                disabled={!!matched}
                className={`w-full rounded-xl border px-4 py-3 text-left text-sm transition-all ${
                  matched ? (correct ? "border-emerald-500/60 bg-emerald-500/10" : "border-destructive/60 bg-destructive/10") :
                  picked === s.word ? "border-primary bg-primary/15" : "border-border/60 bg-muted/40 hover:border-primary/60"
                }`}
              >
                <span className="font-semibold">{s.word}</span>
              </button>
            );
          })}
        </div>
        <div className="space-y-2">
          {defs.map((d) => {
            const used = Object.values(matches).includes(d);
            return (
              <button
                key={d}
                onClick={() => pickDef(d)}
                disabled={used}
                className={`w-full rounded-xl border px-4 py-3 text-left text-xs transition-all ${
                  used ? "border-border/30 bg-muted/20 text-muted-foreground/60" : "border-border/60 bg-muted/40 hover:border-accent/60"
                }`}
              >
                {d}
              </button>
            );
          })}
        </div>
      </div>
      <div className="mt-4 flex items-center gap-2">
        <Button onClick={() => setRound((r) => r + 1)} disabled={!allDone}>{t("next")} →</Button>
        {allDone && <span className="text-sm font-semibold text-emerald-300">{t("correct")}</span>}
      </div>
    </div>
  );
}

function SyntaxBlaster() {
  return (
    <QuizRunner pool={BLASTER_QUESTIONS} count={8} />
  );
}
