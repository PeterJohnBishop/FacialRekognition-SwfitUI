const router = require("express").Router();
const firebase = require('../firebase.js')

router.route('/create/:id').post( async (req, res) => {

    const id = req.params.id;
    const { displayName, email, profileImg } = req.body;
    const db = firebase.firestore();

    db.collection("userData").doc(id).set({
        displayName: displayName,
        email: email,
        profileImg: profileImg,
    })
    .then((docRef) => {
        res.status(200);
    })
    .catch((error) => {
        res.status(400).json({ code: error.code, error: error.message });
    });
  
});

router.route('/update/:id').post( async (req, res) => {
    const id = req.params.id;
    const { displayName, email, profileImg } = req.body;
    const db = firebase.firestore();

    db.collection("userData").doc(id).set({
        displayName: displayName,
        email: email,
        profileImg: profileImg,
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

    db.collection("userData").get().then((querySnapshot) => {
        querySnapshot.forEach((doc) => {
            var docs = [];
            docs.push(doc.data());
            res.status(200).json({docs});
        });
    });
    
});

router.route('/read_one/:id').post( async (req, res) => {
    
    const id = req.params.id;
    const db = firebase.firestore();
    var docRef = db.collection("userData").doc(id);

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

router.route('/read_by_email').post( async (req, res) => {
    const { email } = req.body;
    const db = firebase.firestore();

    db.collection("userData").where("email", "==", email)
    .get()
    .then((querySnapshot) => {
        querySnapshot.forEach((doc) => {
            if (doc.exists) {
                res.status(200).json(doc.data());
            } else {
                res.status(400).json({ message: "Doc with that uid not found." });
            }
        });
    })
    .catch((error) => {
        res.status(400).json({ code: error.code, error: error.message });
    });
})

router.route('/delete/:id').post( async (req, res) => {
    
    const id = req.params.id;
    const db = firebase.firestore();

    db.collection("userData").doc(id).delete().then(() => {
        res.status(200).json({ message: "Document deleted." });
    }).catch((error) => {
        res.status(400).json({ code: error.code, error: error.message });
    });
});

module.exports = router;