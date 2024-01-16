const { Product } = require("../models/product");

module.exports = {
    getProductsFromCategory: async (req, res) => {
        try {
            const products = await Product.find({ category: req.query.category })
            res.json(products)
        } catch (error) {
            res.status(500).json({ error: error.message })
        }
    },


    searchProducts: async (req, res) => {
        try {
            //use regex from mongoose
            //search for similar names from the regex
            //if actual product is Iphone
            //if u type in ipHONE, it will still work
            const products = await Product.find({
                name: { $reqex: req.params.name, $options: 'i' },
            })

            res.json()
        } catch (error) {
            res.status(500).json({ error: error.message })
        }
    },

    rateProduct: async (req, res) => {
        try {
            const { id, rating } = req.body;
            let product = await Product.findById(id);

            //iterate over loop and delete the rating from this user, if already exists
            for (let i = 0; i < product.ratings.length; i++) {
                //we get access to req.user from the auth middleware
                if (product.ratings[i].userId == req.user) {
                    product.ratings.splice(i, 1);
                    break;
                }
            }

            //after that create a new rating from the specific user
            const ratingSchema = {
                userId: req.user,
                rating,
            }

            product.ratings.push(ratingSchema)
            //save to the mongodb database
            product = await product.save();
            res.json(product);
        } catch (error) {
            res.status(500).json({ error: error.message })
        }
    },

    getDealOfTheDay: async (req, res) => {
        try {
            let products = await Product.find({});
            products = products.sort((a, b) => {
                //sort in descending order
                let aSum = 0;
                let bSum = 0;

                for (let i = 0; i < a.ratings.length; i++) {
                    aSum += a.ratings[i].rating;
                }

                for (let i = 0; i < b.ratings.length; i++) {
                    bSum += b.ratings[i].rating;
                }

                return aSum < bSum ? 1 : -1;
            });

            res.json(products[0])
        } catch (error) {
            res.status(500).json({ error: error.message });
        }
    },
}