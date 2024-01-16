const mongoose = require("mongoose")

const ratingSchema = mongoose.Schema({
    userId: {
        type: String,
        required: true,
    },
    rating: {
        type: Number,
        required: true,
    }
})

module.exports = ratingSchema

//if we only need to make a structure and not make another model we don't need to do
//mongoose.model(), it will create an entirely new model in the file and give us _id and __v whicih we dont need