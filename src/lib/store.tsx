import {
  createContext,
  useContext,
  useEffect,
  useState,
  type ReactNode,
} from "react";
import { toast } from "sonner";

export type LevelStatus = "locked" | "unlocked" | "completed";
export type ThemeMode = "dark" | "light";

export interface UserState {
  name: string;
  grade: string;
  exp: number;
  studyMinutes: number;
  totalStudyMinutes: number;
  studyDate: string;
  levelStatuses: LevelStatus[];
  unitsCompleted: number[][];
  loggedIn: boolean;
  theme: ThemeMode;
}

const todayStr = () => new Date().toISOString().slice(0, 10);

const defaultState: UserState = {
  name: "",
  grade: "",
  exp: 0,
  studyMinutes: 0,
  totalStudyMinutes: 0,
  studyDate: todayStr(),
  levelStatuses: ["unlocked", "unlocked", "unlocked", "unlocked", "unlocked"],
  unitsCompleted: Array.from({ length: 5 }, () => [0, 0, 0, 0, 0]),
  loggedIn: false,
  theme: "dark",
};

interface StoreCtx {
  user: UserState;
  login: (name: string, grade: string) => void;
  logout: () => void;
  addExp: (amount: number) => void;
  addStudyMinutes: (m: number) => void;
  setLevelStatus: (idx: number, s: LevelStatus) => void;
  completeModule: (level: number, unit: number) => void;
  setPlacementLevel: (level: number) => void;
  setTheme: (theme: ThemeMode) => void;

  // ✅ FIX ADDED
  isAuthenticated: boolean;
}

const Ctx = createContext<StoreCtx | null>(null);

export function StoreProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<UserState>(defaultState);

  useEffect(() => {
    if (typeof window === "undefined") return;

    const raw = localStorage.getItem("mes_user");

    if (raw) {
      try {
        const parsed = JSON.parse(raw) as UserState;

        if (parsed.studyDate !== todayStr()) {
          parsed.studyDate = todayStr();
          parsed.studyMinutes = 0;
        }

        // Ensure totalStudyMinutes exists for backward compatibility
        if (!parsed.totalStudyMinutes) {
          parsed.totalStudyMinutes = 0;
        }

        if (!parsed.theme) {
          parsed.theme = "dark";
        }

        setUser(parsed);
      } catch {}
    }
  }, []);

  useEffect(() => {
    if (typeof document === "undefined") return;

    document.documentElement.classList.toggle("light", user.theme === "light");
  }, [user.theme]);

  const persist = (u: UserState) => {
    setUser(u);
    if (typeof window !== "undefined") {
      localStorage.setItem("mes_user", JSON.stringify(u));
    }
  };

  const login = (name: string, grade: string) => {
    persist({ ...defaultState, name, grade, loggedIn: true });
  };

  const logout = () => {
    persist({ ...defaultState });

    if (typeof window !== "undefined") {
      localStorage.removeItem("mes_user");
    }
  };

  const addExp = (amount: number) => {
    persist({ ...user, exp: user.exp + amount });
    toast.success(`+${amount} EXP`, { description: "Keep going!" });
  };

  const addStudyMinutes = (m: number) => {
    persist({
      ...user,
      studyMinutes: user.studyMinutes + m,
      totalStudyMinutes: user.totalStudyMinutes + m,
      studyDate: todayStr(),
    });
  };

  const setLevelStatus = (idx: number, s: LevelStatus) => {
    const arr = [...user.levelStatuses];
    arr[idx] = s;

    if (
      s === "completed" &&
      idx + 1 < arr.length &&
      arr[idx + 1] === "locked"
    ) {
      arr[idx + 1] = "unlocked";
    }

    persist({ ...user, levelStatuses: arr });
  };

  const completeModule = (level: number, unit: number) => {
    const grid = user.unitsCompleted.map((r) => [...r]);

    if (grid[level][unit] < 3) grid[level][unit] += 1;

    persist({ ...user, unitsCompleted: grid });
  };

  const setPlacementLevel = (level: number) => {
    const arr: LevelStatus[] = [
      "locked",
      "locked",
      "locked",
      "locked",
      "locked",
    ];

    for (let i = 0; i < level; i++) arr[i] = "completed";

    arr[level] = "unlocked";

    persist({ ...user, levelStatuses: arr });
  };

  // ✅ FIX ADDED
  const setTheme = (theme: ThemeMode) => {
    persist({ ...user, theme });
  };

  const isAuthenticated = user.loggedIn;

  return (
    <Ctx.Provider
      value={{
        user,
        login,
        logout,
        addExp,
        addStudyMinutes,
        setLevelStatus,
        completeModule,
        setPlacementLevel,
        setTheme,
        isAuthenticated,
      }}
    >
      {children}
    </Ctx.Provider>
  );
}

export function useStore() {
  const c = useContext(Ctx);
  if (!c) throw new Error("useStore must be used within StoreProvider");
  return c;
}
