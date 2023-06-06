import express from "express"
import UserControl from "../api/user_controller.js"
import StepsControl from "../api/steps_controller.js"
import bodyMeasureControl from "../api/bodymeasurements_controller.js"
import sleepcontrol from "../api/sleep_controller.js"
import { RouterProvider } from "react-router-dom"

//all the routes will be placed in this file

const router = express.Router()

//routes here
router
    .route("/login")
    .get(UserControl.apiGetUserID)

router
    .route("/userprofile")
    .get(UserControl.apiGetUsers)
    .post(UserControl.apiPostUser)
    .put(UserControl.apiPutUser)
    .delete(UserControl.apiDeleteUser)

router
    .route("/steps")
    .get(StepsControl.apiGetStepsByID)
    .post(StepsControl.apiPostSteps)
    .put(StepsControl.apiPutSteps)

router
    .route("/measurements")
    .get(bodyMeasureControl.apiGetMeasurementsByID)
    .post(bodyMeasureControl.apiPostMeasurements)
    .put(bodyMeasureControl.apiPutMeasurements)
    .delete(bodyMeasureControl.apiDeleteMeasurements)

router
    .route("/sleep")
    .get(sleepcontrol.apiGetSleepByID)
    .post(sleepcontrol.apiPostSleep)
    .put(sleepcontrol.apiPutSleep)

export default router