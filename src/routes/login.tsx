import { createFileRoute, useNavigate } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { useStore } from "@/lib/store";
import { useI18n } from "@/lib/i18n";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Sparkles } from "lucide-react";

export const Route = createFileRoute("/login")({
  head: () => ({
    meta: [
      { title: "Log in — Mongol English Spark" },
      { name: "description", content: "Log in or sign up to begin your English learning journey." },
    ],
  }),
  component: LoginPage,
});

function LoginPage() {
  const { login, user } = useStore();
  const { t } = useI18n();
  const nav = useNavigate();
  const [mode, setMode] = useState<"login" | "signup">("signup");
  const [name, setName] = useState("");
  const [grade, setGrade] = useState("10");

  useEffect(() => {
    if (user.loggedIn) nav({ to: "/" });
  }, [user.loggedIn, nav]);

  const submit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!name.trim()) return;
    login(name.trim(), grade);
    nav({ to: "/" });
  };

  return (
    <div className="relative grid min-h-[calc(100vh-65px)] place-items-center overflow-hidden px-4 py-10">
      <div className="pointer-events-none absolute inset-0 -z-10 opacity-60">
        <div className="absolute -top-20 left-1/4 h-72 w-72 rounded-full bg-primary/30 blur-3xl" />
        <div className="absolute bottom-0 right-1/4 h-80 w-80 rounded-full bg-accent/20 blur-3xl" />
      </div>
      <div className="w-full max-w-md rounded-3xl border border-border/60 bg-card/80 p-8 shadow-[var(--shadow-glow)] backdrop-blur-xl">
        <div className="mb-6 text-center">
          <span className="mx-auto grid h-14 w-14 place-items-center rounded-2xl bg-[image:var(--gradient-hero)] shadow-[var(--shadow-glow)]">
            <Sparkles className="h-7 w-7 text-primary-foreground" />
          </span>
          <h1 className="mt-4 text-2xl font-bold">
            {mode === "login" ? t("welcome") : t("startJourney")}
          </h1>
          <p className="mt-1 text-sm text-muted-foreground">{t("appName")}</p>
        </div>
        <form onSubmit={submit} className="space-y-4">
          <div>
            <Label htmlFor="name">{t("name")}</Label>
            <Input id="name" value={name} onChange={(e) => setName(e.target.value)} required placeholder="Bat-Erdene" />
          </div>
          <div>
            <Label htmlFor="grade">{t("grade")}</Label>
            <Input id="grade" value={grade} onChange={(e) => setGrade(e.target.value)} placeholder="10" />
          </div>
          <Button type="submit" className="w-full bg-[image:var(--gradient-hero)] text-primary-foreground hover:opacity-90">
            {t("continue")}
          </Button>
        </form>
        <p className="mt-5 text-center text-sm text-muted-foreground">
          {mode === "login" ? t("noAccount") : t("haveAccount")}{" "}
          <button onClick={() => setMode(mode === "login" ? "signup" : "login")} className="font-semibold text-accent hover:underline">
            {mode === "login" ? t("signup") : t("login")}
          </button>
        </p>
      </div>
    </div>
  );
}