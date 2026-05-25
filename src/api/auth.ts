import axios from "axios";

// 🔥 USE ENVIRONMENT SWITCH
const API = axios.create({
  baseURL:
    import.meta.env.VITE_API_URL ||
    "https://diploma-backend-7708.onrender.com/api/auth",
});

export const registerUser = (data: {
  name: string;
  password: string;
}) => API.post("/register", data);

export const loginUser = (data: {
  name: string;
  password: string;
}) => API.post("/login", data);