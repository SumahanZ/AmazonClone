const express = require("express");
const router = express.Router();
const auth = require("../middlewares/auth")
const userController = require("../controllers/UserController")

router.post('/add-to-cart', auth, userController.addToCart);
router.delete('/remove-cart/:id', auth, userController.removeFromCart);
router.post('/save-user-address', auth, userController.saveUserAddress);
router.post('/order-product', auth, userController.orderProduct);

module.exports = router;