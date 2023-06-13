import mongodb, { Double, Int32 } from "mongodb";
const ObjectId = mongodb.ObjectId;

let Measurements;

export default class BodyMeasureDAO {
  static async injectDB(conn) {
    if (Measurements) {
      return;
    }
    try {
      Measurements = await conn.db(process.env.MONGO_NS).collection("BodyMeasurements");
    } catch (e) {
      console.error(`Unable to establish a collection handle in BodyMeasurementsDAO: ${e}`);
    }
  }

  static async getMeasurementsByID({ filters = null } = {}) {
    let match;
    if (filters) {
      if ("id" in filters) {
        match = { email: filters["id"] };
      }
    }
    let cursor;
    try {
      if (!Measurements) {
        throw new Error("BodyMeasurements collection is undefined");
      }
    
      cursor = await Measurements.find(match);
    } catch (e) {
      console.error(`Unable to issue find command, ${e}`);
      return { MeasurementList: [] , total_results: 0};
    }

    try {
      const MeasurementList = await cursor.toArray();
      const total_results = await Measurements.countDocuments(match);

      return { MeasurementList,total_results };
    } catch (e) {
      console.error(
        `Unable to convert cursor to array or problem counting documents, ${e}`
      );
      return { MeasurementList: [], total_results: 0};
    }
  }

  static async addMeasurements(height, weight,bmi, email) {
    try {
      const MeasurementDoc = {
        height: new Int32(height),
        weight: new Int32(weight),
        bmi: new Double(bmi),
        email: email,
      };
      return await Measurements.insertOne(MeasurementDoc);
    } catch (e) {
      console.error(`Unable to add measurements: ${e}`);
      return { Error: e };
    }
  }

  static async updateMeasurements(id,height, weight,bmi, email) {
    try {
      const updateResponse = await Measurements.updateOne(
        { _id: new ObjectId(id) },
        {
          $set: {
            height: new Int32(height),
            weight: new Int32(weight),
            bmi: new Double(bmi),
            email: email,
          },
        }
      );
      return updateResponse;
    } catch (e) {
      console.error(`Unable to update measurements: ${e}`);
      return { Error: e };
    }
  }

  static async deleteMeasurements(email) {
    try {
      const deleteResponse = await Measurements.deleteOne({
        email: email,
      });
      return deleteResponse;
    } catch (e) {
      console.error(`Unable to delete measurements: ${e}`);
      return { Error: e };
    }
  }
}
