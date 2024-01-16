const { Product } = require("../models/product");
const { Order } = require("../models/order");

module.exports = {
    addToCart: async (req, res) => {
        try {
            const { id } = req.body;
            const product = await Product.findById(id);
            let user = await User.findById(req.user);

            if (user.cart.length == 0) {
                user.cart.push({ product, quantity: 1 })
            } else {
                let isProductFound = false;
                for (let i = 0; i < user.cart.length; i++) {
                    if (user.cart[i].product._id.equals(product._id)) {
                        isProductFound = true;
                    }
                }

                if (isProductFound) {
                    //method in array
                    let productt = user.cart.find((cartItem) => {
                        cartItem.product._id.equals(product._id);
                    });

                    productt.quantity += 1;
                } else {
                    user.cart.push({ product, quantity: 1 })
                }
            }

            user = await user.save();
            res.json(user);
        } catch (error) {
            res.status(500).json({ error: error.message })
        }
    },

    removeFromCart: async (req, res) => {
        try {
            const { id } = req.params;
            const product = await Product.findById(id);
            let user = await User.findById(req.user);

            for (let i = 0; i < user.cart.length; i++) {
                if (user.cart[i].product._id.equals(product._id)) {
                    if (user.cart[i].quantity == 1) {
                        user.cart.splice(i, 1)
                    } else {
                        user.cart[i].quantity -= 1;
                    }
                }
            }
            user = await user.save();
            res.json(user);
        } catch (error) {
            res.status(500).json({ error: error.message })
        }
    },

    saveUserAddress: async (req, res) => {
        try {
            const { address } = req.body;
            let user = await User.findById(req.user);
            user.address = address;
            user = await user.save();
            res.json(user);
        } catch (error) {
            res.status(500).json({ error: error.message })
        }
    },


    orderProduct: async (req, res) => {
        try {
            const { cart, totalPrice, address } = req.body;
            let products = [];

            for(let i=0; i<cart.length; i++) {
                let product = await Product.findById(cart[i].product._id)
                //if the product quantity that is in stock is bigger than the number of product the user orders
                if(product.quantity >= cart[i].quantity) {
                    product.quantity -= cart[i].quantity
                    products.push({product, quantity: cart[i].quantity});
                    await product.save();
                } else {
                    return res.status(400).json({msg: `${product.name} is out of stock!`})
                }
            }

            let user = await User.findById(req.user);
            user.cart = [];
            await user.save();
            
            let order = new Order({
                products,
                totalPrice,
                address,
                userId: req.user,
                orderedAt: new Date().getTime(),
            })

            order = await order.save();
            res.json(order);
        } catch (error) {
            res.status(500).json({ error: error.message })
        }
    },

    getUserOrder: async (req, res) => {
        try {
          const orders = await Order.find({userId: req.user});
          res.json(orders);
        } catch (error) {
            res.status(500).json({error: error.message});
        }
    }
}