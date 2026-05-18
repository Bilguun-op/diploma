import { Link, useRouterState, useNavigate } from "@tanstack/react-router";
import { useI18n } from "@/lib/i18n";
import { useStore } from "@/lib/store";
import { Button } from "@/components/ui/button";
import { Sparkles, Home, BookOpen, Gamepad2, User, LogOut, Languages } from "lucide-react";

export function AppHeader() {
  const { lang, setLang, t } = useI18n();
  const { user, logout } = useStore();
  const path = useRouterState({ select: (s) => s.location.pathname });
  const navigate = useNavigate();

  const nav = [
    { to: "/", label: t("home"), icon: Home },
    { to: "/grammar", label: t("grammar"), icon: BookOpen },
    { to: "/arcade", label: t("arcade"), icon: Gamepad2 },
    { to: "/profile", label: t("account"), icon: User },
  ] as const;

  return (
    <header className="sticky top-0 z-40 border-b border-border/60 bg-background/80 backdrop-blur-xl">
      <div className="mx-auto flex max-w-7xl items-center justify-between px-4 py-3 md:px-6">
        <Link to="/" className="flex items-center gap-2 font-bold tracking-tight">
          <span className="grid h-9 w-9 place-items-center rounded-lg bg-[image:var(--gradient-hero)] shadow-[var(--shadow-glow)]">
            <Sparkles className="h-5 w-5 text-primary-foreground" />
          </span>
          <span className="hidden text-base sm:inline">{t("appName")}</span>
        </Link>

        {user.loggedIn && (
          <nav className="hidden items-center gap-1 md:flex">
            {nav.map((n) => {
              const active = path === n.to;
              return (
                <Link
                  key={n.to}
                  to={n.to}
                  className={`flex items-center gap-2 rounded-lg px-3 py-2 text-sm font-medium transition-all ${
                    active
                      ? "bg-primary/15 text-primary shadow-[var(--shadow-glow)]"
                      : "text-muted-foreground hover:bg-muted hover:text-foreground"
                  }`}
                >
                  <n.icon className="h-4 w-4" />
                  {n.label}
                </Link>
              );
            })}
          </nav>
        )}

        <div className="flex items-center gap-2">
          <div className="flex items-center gap-1 rounded-full border border-border/60 bg-muted/50 p-1 text-xs">
            <Languages className="ml-2 h-3 w-3 text-muted-foreground" />
            <button
              onClick={() => setLang("en")}
              className={`rounded-full px-3 py-1 font-semibold transition ${
                lang === "en" ? "bg-primary text-primary-foreground" : "text-muted-foreground"
              }`}
            >
              EN
            </button>
            <button
              onClick={() => setLang("mn")}
              className={`rounded-full px-3 py-1 font-semibold transition ${
                lang === "mn" ? "bg-primary text-primary-foreground" : "text-muted-foreground"
              }`}
            >
              МН
            </button>
          </div>
          {user.loggedIn && (
            <Button
              variant="ghost"
              size="icon"
              onClick={() => {
                logout();
                navigate({ to: "/login" });
              }}
              title={t("logout")}
            >
              <LogOut className="h-4 w-4" />
            </Button>
          )}
        </div>
      </div>

      {user.loggedIn && (
        <nav className="grid grid-cols-4 gap-1 border-t border-border/60 bg-background/60 px-2 py-2 md:hidden">
          {nav.map((n) => {
            const active = path === n.to;
            return (
              <Link
                key={n.to}
                to={n.to}
                className={`flex flex-col items-center gap-1 rounded-md py-1 text-[11px] ${
                  active ? "text-primary" : "text-muted-foreground"
                }`}
              >
                <n.icon className="h-4 w-4" />
                {n.label}
              </Link>
            );
          })}
        </nav>
      )}
    </header>
  );
}