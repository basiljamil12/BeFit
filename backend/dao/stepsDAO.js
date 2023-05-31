import mongodb from "mongodb";
const ObjectId = mongodb.ObjectId;

let steps;

export default class StepsDAO {
  static async injectDB(conn) {
    if (steps) {
      return;
    }
    try {
      steps = await conn.db(process.env.MONGO_NS).collection("Steps");
    } catch (e) {
      console.error(`Unable to establish a collection handle in userDAO: ${e}`);
    }
  }

  static async getstepsByID({ filters = null } = {}) {
    let match;
    let query;
    if (filters) {
      if ("id" in filters) {
        match = { $match: { userid: new ObjectId(filters["id"]) } };
      }
    }
    let cursor;

    try {
      if (!steps) {
        throw new Error("Steps collection is undefined");
      }

      cursor = await steps.aggregate([query, match]).toArray();
    } catch (e) {
      console.error(`Unable to issue find command, ${e}`);
      return { stepsList: [], totalNumSteps: 0 };
    }

    try {
      const stepsList = await cursor.toArray();
      const totalNumSteps = stepsList.length;

      return { stepsList, totalNumSteps };
    } catch (e) {
      console.error(
        `Unable to convert cursor to array or problem counting documents, ${e}`
      );
      return { stepsList: [], totalNumSteps: 0 };
    }
  }

  static async addSteps(steps, date, userid) {
    try {
      const stepsDoc = {
        steps: Number(steps),
        date: date.toISOString(),
        userid: ObjectId(userid),
      };
      return await steps.insertOne(stepsDoc);
    } catch (e) {
      console.error(`Unable to add a user: ${e}`);
      return { Error: e };
    }
  }

  static async updateSteps(id, steps, date, userid) {
    try {
      const updateResponse = await steps.updateOne(
        { _id: ObjectId(id) },
        {
          $set: {
            steps: Number(steps),
            date: date.toISOString(),
            userid: ObjectId(userid),
          },
        }
      );
      return updateResponse;
    } catch (e) {
      console.error(`Unable to update a user: ${e}`);
      return { Error: e };
    }
  }
}
