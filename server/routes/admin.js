const express = require("express");
const adminController = require("../controllers/AdminController")
const admin = require("../middlewares/admin")

const router = express.Router();

router.post('/add-product', admin, adminController.addProduct);

router.get('/get-product', admin, adminController.getAllProducts);

router.post("/delete-product", admin, adminController.deleteProduct)

router.get("/get-admin-orders", admin, adminController.getAllOrders)

router.post("/change-order-status", admin, adminController.changeOrderStatus)

router.get("/analytics", admin, adminController.getAnalytics)

module.exports = router;