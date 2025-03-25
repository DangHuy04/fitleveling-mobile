import express from "express";
import authRoutes from "./authRoutes.js";
import registerRoutes from "./registerRoutes.js";

const router = express.Router();

router.use("/login", authRoutes);
router.use("/register", registerRoutes);

export default router;
