import UsersDAO from "../dao/userDAO.js";

export default class UserController {
  static async apiGetUserID(req, res, next) {
    const email = req.query.email;
    const password = req.query.password;
    const { details } = await UsersDAO.getUserID(email, password);
    let response = { details };
    res.json(response);
  }

  static async apiPostUser(req, res, next) {
    try {
      const username = req.body.username.toLowerCase();
      const password = req.body.password;
      const name = req.body.name.toLowerCase();
      const gender = req.body.gender.toLowerCase();
      const dob = req.body.dob;
      const email = req.body.email;

      await UsersDAO.addUser(
        username,
        password,
        name,
        gender,
        dob,
        email
      );
      res.json({ Status: "Success" });
    } catch (e) {
      res.status(500).json({ Error: e.message });
    }
  }
  static async apiPutUser(req, res, next) {
    try {
      const username = req.body.username.toLowerCase();
      const password = req.body.password;
      const name = req.body.name.toLowerCase();
      const gender = req.body.gender.toLowerCase();
      const dob = req.body.dob;
      const email = req.body.email;

      const userResponse = await UsersDAO.updateUser(
        username,
        password,
        name,
        gender,
        dob,
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
  static async apiDeleteUser(req, res, next){
    try{
        const id = req.query.id
        await UsersDAO.deleteUser(id)
        res.json ({Status: "Success"})
    } catch(e){
        res.status(500).json({ Error: e.message })
    }
  }
}