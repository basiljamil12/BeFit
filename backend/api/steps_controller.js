import { Int32 } from "mongodb";
import StepsDAO from "../dao/stepsDAO.js";
export default class StepsController {

    static async apiGetStepsByID(req, res, next) {
          
      let filters = {}
      if ( req.query.id ) {
        filters.steps=req.body.steps
        filters.id = req.query.id;
        filters.date = req.query.date;
      }
  
      const { stepsList, totalNumSteps } = await StepsDAO.getstepsByID ({
          filters,
      })
  
      let response = {
          steps: stepsList,
          filters: filters,
          total_results: totalNumSteps,
      }
      res.json(response)
  }
  
    static async apiPostSteps(req, res, next) {
      try {
        const steps= new Int32(req.body.steps);
        const date= req.body.date;
        const email= req.body.email;
  
        await StepsDAO.addStep(
          new Int32(steps),
            date,
            email
        );
        res.json({ Status: "Success" });
      } catch (e) {
        res.status(500).json({ Error: e.message });
      }
    }
    static async apiPutSteps(req, res, next) {
      try {
        const steps= new Int32(req.body.steps);
        const date= req.body.date;
        const email= req.body.email;
  
        const userResponse = await StepsDAO.updateStep(
          req.query.id,
          new Int32(steps),
            date,
            email
        );
        var { error } = userResponse;
        if (error) {
          res.status(400).json({ error });
        }
        if (userResponse.modifiedCount === 0) {
          throw new Error("Unable to update the user");
        }
        res.json({ Status: "Success" });
      } catch (e) {
        res.status(500).json({ Error: e.message });
      }
    }
}