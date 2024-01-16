const jwt = require("jsonwebtoken");

const auth = async (req, res, next) => {
    try {
        const token = req.header("token");
        //401 means unauthorized
        if (!token)
            return res.status(401).json({ msg: "No auth token, access denied" });
        const isVerified = jwt.verify(token, "passwordKey");
        if (!isVerified)
            return res.status(401).json({ msg: "Token verification failed, authorization denied." });
        //this is important: 
        //adding a new object to the request which is user and saving something to it
        //we can add this middleware, so if they are auth now we have access to the req.user and req.token
        req.user = isVerified.id;
        req.token = token;
        //this next will make sure it runs the call back function after doing the verification from the middleware, if we don't call next, it doesnt call the callback
        next();
    } catch (error) {
        res.status(500).json({ error: error.message })
    }
}


module.exports = auth;
