import { createFileRoute, useNavigate } from "@tanstack/react-router";
import { useEffect } from "react";
import { useStore } from "@/lib/store";
import { useI18n } from "@/lib/i18n";
import { Switch } from "@/components/ui/switch";
import { Moon, Sun, Trophy, Sparkles } from "lucide-react";

export const Route = createFileRoute("/profile")({
  head: () => ({
    meta: [
      { title: "Account — Mongol English Spark" },
      { name: "description", content: "Your profile, level progress and EXP Trophy Room." },
    ],
  }),
  component: ProfilePage,
});

function ProfilePage() {
  const { user, bootstrapped, setTheme } = useStore();
  const { t, lang, setLang } = useI18n();
  const nav = useNavigate();

  useEffect(() => {
    if (bootstrapped && !user.loggedIn) nav({ to: "/login" });
  }, [bootstrapped, user.loggedIn, nav]);
  if (!bootstrapped || !user.loggedIn) return null;

  const completedLevels = user.levelStatuses.filter((s) => s === "completed").length;
  const currentLevel = Math.min(5, completedLevels + 1);
  const unitsDone = user.unitsCompleted.flat().filter((n) => n >= 3).length;
  const totalUnits = 25;
  const progressPct = Math.min(100, Math.round((unitsDone / totalUnits) * 100));

  return (
    <div className="mx-auto max-w-5xl space-y-6 px-4 py-8 md:px-6">
      <h1 className="text-3xl font-bold tracking-tight md:text-4xl">{t("personalAccount")}</h1>

      <div className="grid gap-4 md:grid-cols-3">
        <div className="md:col-span-2 rounded-3xl border border-border/60 bg-card p-6">
          <div className="flex items-center gap-4">
            <div className="grid h-16 w-16 place-items-center rounded-2xl bg-[image:var(--gradient-hero)] text-2xl font-bold text-primary-foreground">
              {user.name.charAt(0).toUpperCase()}
            </div>
            <div>
              <p className="text-xs uppercase tracking-widest text-muted-foreground">{t("name")}</p>
              <p className="text-xl font-bold">{user.name}</p>
              <p className="text-sm text-muted-foreground">{t("grade")}: {user.grade}</p>
            </div>
          </div>

          <div className="mt-6">
            <div className="mb-2 flex items-center justify-between text-sm">
              <span className="text-muted-foreground">{t("progress")} · {t("level")} {currentLevel}</span>
              <span className="font-semibold">{progressPct}%</span>
            </div>
            <div className="h-3 overflow-hidden rounded-full bg-muted">
              <div
                className="h-full rounded-full bg-[image:var(--gradient-hero)] transition-all duration-700"
                style={{ width: `${progressPct}%` }}
              />
            </div>
            <p className="mt-2 text-xs text-muted-foreground">{unitsDone}/{totalUnits} {t("unit")}</p>
          </div>

          <div className="mt-6">
            <label className="text-xs uppercase tracking-widest text-muted-foreground">{t("language")}</label>
            <select
              value={lang}
              onChange={(e) => setLang(e.target.value as "en" | "mn")}
              className="mt-1 block w-full rounded-lg border border-border/60 bg-input px-3 py-2 text-sm"
            >
              <option value="en">English</option>
              <option value="mn">Монгол</option>
            </select>
          </div>

          <div className="mt-4 flex items-center justify-between gap-4 rounded-xl border border-border/60 bg-background/40 px-4 py-3">
            <div className="flex items-center gap-3">
              {user.theme === "light" ? (
                <Sun className="h-5 w-5 text-amber" />
              ) : (
                <Moon className="h-5 w-5 text-accent" />
              )}
              <div>
                <p className="text-sm font-semibold">Theme</p>
                <p className="text-xs text-muted-foreground">
                  {user.theme === "light" ? "Light mode" : "Dark mode"}
                </p>
              </div>
            </div>
            <Switch
              checked={user.theme === "light"}
              onCheckedChange={(checked) => setTheme(checked ? "light" : "dark")}
              aria-label="Use light mode"
            />
          </div>
        </div>

        <div className="rounded-3xl border border-border/60 bg-[image:var(--gradient-amber)] p-6 text-amber-foreground shadow-[0_0_40px_-8px_oklch(0.82_0.17_80_/_0.5)]">
          <Trophy className="h-8 w-8" />
          <p className="mt-3 text-xs uppercase tracking-widest opacity-80">{t("expRoom")}</p>
          <p className="mt-1 text-5xl font-bold">{user.exp}</p>
          <p className="mt-1 text-sm opacity-90">{t("totalExp")}</p>
        </div>
      </div>

      <div className="rounded-3xl border border-border/60 bg-card p-6">
        <h2 className="mb-4 text-lg font-bold">{t("levels")}</h2>
        <div className="grid gap-3 sm:grid-cols-5">
          {user.levelStatuses.map((s, i) => (
            <div key={i} className={`rounded-2xl border p-4 text-center ${s === "completed" ? "border-emerald-500/60 bg-emerald-500/10" : s === "unlocked" ? "border-primary/60 bg-primary/10" : "border-border/40 bg-muted/30 opacity-60"}`}>
              <Sparkles className="mx-auto h-5 w-5" />
              <p className="mt-2 text-sm font-semibold">{t("level")} {i + 1}</p>
              <p className="mt-1 text-[10px] uppercase tracking-widest text-muted-foreground">{s === "completed" ? t("completed") : s === "unlocked" ? t("unlocked") : t("locked")}</p>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
