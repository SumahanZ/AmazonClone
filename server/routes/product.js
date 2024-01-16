const express = require("express");
const productController = require("../controllers/ProductController");
const auth = require("../middlewares/auth");

const router = express.Router();

//params
router.get("/get-products/", auth, productController.getProductsFromCategory)

router.get("/search-products/:queryString", auth, productController.searchProducts)

router.post("/rate-product", auth, productController.rateProduct)

router.get("/get-dealofday", auth, productController.getDealOfTheDay)

// router.post('/add-product', admin, adminController.addProduct);

// router.get('/get-product', admin, adminController.getAllProducts);

// router.post("/delete-product", admin, adminController.deleteProduct)

module.exports = router;