class RekognitionParser {
    constructor(response) {
      this.metadata = response.$metadata;
      this.faceDetails = response.FaceDetails.map(detail => this.parseFaceDetail(detail));
    }
  
    // Parse individual face detail object
    parseFaceDetail(detail) {
      return {
        ageRange: detail.AgeRange,
        beard: detail.Beard,
        boundingBox: detail.BoundingBox,
        confidence: detail.Confidence,
        emotions: this.parseEmotions(detail.Emotions),
        eyeDirection: detail.EyeDirection,
        eyeglasses: detail.Eyeglasses,
        eyesOpen: detail.EyesOpen,
        faceOccluded: detail.FaceOccluded,
        gender: detail.Gender,
        landmarks: this.parseLandmarks(detail.Landmarks),
        mouthOpen: detail.MouthOpen,
        mustache: detail.Mustache,
        pose: detail.Pose,
        quality: detail.Quality,
        smile: detail.Smile,
        sunglasses: detail.Sunglasses
      };
    }
  
    // Parse emotions array
    parseEmotions(emotions) {
      return emotions.map(emotion => ({
        type: emotion.Type,
        confidence: emotion.Confidence
      }));
    }
  
    // Parse landmarks array
    parseLandmarks(landmarks) {
      return landmarks.map(landmark => ({
        type: landmark.Type,
        x: landmark.X,
        y: landmark.Y
      }));
    }
  
    // Methods to access parsed data
    getFaceDetails() {
      return this.faceDetails;
    }
  
    getMetadata() {
      return this.metadata;
    }
  
    // Helper to format face details as text
    formatFaceDetails() {
      return this.faceDetails.map((detail, index) => {
        const emotions = detail.emotions.map(e => `${e.type} (${e.confidence.toFixed(2)}%)`).join(", ");
        return `
          Face ${index + 1}:
            Age Range: ${detail.ageRange.Low} - ${detail.ageRange.High}
            Gender: ${detail.gender.Value} (${detail.gender.Confidence.toFixed(2)}%)
            Beard: ${detail.beard.Value} (${detail.beard.Confidence.toFixed(2)}%)
            Mustache: ${detail.mustache.Value} (${detail.mustache.Confidence.toFixed(2)}%)
            Eyeglasses: ${detail.eyeglasses.Value} (${detail.eyeglasses.Confidence.toFixed(2)}%)
            Sunglasses: ${detail.sunglasses.Value} (${detail.sunglasses.Confidence.toFixed(2)}%)
            Emotions: ${emotions}
            Smile: ${detail.smile.Value} (${detail.smile.Confidence.toFixed(2)}%)
        `;
      }).join("\n");
    }
  }
  
  // Example usage:
  const rekognitionResponse = { /* Paste your JSON response here */ };
  const parser = new RekognitionParser(rekognitionResponse);
  
  console.log(parser.getFaceDetails());
  console.log(parser.formatFaceDetails());

  export default RekognitionParser;