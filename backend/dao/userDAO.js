import mongodb from "mongodb";
const ObjectId = mongodb.ObjectId;

let users;

export default class UsersDAO {
  static async injectDB(conn) {
    if (users) {
      return;
    }
    try {
      users = await conn.db(process.env.MONGO_NS).collection("Users");
    } catch (e) {
      console.error(`Unable to establish a collection handle in userDAO: ${e}`);
    }
  }

  static async getUserID(email, password) {
    let cursor;
    try {
      cursor = await users.find({ email: email, password: password });
      const details = await cursor.toArray();
      return { details };
    } catch (e) {
      console.error(`Unable to issue find command, ${e}`);
      return { details: [] };
    }
  }
  static async addUser(username, password, name, gender, dob, email) {
    try {
      const userDoc = {
        username: username,
        password: password,
        name: name,
        gender: gender,
        dob: dob,
        email: email,
      };
      return await users.insertOne(userDoc);
    } catch (e) {
      console.error(`Unable to add a user: ${e}`);
      return { Error: e };
    }
  }
  static async updateUser(username, password, name, gender, dob, email) {
    try {
      const updateResponse = await users.updateOnne(
        { _id: ObjectId(id) },
        {
          $set: {
            username: username,
            password: password,
            name: name,
            gender: gender,
            dob: dob,
            email: email,
          },
        }
      );
      return updateResponse;
    } catch (e) {
      console.error(`Unable to update a user: ${e}`);
      return { Error: e };
    }
  }
  static async deleteUser(id) {
    try {
      const deleteResponse = await users.deleteOne({ _id: ObjectId(id) });
      return deleteResponse;
    } catch (e) {
      console.error(`Unable to delete a user: ${e}`);
      return { Error: e };
    }
  }
}
