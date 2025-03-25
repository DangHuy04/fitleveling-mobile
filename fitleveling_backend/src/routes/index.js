import express from "express";
import authRoutes from "./authRoutes.js";
import registerRoutes from "./registerRoutes.js";
import petRoutes from "./petRoutes.js";

const router = express.Router();

router.use("/login", authRoutes);
router.use("/register", registerRoutes);
router.use("/", petRoutes);

export default router;
