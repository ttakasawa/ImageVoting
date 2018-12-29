const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//

function testPublicPost(){

	var postingUserId = '7r2r3UcHGLhpi6CHCnr6GB5VKfh1'
	var voterUserId = 'sn1ER4dPDjRr9rvtl0BzVuVgiZi1'

	var db = admin.database();
	var postsRef = db.ref("PublicPost");

	var newPostRef = postsRef.push();
	var postId = newPostRef.key;
	newPostRef.set({
	  userId: "7r2r3UcHGLhpi6CHCnr6GB5VKfh1",
	  image1Url: "https://firebasestorage.googleapis.com/v0/b/imagevoting-e0ac5.appspot.com/o/PublicImagePost%2Fsn1ER4dPDjRr9rvtl0BzVuVgiZi1%2F685B02BF-EE3B-46A5-8307-1EC201776900?alt=media&token=54d384a6-1c02-4db9-a292-4b93a65ba642",
	  image2Url: "https://firebasestorage.googleapis.com/v0/b/imagevoting-e0ac5.appspot.com/o/PublicImagePost%2Fsn1ER4dPDjRr9rvtl0BzVuVgiZi1%2FA0E593BC-A936-45AD-9770-D70C1D44AA46?alt=media&token=69b465b6-5b6a-435f-873a-baf7135351e0",
	  totalVotesNeeded: 10
	});

	return 0
}

exports.populateUsersTable = functions.database.ref('/PublicPost/{postKey}/{userId}').onWrite(event => {

	const postId = event.params.postKey
	const posterUserId = event.params.userId
	const potentialVoterUserId = 'sn1ER4dPDjRr9rvtl0BzVuVgiZi1'

	var userVotableRef = admin.database().ref('/User-VotablePublicPostTable/' + potentialVoterUserId + '/' + postId)

	userVotableRef.set('true');

	return 0
});


exports.populateUsersTable = functions.database.ref('/User-VotablePublicPostTable/{potentialVoterUserId}/{postId}').onWrite(event => {

	const postId = event.params.postId
	const potentialVoterUserId = event.params.potentialVoterUserId

	var postVotableUserRef = admin.database().ref('/PublicPost-VotableUserTable/' + postId + '/' + potentialVoterUserId)

	postVotableUserRef.set('true');

	return 0
});



exports.helloWorld = functions.https.onRequest((request, response) => {
 response.send("Hello from Firebase!");
});

exports.test = functions.https.onRequest((request, response) => {
 testPublicPost()
});

const express = require('express');
var bodyParser = require('body-parser');
var app = express();


app.post('/publicPost', function(req, res) {
  console.log('publicPost');
  res.status(200).send();
});

exports.app = functions.https.onRequest(app);