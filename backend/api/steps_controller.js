import { Int32 } from "mongodb";
import StepsDAO from "../dao/stepsDAO.js";
export default class StepsController {



  static async apiGetSteps(req, res, next) {
    try {
      const { id, date } = req.query;
      let filters = {}
      if (req.query.id) {
        filters.email=req.body.email
        if(id){
        filters.id = req.query.id;
        }
        if(date){
          filters.date = req.query.date;
        }
      
    }
  
      const { stepsList, totalNumSteps } = await StepsDAO.getsteps({ filters, });
  
      const response = {
        steps: stepsList,
        total_steps: totalNumSteps,
        filters: filters,
      };
  
      res.json(response);
  
      // Clean up filters object
      delete filters.id;
      delete filters.date;
    } catch (error) {
      console.error(`Error in getStepsController: ${error}`);
      res.status(500).json({ error: 'Internal server error' });
    }
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
          throw new Error("Unable to update the steps");
        }
        res.json({ Status: "Success" });
      } catch (e) {
        res.status(500).json({ Error: e.message });
      }
    }
}