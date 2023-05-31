import StepsDAO from "../dao/stepsDAO.js";
export default class UserController {

    static async apiGetStepsByID(req, res, next) {
          
      let filters = {}
      if (req.query.id) {
        filters.steps=req.body.steps;
        filters.id = req.query.id;
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
        const steps= req.body.steps;
        const date= req.body.date;
        const userid= req.query.userid;
  
        await StepsDAO.addSteps(
            steps,
            date,
            userid
        );
        res.json({ Status: "Success" });
      } catch (e) {
        res.status(500).json({ Error: e.message });
      }
    }
    static async apiPutSteps(req, res, next) {
      try {
        const steps= req.body.steps;
        const date= req.body.date;
        const userid= req.query.userid;
  
        const userResponse = await StepsDAO.updateSteps(
            steps,
            date,
            userid
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