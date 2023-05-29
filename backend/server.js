import express from "express"
import cors from "cors"
import users from "./api/routes/api_routes.js"

const app = express()

app.use(cors())
app.use(express.json())

app.use("/api/", users)
app.use("*", (req, res) => res.status(404).json({ Error: "Not Found"}))

export default app