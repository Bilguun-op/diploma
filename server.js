const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
require("dotenv").config();

const authRoutes = require("./routes/authRoutes");

const app = express();

// 🔥 FIXED CORS FOR MOBILE + DEPLOYMENT
app.use(
  cors({
    origin: "*",
    methods: ["GET", "POST", "PUT", "DELETE"],
  })
);

app.use(express.json());

// TEST
app.get("/", (req, res) => {
  res.send("Spark Backend Running");
});

// ROUTES
app.use("/api/auth", authRoutes);

// DB CONNECT + SERVER START
mongoose
  .connect(process.env.MONGO_URI)
  .then(() => {
    console.log("MongoDB Connected");

    const PORT = process.env.PORT || 5000;

    app.listen(PORT, () => {
      console.log(`Server running on port ${PORT}`);
    });
  })
  .catch((err) => {
    console.log("MongoDB Error:", err);
  });