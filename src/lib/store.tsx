import {
  createContext,
  useContext,
  useEffect,
  useState,
  useRef,
  type ReactNode,
} from "react";
import { toast } from "sonner";

import { getCurrentUser, type AuthUser } from "@/api/auth";

export type LevelStatus = "locked" | "unlocked" | "completed";
export type ThemeMode = "dark" | "light";

export interface UserState {
  id: string;
  name: string;
  grade: string;
  exp: number;
  studyMinutes: number;
  totalStudyMinutes: number;
  studyDate: string;
  levelStatuses: LevelStatus[];
  unitsCompleted: number[][];
  loggedIn: boolean;
  token: string;
  theme: ThemeMode;
}

const todayStr = () => new Date().toISOString().slice(0, 10);

const defaultState: UserState = {
  id: "",
  name: "",
  grade: "",
  exp: 0,
  studyMinutes: 0,
  totalStudyMinutes: 0,
  studyDate: todayStr(),
  levelStatuses: ["unlocked", "unlocked", "unlocked", "unlocked", "unlocked"],
  unitsCompleted: Array.from({ length: 5 }, () => [0, 0, 0, 0, 0]),
  loggedIn: false,
  token: "",
  theme: "dark",
};

interface StoreCtx {
  user: UserState;
  isAuthenticated: boolean;
  bootstrapped: boolean;
  login: (authUser: AuthUser, token: string) => void;
  legacyLogin: (name: string, grade: string) => void;
  logout: () => void;
  addExp: (amount: number) => void;
  addStudyMinutes: (minutes: number) => void;
  setLevelStatus: (idx: number, status: LevelStatus) => void;
  completeModule: (level: number, unit: number) => void;
  setPlacementLevel: (level: number) => void;
  setTheme: (theme: ThemeMode) => void;
}

const Ctx = createContext<StoreCtx | null>(null);

function normalizeState(raw: Partial<UserState> | null): UserState {
  const merged: UserState = {
    ...defaultState,
    ...raw,
    totalStudyMinutes: raw?.totalStudyMinutes ?? 0,
    levelStatuses:
      raw?.levelStatuses?.length === 5
        ? raw.levelStatuses
        : defaultState.levelStatuses,
    unitsCompleted:
      raw?.unitsCompleted?.length === 5
        ? raw.unitsCompleted
        : defaultState.unitsCompleted,
    theme: raw?.theme === "light" ? "light" : "dark",
    token:
      raw?.token ||
      (typeof window !== "undefined"
        ? localStorage.getItem("mes_token") || ""
        : ""),
  };

  if (merged.studyDate !== todayStr()) {
    merged.studyDate = todayStr();
    merged.studyMinutes = 0;
  }

  merged.loggedIn = Boolean(merged.token && merged.name);
  return merged;
}

export function StoreProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<UserState>(defaultState);
  const [bootstrapped, setBootstrapped] = useState(false);
  const timerRef = useRef<number | null>(null);

  const persist = (nextUser: UserState) => {
    setUser(nextUser);

    if (typeof window === "undefined") return;

    localStorage.setItem("mes_user", JSON.stringify(nextUser));

    if (nextUser.token) {
      localStorage.setItem("mes_token", nextUser.token);
    } else {
      localStorage.removeItem("mes_token");
    }
  };

  useEffect(() => {
    if (typeof window === "undefined") {
      setBootstrapped(true);
      return;
    }

    const raw = localStorage.getItem("mes_user");
    const parsed = raw ? (JSON.parse(raw) as Partial<UserState>) : null;
    const restored = normalizeState(parsed);

    setUser(restored);

    if (!restored.token) {
      setBootstrapped(true);
      return;
    }

    getCurrentUser()
      .then(({ data }) => {
        persist(
          normalizeState({
            ...restored,
            id: data.user.id,
            name: data.user.name,
            grade: data.user.grade || restored.grade,
            loggedIn: true,
          }),
        );
      })
      .catch(() => {
        persist({ ...defaultState, theme: restored.theme });
      })
      .finally(() => setBootstrapped(true));
  }, []);

  useEffect(() => {
    if (typeof document === "undefined") return;

    document.documentElement.classList.toggle("light", user.theme === "light");
    document.documentElement.style.colorScheme =
      user.theme === "light" ? "light" : "dark";
  }, [user.theme]);

  // Global study timer - runs across all pages
  useEffect(() => {
    let secondsCount = 0;

    const startTimer = () => {
      if (timerRef.current) window.clearInterval(timerRef.current);
      timerRef.current = window.setInterval(() => {
        secondsCount += 1;
        if (secondsCount % 60 === 0) {
          setUser((prevUser) => {
            const newDate = todayStr();
            const isSameDay = prevUser.studyDate === newDate;
            const updatedUser = {
              ...prevUser,
              studyMinutes: isSameDay ? prevUser.studyMinutes + 1 : 1,
              totalStudyMinutes: prevUser.totalStudyMinutes + 1,
              studyDate: newDate,
            };
            // Persist to localStorage
            if (typeof window !== "undefined") {
              localStorage.setItem("mes_user", JSON.stringify(updatedUser));
            }
            return updatedUser;
          });
        }
      }, 1000);
    };

    const stopTimer = () => {
      if (timerRef.current) {
        window.clearInterval(timerRef.current);
        timerRef.current = null;
      }
    };

    const handleVisibilityChange = () => {
      if (document.hidden) {
        stopTimer();
      } else {
        startTimer();
      }
    };

    // Start timer on mount if user is logged in
    if (user.loggedIn) {
      startTimer();
    }

    document.addEventListener("visibilitychange", handleVisibilityChange);

    return () => {
      if (timerRef.current) window.clearInterval(timerRef.current);
      document.removeEventListener("visibilitychange", handleVisibilityChange);
    };
  }, [user.loggedIn]);

  const login = (authUser: AuthUser, token: string) => {
    persist(
      normalizeState({
        ...user,
        id: authUser.id,
        name: authUser.name,
        grade: authUser.grade || user.grade || "10",
        token,
        loggedIn: true,
      }),
    );
  };

  const legacyLogin = (name: string, grade: string) => {
    persist(
      normalizeState({
        ...user,
        name,
        grade,
        token: user.token || "local-session",
        loggedIn: true,
      }),
    );
  };

  const logout = () => {
    persist({ ...defaultState, theme: user.theme });
  };

  const addExp = (amount: number) => {
    persist({ ...user, exp: user.exp + amount });
    toast.success(`+${amount} EXP`, { description: "Keep going!" });
  };

  const addStudyMinutes = (minutes: number) => {
    persist({
      ...user,
      studyMinutes: user.studyMinutes + minutes,
      totalStudyMinutes: user.totalStudyMinutes + minutes,
      studyDate: todayStr(),
    });
  };

  const setLevelStatus = (idx: number, status: LevelStatus) => {
    const levelStatuses = [...user.levelStatuses];
    levelStatuses[idx] = status;

    if (
      status === "completed" &&
      idx + 1 < levelStatuses.length &&
      levelStatuses[idx + 1] === "locked"
    ) {
      levelStatuses[idx + 1] = "unlocked";
    }

    persist({ ...user, levelStatuses });
  };

  const completeModule = (level: number, unit: number) => {
    const unitsCompleted = user.unitsCompleted.map((row) => [...row]);

    if (unitsCompleted[level][unit] < 3) {
      unitsCompleted[level][unit] += 1;
    }

    persist({ ...user, unitsCompleted });
  };

  const setPlacementLevel = (level: number) => {
    const levelStatuses: LevelStatus[] = [
      "locked",
      "locked",
      "locked",
      "locked",
      "locked",
    ];

    for (let i = 0; i < level; i += 1) {
      levelStatuses[i] = "completed";
    }

    levelStatuses[level] = "unlocked";
    persist({ ...user, levelStatuses });
  };

  const setTheme = (theme: ThemeMode) => {
    persist({ ...user, theme });
  };

  return (
    <Ctx.Provider
      value={{
        user,
        isAuthenticated: user.loggedIn,
        bootstrapped,
        login,
        legacyLogin,
        logout,
        addExp,
        addStudyMinutes,
        setLevelStatus,
        completeModule,
        setPlacementLevel,
        setTheme,
      }}
    >
      {children}
    </Ctx.Provider>
  );
}

export function useStore() {
  const ctx = useContext(Ctx);
  if (!ctx) throw new Error("useStore must be used within StoreProvider");
  return ctx;
}
