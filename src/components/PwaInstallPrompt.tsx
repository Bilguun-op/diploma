import { useEffect, useMemo, useState } from "react";
import { Download, Share, X } from "lucide-react";

import { Button } from "@/components/ui/button";

type BeforeInstallPromptEvent = Event & {
  prompt: () => Promise<void>;
  userChoice: Promise<{ outcome: "accepted" | "dismissed"; platform: string }>;
};

const DISMISSED_KEY = "mes_pwa_install_dismissed";

function isStandalone() {
  if (typeof window === "undefined") return false;

  return (
    window.matchMedia("(display-mode: standalone)").matches ||
    ("standalone" in window.navigator &&
      Boolean((window.navigator as Navigator & { standalone?: boolean }).standalone))
  );
}

function isIos() {
  if (typeof window === "undefined") return false;

  return /iphone|ipad|ipod/i.test(window.navigator.userAgent);
}

export function PwaInstallPrompt() {
  const [installEvent, setInstallEvent] =
    useState<BeforeInstallPromptEvent | null>(null);
  const [visible, setVisible] = useState(false);
  const [dismissed, setDismissed] = useState(false);
  const ios = useMemo(() => isIos(), []);

  useEffect(() => {
    if (typeof window === "undefined") return;

    setDismissed(localStorage.getItem(DISMISSED_KEY) === "true");

    const onBeforeInstallPrompt = (event: Event) => {
      event.preventDefault();
      setInstallEvent(event as BeforeInstallPromptEvent);
      setVisible(true);
    };

    const onInstalled = () => {
      setVisible(false);
      setInstallEvent(null);
      localStorage.setItem(DISMISSED_KEY, "true");
    };

    window.addEventListener("beforeinstallprompt", onBeforeInstallPrompt);
    window.addEventListener("appinstalled", onInstalled);

    if (ios && !isStandalone()) {
      setVisible(true);
    }

    return () => {
      window.removeEventListener("beforeinstallprompt", onBeforeInstallPrompt);
      window.removeEventListener("appinstalled", onInstalled);
    };
  }, [ios]);

  if (dismissed || !visible || isStandalone()) return null;

  const close = () => {
    localStorage.setItem(DISMISSED_KEY, "true");
    setDismissed(true);
    setVisible(false);
  };

  const install = async () => {
    if (!installEvent) return;

    await installEvent.prompt();
    const choice = await installEvent.userChoice;

    if (choice.outcome !== "dismissed") {
      close();
    }

    setInstallEvent(null);
  };

  return (
    <div className="fixed inset-x-3 bottom-3 z-50 mx-auto max-w-md rounded-2xl border border-border/70 bg-card/95 p-4 shadow-[var(--shadow-glow)] backdrop-blur">
      <button
        type="button"
        onClick={close}
        className="absolute right-3 top-3 rounded-full p-1 text-muted-foreground hover:bg-muted hover:text-foreground"
        aria-label="Dismiss install prompt"
      >
        <X className="h-4 w-4" />
      </button>

      <div className="pr-8">
        <p className="text-sm font-semibold">Install Spark</p>
        <p className="mt-1 text-xs text-muted-foreground">
          {ios
            ? "Tap Share, then Add to Home Screen."
            : "Add the app to your home screen for faster mobile learning."}
        </p>
      </div>

      <div className="mt-3 flex gap-2">
        {ios ? (
          <div className="inline-flex items-center gap-2 rounded-lg bg-muted px-3 py-2 text-xs font-semibold">
            <Share className="h-4 w-4" />
            Share, then Add to Home Screen
          </div>
        ) : (
          <Button size="sm" onClick={install} disabled={!installEvent}>
            <Download className="mr-2 h-4 w-4" />
            Install
          </Button>
        )}
      </div>
    </div>
  );
}
