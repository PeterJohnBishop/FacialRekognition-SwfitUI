const router = require("express").Router();
const firebase = require('../firebase.js')

router.route('/create').post( async (req, res) => {

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

router.route('/login').post( async (req, res) => {

    const { email, password } = req.body;

    firebase.auth().signInWithEmailAndPassword(email, password)
  .then((userCredential) => {
    // Signed in
    var user = userCredential.user;
    res.status(201).json({ uid: user.uid });
  })
  .catch((error) => {
    res.status(400).json({ code: error.code, error: error.message });
  });
  
});

router.route('/logout').post( async (req, res) => {

  const { uid } = req.body;

  firebase.auth().signOut().then(() => {
    // Sign-out successful.
    res.status(200).json({ user: uid });
  }).catch((error) => {
    res.status(400).json({ code: error.code, error: error.message });
  });
});


module.exports = router;