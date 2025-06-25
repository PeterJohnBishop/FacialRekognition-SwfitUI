# Facial Rekognition Authentication
## AWS Rekognition S3 | Firebase Auth | Firestore | SwiftUI

https://solid-carnival-aa8d913149b4.herokuapp.com/ deployed to Heroku


## Registration

![register](https://github.com/Pierre81385/solid-carnival/blob/main/Assets/RegisterDemo.gif?raw=true)

Create an account with basic email and password combination. This utilizes Firebase Authentication and the plain text password is never saved. 

Once an account has been successfully created, the user is redirected to a screen to submit a photo to use for facial comparision. 
They may either select an image from the device gallery or use their camera to take a current photo. 
Once confirmed, the image is saved to an AWS S3 bucket and its URL is refrenced in a separate document saved to Firebase Firstore cloud storage.

## Login

![login](https://github.com/Pierre81385/solid-carnival/blob/main/Assets/LoginDemo.gif?raw=true)

Once a user has logged in, they'll be taken to authenticate with Facial Comparison. 
The image captured is immediately sent to AWS Rekognition to compare against the refrence image taken during the account creation process.

If for some reason the user logged out before completing this step, they'll instead be redirected to the setup screen to select or take a refrence image first. 
This is confirmed by the absense of a user document in Firebase Firestore that refrences the user UID from Firebase Authentication that stores the reference image taken.

![partiallogin](https://github.com/Pierre81385/solid-carnival/blob/main/Assets/PartialLoginDemo.gif?raw=true)

## Comparison

![comparision](https://github.com/Pierre81385/solid-carnival/blob/main/Assets/faceComparison.gif?raw=true)

Once an image is taken and Rekognition Face Comparison is completed, the function displays the similarity value and returns true. 

If the image is not at least a 90% similarity match or if no match is found, the function returns false and the user must login again.



#FIREBSAE AUTHENTICATION API

POST /authentication/create create a FirebaseAuth user.

POST /authentication/login authenticate a FirebaseAuth user.

POST /authentication/logout logout a FirebaseAuth user.

#FIREBASE FIRESTORE API

POST /users/create create a Firestore user document.
 
POST /users/update update a Firestore user document (replace current document)

POST /users/read_one find a Firestore user document by document ID.

POST /users/read_one_emaail find a Firestore user documet by email.

POST /users/read_all find all Firestore user documents.

POST /users/delete delete a Firestore user document by ID.


#AWS API
 
POST /s3/upload > upload an image to an S3 Bucket. 

POST /rekognition/face_local > send an image for Rekognition analysis.

POST /rekognition/compare_faces_s3 > compare two images stored in the S3 bucket used for facial recognition identity verification 




