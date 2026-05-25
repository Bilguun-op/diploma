import { createFileRoute, useNavigate } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { useStore } from "@/lib/store";
import { useI18n } from "@/lib/i18n";

import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";

import { Sparkles } from "lucide-react";

import { loginUser, registerUser } from "@/api/auth";

export const Route = createFileRoute("/login")({
  component: LoginPage,
});

function LoginPage() {
  const { login, user } = useStore();

  const { t } = useI18n();

  const nav = useNavigate();

  const [mode, setMode] = useState<"login" | "signup">("login");

  const [name, setName] = useState("");

  const [password, setPassword] = useState("");

  const [loading, setLoading] = useState(false);

  // AUTO REDIRECT IF LOGGED IN
  useEffect(() => {
    if (user.loggedIn) {
      nav({ to: "/" });
    }
  }, [user.loggedIn, nav]);

  const submit = async (e: React.FormEvent) => {
    e.preventDefault();

    if (!name.trim() || !password.trim()) return;

    try {
      setLoading(true);

      let response;

      const payload = {
        name: name.trim(),
        password,
      };

      // SIGNUP FLOW
      if (mode === "signup") {
        await registerUser(payload);

        response = await loginUser(payload);
      }

      // LOGIN FLOW
      else {
        response = await loginUser(payload);
      }

      // 🔥 DEBUG (REMOVE LATER IF WORKING)
      console.log("LOGIN RESPONSE:", response.data);

      // ✅ USE BACKEND RESPONSE PROPERLY
      const backendUser = response.data.user;

      if (!backendUser) {
        throw new Error("Invalid server response");
      }

      // STORE USER IN CONTEXT
      login(backendUser.name, "10");

      nav({ to: "/" });

    } catch (error: any) {
      console.log("LOGIN ERROR:", error);

      alert(
        error?.response?.data?.message ||
        error.message ||
        "Authentication failed"
      );
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="relative grid min-h-[calc(100vh-65px)] place-items-center px-4 py-10">

      <div className="w-full max-w-md rounded-3xl border p-8">

        <div className="text-center mb-6">
          <Sparkles className="mx-auto h-10 w-10" />

          <h1 className="text-xl font-bold mt-2">
            {mode === "login"
              ? "Welcome back"
              : "Create account"}
          </h1>
        </div>

        <form onSubmit={submit} className="space-y-4">

          <div>
            <Label>Name</Label>
            <Input
              value={name}
              onChange={(e) => setName(e.target.value)}
            />
          </div>

          <div>
            <Label>Password</Label>
            <Input
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
            />
          </div>

          <Button type="submit" disabled={loading}>
            {loading
              ? "Loading..."
              : mode === "login"
              ? "Login"
              : "Sign up"}
          </Button>
        </form>

        <p className="text-center mt-4 text-sm">
          <button
            type="button"
            onClick={() =>
              setMode(mode === "login" ? "signup" : "login")
            }
          >
            Switch to {mode === "login" ? "signup" : "login"}
          </button>
        </p>
      </div>
    </div>
  );
}