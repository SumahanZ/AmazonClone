const User = require("../models/user");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const { Product } = require("../models/product");
const Order = require("../models/order");


module.exports = {
    addProduct: async (req, res) => {
        try {
            //should be matching with what we passed in
            const { name, description, imagesUrl, quantity, price, category } = req.body;
            let product = new Product({
                name,
                description,
                imagesUrl,
                quantity,
                price,
                category
            });
            //when we save to mongodb it also returns the _id and __v
            product = await product.save();
            res.json(product);
        } catch (error) {
            res.status(500).json({ error: error.message });
        }
    },

    //Get all your products
    // /get-products

    getAllProducts: async (req, res) => {
        try {
            const products = await Product.find({});
            res.json(products);
        } catch (error) {
            res.status(500).json({ error: error.message })
        }
    },


    deleteProduct: async (req, res) => {
        try {
            const { id } = req.body;
            await Product.findByIdAndDelete(id);
            res.status(200).json(product);
        } catch (error) {
            res.status(500).json({ error: error.message })
        }
    },

    getAllOrders: async (req, res) => {
        try {
            const orders = await Order.find({})
            res.json(orders);
        } catch (error) {
            res.status(500).json({ error: error.message })
        }
    },

    changeOrderStatus: async (req, res) => {
        try {
            const { id, status } = req.body;
            let order = await Order.findById(id)
            order.status = status;
            order = await order.save();
            res.json(order);
        } catch (error) {
            res.status(500).json({ error: error.message })
        }
    },

    getAnalytics: async (req, res) => {
        try {
            const orders = await Order.find({});
            let totalEarnings = 0;

            for (let i = 0; i < orders.length; i++) {
                for (let j = 0; j < orders[i].products.length; j++) {
                    totalEarnings += orders[i].products[j].quantity * orders[i].products[j].product.price
                }
            }

            //CATEGORY WISE ORDER FETCHING
            let mobileEarnings = await fetchCategoryWiseProduct("Mobiles");
            let essentialEarnings = await fetchCategoryWiseProduct("Essentials");
            let appliancesEarnings = await fetchCategoryWiseProduct("Appliances");
            let booksEarnings = await fetchCategoryWiseProduct("Books");
            let fashionEarnings = await fetchCategoryWiseProduct("Fashion");

            let earnings = {
                totalEarnings,
                mobileEarnings,
                essentialEarnings,
                appliancesEarnings,
                booksEarnings,
                fashionEarnings
            }
            res.json(earnings);
        } catch (error) {
            res.status(500).json({ error: error.message })
        }
    }

}


const fetchCategoryWiseProduct = async (category) => {
    let earnings = 0;
    let categoryOrders = await Order.find({
        //we can do this string dot notation to get the a product category in the products array that matches the category param
        'products.product.category': category
    })

    for (let i = 0; i < categoryOrders.length; i++) {
        for (let j = 0; j < categoryOrders[i].products.length; j++) {
            earnings += categoryOrders[i].products[j].quantity * categoryOrders[i].products[j].product.price
        }
    }
}