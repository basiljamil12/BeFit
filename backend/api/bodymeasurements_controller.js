import { Double, Int32 } from "mongodb";
import BodyMeasureDAO from "../dao/bodymeasurements_DAO.js";
export default class MeasurementsController {

    static async apiGetMeasurementsByID(req, res, next) {
          
      let filters = {}
      if (req.query.id) {
        filters.bmi=req.body.bmi
        filters.id = req.query.id;
      }
  
      const { MeasurementList } = await BodyMeasureDAO.getMeasurementsByID ({
          filters,
      })
  
      let response = {
          Measurements: MeasurementList,
          filters: filters,
      }
      res.json(response)
  }
  
    static async apiPostMeasurements(req, res, next) {
      try {
        const height= new Int32(req.body.height);
        const weight= new Int32(req.body.weight);
        const bmi= new Double(req.body.bmi);
        const email= req.query.email;
  
        await BodyMeasureDAO.addMeasurements(
            new Int32(height),
            new Int32(weight),
            new Double(bmi),
            email
        );
        res.json({ Status: "Success" });
      } catch (e) {
        res.status(500).json({ Error: e.message });
      }
    }
    static async apiPutMeasurements(req, res, next) {
      try {
        const height= new Int32(req.body.height);
        const weight= new Int32(req.body.weight);
        const bmi= new Double(req.body.bmi);
        const email= req.query.email;
  
        const userResponse = await BodyMeasureDAO.updateMeasurements(
          req.query.email,
          new Int32(height),
          new Int32(weight),
          new Double(bmi),
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

    static async apiDeleteMeasurements(req, res, next) {
        try {
          const email = req.query.email;
        await BodyMeasureDAO.deleteMeasurements(email);
          res.json({ Status: "success" });
        } catch (e) {
          res.status(500).json({ Error: e.message });
        }
      }
}