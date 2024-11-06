const router = require("express").Router();
const firebase = require('../firebase.js')

router.route('/create').post( async (req, res) => {

    const { first, last, email } = req.body;
    const db = firebase.firestore();

    db.collection("users").add({
        first: first,
        last: last,
        email: email
    })
    .then((docRef) => {
        res.status(200).json({ id: docRef.id });
    })
    .catch((error) => {
        res.status(400).json({ code: error.code, error: error.message });
    });
  
});

router.route('/update').post( async (req, res) => {
    
    const { id, first, last } = req.body;
    const db = firebase.firestore();

    db.collection("users").doc(id).set({
        first: first,
        last: last,
    })
    .then(() => {
        res.status(200).json({ message: "Doc updated!" });
    })
    .catch((error) => {
        res.status(400).json({ code: error.code, error: error.message });
    });

});

router.route('/read_all').post( async (req, res) => {
    const db = firebase.firestore();

    db.collection("users").get().then((querySnapshot) => {
        querySnapshot.forEach((doc) => {
            var docs = [];
            docs.push(doc.data());
            res.status(200).json({docs});
        });
    });
    
});

router.route('/read_one').post( async (req, res) => {
    
    const { id } = req.body;
    const db = firebase.firestore();
    var docRef = db.collection("users").doc(id);

docRef.get().then((doc) => {
    if (doc.exists) {
        res.status(200).json(doc.data());
    } else {
        res.status(400).json({ message: "Doc not found." });
    }
}).catch((error) => {
    res.status(400).json({ code: error.code, error: error.message });
});
});

router.route('/read_one_email').post( async (req, res) => {
    const { email } = req.body;
    const db = firebase.firestore();

    db.collection("users").where("email", "==", email)
    .get()
    .then((querySnapshot) => {
        querySnapshot.forEach((doc) => {
            if (doc.exists) {
                res.status(200).json(doc.data());
            } else {
                res.status(400).json({ message: "Doc with that email not found." });
            }
        });
    })
    .catch((error) => {
        res.status(400).json({ code: error.code, error: error.message });
    });
})

router.route('/delete').post( async (req, res) => {
    
    const { id } = req.body;
    const db = firebase.firestore();

    db.collection("users").doc(id).delete().then(() => {
        res.status(200).json({ message: "Document deleted." });
    }).catch((error) => {
        res.status(400).json({ code: error.code, error: error.message });
    });
});

module.exports = router;