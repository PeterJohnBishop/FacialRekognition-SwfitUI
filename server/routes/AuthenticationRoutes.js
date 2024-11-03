const router = require("express").Router();
const firebase = require('../firebase.js')

router.route('/create').post( async (req, res) => {

  console.log(process.env.API_KEY);

    const { email, password } = req.body;

    const user = await firebase.auth().createUserWithEmailAndPassword(email, password)
    .then((userCredential) => {
      // Signed in 
      var user = userCredential.user;
      res.status(201).json({ uid: user.uid });
    })
    .catch((error) => {
      res.status(400).json({ code: error.code, error: error.message });
    });;
  
});



module.exports = router;