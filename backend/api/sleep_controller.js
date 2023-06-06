import SleepDAO from "../dao/sleepDAO.js";
export default class SleepController {

    static async apiGetSleepByID(req, res, next) {
          
      let filters = {}
      if (req.query.id) {
        filters.email=req.body.email
        filters.id = req.query.id;
      }
  
      const { sleepList}  = await SleepDAO.getsleepByID ({
          filters,
      })
  
      let response = {
          sleep: sleepList,
          filters: filters,
      }
      res.json(response)
  }
  
    static async apiPostSleep(req, res, next) {
      try {
        const starttime= req.body.starttime;
        const endtime= req.body.endtime;
        const duration= req.body.duration;
        const email= req.query.email;
  
        await SleepDAO.addSleep(
            starttime,
            endtime,
            duration,
            email
        );
        res.json({ Status: "Success" });
      } catch (e) {
        res.status(500).json({ Error: e.message });
      }
    }
    static async apiPutSleep(req, res, next) {
      try {
        const starttime= req.body.starttime;
        const endtime= req.body.endtime;
        const duration= req.body.duration;
        const email= req.query.email;
  
        const userResponse = await SleepDAO.updateSleep(
          req.query.email,
          starttime,
          endtime,
          duration,
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