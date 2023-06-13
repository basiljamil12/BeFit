import mongodb, { Int32 } from "mongodb";
const ObjectId = mongodb.ObjectId;

let Sleep;

export default class SleepDAO {
  static async injectDB(conn) {
    if (Sleep) {
      return;
    }
    try {
      Sleep = await conn.db(process.env.MONGO_NS).collection("Sleep");
    } catch (e) {
      console.error(`Unable to establish a collection handle in sleepDAO: ${e}`);
    }
  }
  
  static async getsleepByID({ filters = null } = {}) {
    let match;
    if (filters) {
      if ("id" in filters) {
        match = { email: filters["id"] } ;
        
      }
    }
    let cursor;
    try {
      if (!Sleep) {
        throw new Error("Sleep collection is undefined");
      }
    
      cursor = await Sleep.find(match);
    } catch (e) {
      console.error(`Unable to issue find command, ${e}`);
      return { sleepList: [], total_results: 0 };
    }

    try {
      const sleepList = await cursor.toArray();
      const total_results =  await Sleep.countDocuments(match);
      return {sleepList, total_results};
    } catch (e) {
      console.error(
        `Unable to convert cursor to array or problem counting documents, ${e}`
      );
      return { sleepList: [], total_results: 0};
    }
  }

  static async addSleep(starttime, endtime,duration, email) {
    try {
      const sleepDoc = {
        starttime: starttime,
        endtime: endtime,
        duration: duration,
        email: email,
      };
      return await Sleep.insertOne(sleepDoc);
    } catch (e) {
      console.error(`Unable to add Sleep: ${e}`);
      return { Error: e };
    }
  }

  static async updateSleep(id, starttime, endtime,duration, email) {
    try {
      const updateResponse = await Sleep.updateOne(
        { email:email },
        {
          $set: {
            starttime:starttime,
            endtime: endtime,
            duration:duration,
            email: email,
          },
        }
      );
      return updateResponse;
    } catch (e) {
      console.error(`Unable to update Sleep: ${e}`);
      return { Error: e };
    }
  }
}
