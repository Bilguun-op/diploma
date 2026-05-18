import { useMemo, useState } from "react";
import type { QuizQ } from "@/lib/content";
import { shuffle } from "@/lib/content";
import { Button } from "@/components/ui/button";
import { useStore } from "@/lib/store";
import { useI18n } from "@/lib/i18n";
import { Check, X } from "lucide-react";

export function QuizRunner({
  pool,
  count = 5,
  onDone,
}: {
  pool: QuizQ[];
  count?: number;
  onDone?: (score: number, total: number) => void;
}) {
  const { addExp } = useStore();
  const { t } = useI18n();
  const questions = useMemo(() => shuffle(pool).slice(0, Math.min(count, pool.length)), [pool, count]);
  const [i, setI] = useState(0);
  const [picked, setPicked] = useState<number | null>(null);
  const [score, setScore] = useState(0);
  const [done, setDone] = useState(false);

  if (done) {
    return (
      <div className="rounded-2xl border border-border/60 bg-card p-6 text-center">
        <p className="text-sm uppercase tracking-widest text-muted-foreground">{t("testScore")}</p>
        <p className="mt-2 text-5xl font-bold text-primary">
          {score}/{questions.length}
        </p>
        <Button className="mt-6" onClick={() => onDone?.(score, questions.length)}>
          {t("finish")}
        </Button>
      </div>
    );
  }

  const q = questions[i];
  const correct = picked !== null && picked === q.answer;

  const next = () => {
    if (picked === null) return;
    if (i + 1 >= questions.length) {
      setDone(true);
      return;
    }
    setI(i + 1);
    setPicked(null);
  };

  const choose = (idx: number) => {
    if (picked !== null) return;
    setPicked(idx);
    if (idx === q.answer) {
      setScore((s) => s + 1);
      addExp(10);
    }
  };

  return (
    <div className="rounded-2xl border border-border/60 bg-card p-6">
      <div className="mb-4 flex items-center justify-between text-xs text-muted-foreground">
        <span>
          {t("question")} {i + 1} {t("of")} {questions.length}
        </span>
        <span className="rounded-full bg-primary/15 px-2 py-0.5 font-semibold text-primary">
          {score} {t("exp")}
        </span>
      </div>
      <h3 className="mb-5 text-lg font-semibold">{q.q}</h3>
      <div className="grid gap-2">
        {q.options.map((opt, idx) => {
          const isPicked = picked === idx;
          const isCorrect = q.answer === idx;
          const show = picked !== null;
          return (
            <button
              key={idx}
              onClick={() => choose(idx)}
              className={`flex items-center justify-between rounded-xl border px-4 py-3 text-left text-sm transition-all ${
                show && isCorrect
                  ? "border-emerald-500/60 bg-emerald-500/10 text-emerald-200"
                  : show && isPicked && !isCorrect
                    ? "border-destructive/60 bg-destructive/10 text-destructive"
                    : "border-border/60 bg-muted/40 hover:border-primary/60 hover:bg-primary/5"
              }`}
            >
              <span>{opt}</span>
              {show && isCorrect && <Check className="h-4 w-4" />}
              {show && isPicked && !isCorrect && <X className="h-4 w-4" />}
            </button>
          );
        })}
      </div>
      <div className="mt-5 flex items-center justify-between">
        <span className="text-xs text-muted-foreground">
          {picked === null ? "" : correct ? t("correct") : t("incorrect")}
        </span>
        <Button onClick={next} disabled={picked === null}>
          {i + 1 >= questions.length ? t("finish") : t("next")}
        </Button>
      </div>
    </div>
  );
}