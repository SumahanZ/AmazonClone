//express is a  prebuilt node.js framework to help create web-server-side application way faster
//mongoose is a mongodb object modelling tool
//nodemon allows hot reload, so we don't have to launch the server again after changing a few stuff
//promises are basically future in dart 
//same like import in flutter

//import from packages
const express = require("express");
const mongoose = require("mongoose");

//import router from the auth router file
const authRouter = require("./routes/auth")
const adminRouter = require("./routes/admin")
const productRouter = require("./routes/product")
const userRouter = require("./routes/user")

//initialize the express and the port to listen to
const PORT = 3005;
const app = express();
const DB = "mongodb+srv://kevinsander:kevinsanderutomo@cluster0.qgoideh.mongodb.net/?retryWrites=true&w=majority"

//middleware
//what if we want to manipulate the data we are sending
//and we need to specify the format using the middleware
//Client -> server -> client
//now our node application knows about the existence of the auth router file
//we need this so we can read the req.body
//it basically parses incoming request with json payload
app.use(express.json({limit: "10mb"}))
app.use(express.urlencoded({limit: "10mb", extended: true}))
app.use("/api/auth", authRouter);
app.use("/api/admin", adminRouter);
app.use("/api/product", productRouter);
app.use("/api/user", userRouter)

//connect to mongodb database
//this is a future
//we need to await it, but since we are not in a function block, we have to use then()
mongoose.connect(DB).then(() => {
    console.log("Connection Successful");
}).catch((error) => {
    console.log(error);
});

//Creating an API
//GET, PUT, POST, DELETE, UPDATE -> CRUD
app.listen(PORT, () => console.log(`listening on port ${PORT}!`));
