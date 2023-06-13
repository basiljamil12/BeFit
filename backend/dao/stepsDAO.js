import mongodb, { Int32 } from "mongodb";
const ObjectId = mongodb.ObjectId;

let Steps;

export default class StepsDAO {
  static async injectDB(conn) {
    if (Steps) {
      return;
    }
    try {
      Steps = await conn.db(process.env.MONGO_NS).collection("Steps");
    } catch (e) {
      console.error(`Unable to establish a collection handle in stepsDAO: ${e}`);
    }
  }
  
  static async getsteps({ filters = null } = {}) {
    let match= {};
    if (filters) {
      if ("id" in filters) {
        match.email = filters["id"];
        if ("date" in filters) {
          match.date = filters["date"];
        }
      }
    }
    let cursor;
    try {
      if (!Steps) {
        throw new Error("Steps collection is undefined");
      }
    
      cursor = await Steps.find(match);
    } catch (e) {
      console.error(`Unable to issue find command, ${e}`);
      return { stepsList: [], totalNumSteps: 0 };
    }

    try {
      const stepsList = await cursor.toArray();
      const totalNumSteps =  await Steps.countDocuments(match);
      

      return { stepsList, totalNumSteps };
    } catch (e) {
      console.error(
        `Unable to convert cursor to array or problem counting documents, ${e}`
      );
      return { stepsList: [], totalNumSteps: 0 };
    }
  }
  
  static async addStep(steps, date, email) {
    try {
      const stepsDoc = {
        steps: new Int32(steps),
        date: date,
        email: email,
      };
      return await Steps.insertOne(stepsDoc);
    } catch (e) {
      console.error(`Unable to add steps: ${e}`);
      return { Error: e };
    }
  }

  static async updateStep(id, steps, date, email) {
    try {
      const updateResponse = await Steps.updateOne(
        { _id: new ObjectId(id) },
        {
          $set: {
            steps: new Int32(steps),
            date: date,
            email: email,
          },
        }
      );
      return updateResponse;
    } catch (e) {
      console.error(`Unable to update steps: ${e}`);
      return { Error: e };
    }
  }
}
