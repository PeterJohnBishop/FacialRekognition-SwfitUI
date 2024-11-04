const router = require("express").Router();
const { RekognitionClient, DetectFacesCommand } = require('@aws-sdk/client-rekognition');
require('dotenv').config();
const multer = require('multer');
const fs = require('fs');
const upload = multer({ dest: 'uploads/' });

const client = new RekognitionClient({
  region: 'us-east-1', // Replace with your AWS region
  credentials: {
    accessKeyId: process.env.AWS_ACCESS_KEY_ID,
    secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
  },
});

router.route('/rekognize').post(upload.single('image'), async (req, res) => {

    const imageBytes = fs.readFileSync(req.file.path);

  // Set up parameters for Rekognition
  const params = {
    Image: { Bytes: imageBytes },
    Attributes: ['ALL'], // Add any specific attributes you need
  };

  // Call Rekognition
  try {
    const command = new DetectFacesCommand(params);
    const response = await client.send(command);
    fs.unlinkSync(req.file.path); // Clean up uploaded image file
    res.json(response); // Return analysis data
    console.log(response["FaceDetails"]);
  } catch (error) {
    console.error(error);
    res.status(500).send('Error processing image');
  }
  
});

module.exports = router;

