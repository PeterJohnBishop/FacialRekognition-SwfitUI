# solid-carnival

https://solid-carnival-aa8d913149b4.herokuapp.com/ deployed to Heroku

As a user I want to create an account and login.
- When I create an account I'll submit a photo of myself to compare in future logins.
- When I login I'll use email and password authentication.
- When I login I'll verify my identity by submitting a photo take within 2min of submission.


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

POST /rekognition/compare_faces_local




