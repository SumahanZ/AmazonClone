const mongoose = require('mongoose');
const { productSchema } = require("../models/product");

const userSchema = mongoose.Schema({
    name: {
        type: String,
        required: true,
        trim: true,
    },
    email: {
        type: String,
        required: true,
        trim: true,
        validate: {
            validator: (value) => {
                //regex
                const re =
                    /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
                return value.match(re);
            },
            //if validator return false
            message: "Please enter a valid email address",
        }
    },
    password: {
        required: true,
        type: String,
        validate: {
            validator: (value) => {
                return value.length > 6;
            },
            message: "Please enter a valid email address",
        }
    },
    address: {
        type: String,
        default: '',
    },
    type: {
        type: String,
        default: "user"
    },
    cart: [
        {
            product: productSchema,
            quantity: {
                type: Number,
                required: true
            }
        }
    ]
})

//export the model to be used elsewhere by just doing new User()
module.exports = mongoose.model('User', userSchema);