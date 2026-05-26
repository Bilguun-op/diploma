import { createFileRoute, useNavigate } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { Sparkles } from "lucide-react";

import { loginUser, registerUser } from "@/api/auth";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { useI18n } from "@/lib/i18n";
import { useStore } from "@/lib/store";

export const Route = createFileRoute("/login")({
  component: LoginPage,
});

function LoginPage() {
  const { login, user } = useStore();
  const { t } = useI18n();
  const navigate = useNavigate();

  const [mode, setMode] = useState<"login" | "signup">("login");
  const [name, setName] = useState("");
  const [grade, setGrade] = useState("10");
  const [password, setPassword] = useState("");
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    if (user.loggedIn) {
      navigate({ to: "/" });
    }
  }, [user.loggedIn, navigate]);

  const submit = async (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();

    const trimmedName = name.trim();
    const trimmedGrade = grade.trim();

    if (!trimmedName || !password.trim()) return;

    try {
      setLoading(true);

      const payload = {
        name: trimmedName,
        password,
        grade: trimmedGrade,
      };

      const response =
        mode === "signup"
          ? await registerUser(payload)
          : await loginUser(payload);

      login(response.data.user, response.data.token);
      navigate({ to: "/" });
    } catch (error: unknown) {
      const maybeError = error as {
        response?: { data?: { message?: string } };
        message?: string;
      };

      alert(
        maybeError.response?.data?.message ||
          maybeError.message ||
          "Authentication failed",
      );
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="relative grid min-h-[calc(100svh-65px)] place-items-center px-4 py-8 sm:py-10">
      <div className="w-full max-w-md rounded-3xl border border-border/60 bg-card p-5 shadow-[var(--shadow-glow)] sm:p-8">
        <div className="mb-6 text-center">
          <Sparkles className="mx-auto h-10 w-10 text-primary" />
          <h1 className="mt-2 text-xl font-bold">
            {mode === "login" ? t("welcome") : t("startJourney")}
          </h1>
        </div>

        <form onSubmit={submit} className="space-y-4">
          <div className="space-y-1.5">
            <Label htmlFor="name">{t("name")}</Label>
            <Input
              id="name"
              autoComplete="username"
              value={name}
              onChange={(event) => setName(event.target.value)}
            />
          </div>

          {mode === "signup" && (
            <div className="space-y-1.5">
              <Label htmlFor="grade">{t("grade")}</Label>
              <Input
                id="grade"
                autoComplete="organization-title"
                value={grade}
                onChange={(event) => setGrade(event.target.value)}
              />
            </div>
          )}

          <div className="space-y-1.5">
            <Label htmlFor="password">{t("password")}</Label>
            <Input
              id="password"
              type="password"
              autoComplete={mode === "login" ? "current-password" : "new-password"}
              value={password}
              onChange={(event) => setPassword(event.target.value)}
            />
          </div>

          <Button type="submit" disabled={loading} className="w-full">
            {loading ? "Loading..." : mode === "login" ? t("login") : t("signup")}
          </Button>
        </form>

        <p className="mt-4 text-center text-sm text-muted-foreground">
          <button
            type="button"
            onClick={() => setMode(mode === "login" ? "signup" : "login")}
            className="font-semibold text-primary"
          >
            {mode === "login" ? t("noAccount") : t("haveAccount")}
          </button>
        </p>
      </div>
    </div>
  );
}
