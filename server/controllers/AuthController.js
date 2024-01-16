const User = require("../models/user");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken")


module.exports = {
    signUp: async (req, res) => {
        //destructuring (name will be assigned with req.body.name, etc)
        //make sure the key and value is matching
        const { name, email, password } = req.body;
        const existingUser = await User.findOne({ email })
        //check if in the user collection there is email 
        if (existingUser) {
            //we need return because when it reaches this, we need to end the function
            return res.status(400).json({
                msg: "User with same email already exists!"
            })
        }

        const hashedPassword = await bcrypt.hash(password, 8);

        let user = new User({
            email,
            password: hashedPassword,
            name
        })

        try {
            user = await user.save();
            return res.status(200).json({ user })
        } catch (error) {
            return res.status(500).json({
                //we only need the message
                error: error.message
            })
        }
    },


    signIn: async (req, res) => {
        try {
            const { email, password } = req.body;
            const user = await User.findOne({ email });
            if (!user) {
                return res.status(400).json({ msg: "User with this email does not exist!" })
            }

            //after finding the user we then need to see if the password matches or not
            //we cant descryp the password first because it has a different salt
            const isMatch = bcrypt.compare(password, user.password);
            //guard clauses
            if (!isMatch) {
                return res.status(500).json({error: e.message});
            }
            //we need something the jwt to sign with
            const token = jwt.sign({id: user._id}, "passwordKey", { expiresIn: '10d' })
            //by doing ...user we will have the properties seperate like:
            // 'name':
            // "email":
            //if not it just shows "user": ...
            res.status(200).json({
                token,
                ...user._doc
            })
        } catch (error) {
            res.status(500).json({ error: error.message })
        }
    },

    tokenIsValid: async (req, res) => {
        try {
            const token = req.header("token");
            //check if token header exist or not
            if(!token) return res.json(false);
            const isVerified = jwt.verify(token, 'passwordKey');
            //check if the token is valid or not
            if(!isVerified) return res.json(false);
            //check if user is available or not, token can be valid, what if it just randomly correct
            //therefore we need to check if the user exist or not
            //we can use id here because jwt.sign({id: user._id}, we passed id
            const user = await User.findById(isVerified.id);
            if(!user) return res.json(false);

            res.json(true);
        } catch (error) {
            res.status(500).json({ error: error.message })
        }
    },

    getUser: async (req, res) => {
        //we have access to req.user and req.token if we are authorized from the middleware
        const user = await User.findById(req.user);
        res.json({...user._doc, token: req.token});
    }
}