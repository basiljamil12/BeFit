import { Double, Int32 } from "mongodb";
import BodyMeasureDAO from "../dao/bodymeasurements_DAO.js";
export default class MeasurementsController {

    static async apiGetMeasurementsByID(req, res, next) {
          
      let filters = {}
      if (req.query.id) {
        filters.id = req.query.id;
      }
  
      const { MeasurementList,total_results } = await BodyMeasureDAO.getMeasurementsByID ({
          filters,
         
      })
  
      let response = {
          Measurements: MeasurementList,
          filters: filters,
          total_results: total_results,
          
      }
      res.json(response)
  }
  
    static async apiPostMeasurements(req, res, next) {
      try {
        const height= new Int32(req.body.height);
        const weight= new Int32(req.body.weight);
        const email= req.body.email;
  
        await BodyMeasureDAO.addMeasurements(
            new Int32(height),
            new Int32(weight),
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
        const email= req.body.email;
  
        const userResponse = await BodyMeasureDAO.updateMeasurements(
          req.query.id,
          new Int32(height),
          new Int32(weight),
          email
        );
        var { error } = userResponse;
        if (error) {
          res.status(400).json({ error });
        }
        if (userResponse.modifiedCount === 0) {
          throw new Error("Unable to update the measurements");
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