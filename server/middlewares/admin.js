const jwt = require("jsonwebtoken");
const User = require("../models/user");
const admin = async (req, res, next) => {
    try {
        const token = req.header("token");
        if (!token)
            return res.status(401).json({ msg: "No auth token, access denied" });
        const isVerified = jwt.verify(token, "passwordKey");
        if (!isVerified)
            return res.status(401).json({ msg: "Token verification failed, authorization denied." });
        const user = await User.findById(isVerified.id);
        const isAdmin = user.type == "admin"
        if (!isAdmin)   
            return res.status(401).json({ msg: "You are not an admin, authorization denied." });
        req.user = isVerified.id;
        req.token = token;
        next();
    } catch (error) {
        res.status(500).json({ error: error.message })
    }
}


module.exports = admin;
