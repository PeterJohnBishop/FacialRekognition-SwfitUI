const router = require("express").Router();
const { RekognitionClient, DetectFacesCommand, CompareFacesCommand, QualityFilter } = require('@aws-sdk/client-rekognition');
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

//facial analysis on image stored locally
router.route('/face_local').post(upload.single('image'), async (req, res) => {

    const imageBytes = fs.readFileSync(req.file.path);

  // Set up parameters for Rekognition
  const params = {
    Image: { Bytes: imageBytes },
    Attributes: ['ALL'],
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

//comparision analysis on images stored locally
router.route('/compare_faces_local').post(upload.array('images', 2), async (req, res) => {
    if (req.files.length !== 2) {
        return res.status(400).send("Please upload exactly two images for comparison.");
    }

    // Read both images as byte data
    const sourceImageBytes = fs.readFileSync(req.files[0].path);
    const targetImageBytes = fs.readFileSync(req.files[1].path);

    // Set up parameters for Rekognition
    const params = {
        SourceImage: { Bytes: sourceImageBytes },
        TargetImage: { Bytes: targetImageBytes },
        SimilarityThreshold: 70
    };

    try {
        const command = new CompareFacesCommand(params);
        const response = await client.send(command);

        // Clean up uploaded images
        req.files.forEach(file => fs.unlinkSync(file.path));

        // Process and format response data
        const faceMatches = response.FaceMatches.map(match => ({
            position: match.Face.BoundingBox,
            similarity: match.Similarity
        }));

        console.log("Face comparison results:", faceMatches);
        res.json({ faceMatches });
    } catch (error) {
        console.error("Error comparing faces:", error);
        res.status(500).send("Error comparing images");
    }
});

router.route('/compare_faces_s3').post(async (req, res) => {

  const { source, target } = req.body;
  // Set up parameters for Rekognition
  const input = { // CompareFacesRequest
    SourceImage: { // Image
      Bytes: new Uint8Array(), // e.g. Buffer.from("") or new TextEncoder().encode("")
      S3Object: { // S3Object
        Bucket: process.env.AWS_BUCKET,
        Name: source,
      },
    },
    TargetImage: {
      Bytes: new Uint8Array(), // e.g. Buffer.from("") or new TextEncoder().encode("")
      S3Object: {
        Bucket: process.env.AWS_REKOGNITION_BUCKET,
        Name: target,
      },
    },
    SimilarityThreshold: 70.00,
    // QualityFilter: "NONE" || "AUTO" || "LOW" || "MEDIUM" || "HIGH",
    QualityFilter: "AUTO"
  };

  try {
      const command = new CompareFacesCommand(input);
      const response = await client.send(command);

      // Process and format response data
      const faceMatches = response.FaceMatches.map(match => ({
          position: match.Face.BoundingBox,
          similarity: match.Similarity
      }));

      console.log("Face comparison results:", faceMatches);
      res.json({ faceMatches });
  } catch (error) {
      console.error("Error comparing faces:", error);
      res.status(500).send("Error comparing images");
  }
});

module.exports = router;

