const express = require("express");
const authController = require("../controllers/AuthController")
const auth = require("../middlewares/auth")

//we have access to the express Router
//if we do express(), then we have to listen to it
//we have to export it, because this is still private
const router = express.Router();

router.post("/signup", authController.signUp)
router.post("/signin", authController.signIn)
router.post("/tokenvalid", authController.tokenIsValid)
router.get("/getuser", auth, authController.getUser);

module.exports = router;