import axios from "axios";

export interface AuthUser {
  id: string;
  name: string;
  grade?: string;
}

export interface AuthResponse {
  token: string;
  user: AuthUser;
}

export interface AuthPayload {
  name: string;
  password: string;
  grade?: string;
}

const rawBaseUrl =
  import.meta.env.VITE_API_URL || "https://diploma-backend-7708.onrender.com";

const baseURL = rawBaseUrl.replace(/\/$/, "").endsWith("/api")
  ? rawBaseUrl.replace(/\/$/, "")
  : `${rawBaseUrl.replace(/\/$/, "")}/api`;

export const api = axios.create({
  baseURL,
  timeout: 20000,
  headers: {
    "Content-Type": "application/json",
  },
});

api.interceptors.request.use((config) => {
  if (typeof window === "undefined") return config;

  const token = localStorage.getItem("mes_token");
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }

  return config;
});

export const registerUser = (data: AuthPayload) =>
  api.post<AuthResponse>("/auth/register", data);

export const loginUser = (data: AuthPayload) =>
  api.post<AuthResponse>("/auth/login", data);

export const getCurrentUser = () => api.get<{ user: AuthUser }>("/auth/me");
