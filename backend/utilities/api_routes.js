import express from "express"
import UserControl from "../api/user_controller.js"
import { RouterProvider } from "react-router-dom"

//all the routes will be placed in this file

const router = express.Router()

//routes here
router
    .route("/login")
    .get(UserControl.apiGetUserID)

router
    .route("/userprofile")
    .get(UserControl.apiGetUserID)
    .post(UserControl.apiPostUser)
    .put(UserControl.apiPutUser)
    .delete(UserControl.apiDeleteUser)

export default router