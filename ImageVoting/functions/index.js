const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();


const express = require('express');
var bodyParser = require('body-parser');
var app = express();
var async = require('async');
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//

function testPublicPost(){

	console.log('testPublicPost activated');

	var postingUserId = '7r2r3UcHGLhpi6CHCnr6GB5VKfh1'
	var voterUserId = 'sn1ER4dPDjRr9rvtl0BzVuVgiZi1'

	var db = admin.database();
	var postsRef = db.ref("Post");

	var newPostRef = postsRef.push();
	var postId = newPostRef.key;
	newPostRef.set({
	  userId: "7r2r3UcHGLhpi6CHCnr6GB5VKfh1",
	  image1Url: "https://firebasestorage.googleapis.com/v0/b/imagevoting-e0ac5.appspot.com/o/PublicImagePost%2Fsn1ER4dPDjRr9rvtl0BzVuVgiZi1%2F685B02BF-EE3B-46A5-8307-1EC201776900?alt=media&token=54d384a6-1c02-4db9-a292-4b93a65ba642",
	  image2Url: "https://firebasestorage.googleapis.com/v0/b/imagevoting-e0ac5.appspot.com/o/PublicImagePost%2Fsn1ER4dPDjRr9rvtl0BzVuVgiZi1%2FA0E593BC-A936-45AD-9770-D70C1D44AA46?alt=media&token=69b465b6-5b6a-435f-873a-baf7135351e0",
	  totalVotesNeeded: 10,
	  voteType: "publicSelection"
	});

	console.log('testPublicPost completed');

	return 0;
}


function placePostOnUserTable(potentialVoterUserIdArray, postId){

	async.each(potentialVoterUserIdArray, function(i, callback){
		console.log('update userPost');
		console.log(i);

	    var userPublicVotableRef = admin.database().ref('/User-VotablePublicPostTable/' + i + '/' + postId)
		userPublicVotableRef.set('true');

	}, function(err){

	    if(err) throw err;
	    return 0;
	});

	
}

function getUserIdsToVote(exceptionUserId, postId){

	console.log('activated');

	var userIds = []

	users = admin.database().ref('User').once('value').then((results) => {

		results.forEach(function(childSnapshot) {
			const userKey = childSnapshot.key;
			if (exceptionUserId !== userKey) {
				userIds.push(userKey);
			}
		});

		return placePostOnUserTable(userIds, postId);
	});

	users.catch(function(error) {
	    console.log(error);
	    return [];
	});
}

function appendPostIdToPosterTable(userId, postId){
	var db = admin.database();
	var userRecordRef = db.ref("User/" + userId + "/records/" + postId);
	//var newuserRecordRef = userRecordRef.push();

	userRecordRef.set(true);

	return 0;
}

exports.populateUsersTable = functions.database.ref('/Post/{postKey}').onCreate((snapshot, context) => {

	console.log('populateUsersTable activated');


	const postId = context.params.postKey;
	const postPublished = snapshot.val();
	const posterId = postPublished.userId;

	if (postPublished.voteType === 'publicSelection') {
		getUserIdsToVote(postPublished.userId, postId);
	}else{
		console.log('not implemented yet');
	}

	console.log('populateUsersTable completed');

	return appendPostIdToPosterTable(posterId, postId);
});


exports.populateVotesTableForPublicPost = functions.database.ref('/User-VotablePublicPostTable/{potentialVoterUserId}/{postId}').onCreate((snapshot, context) => {

	console.log('populateVotesTable activated');

	const postId = context.params.postId
	const potentialVoterUserId = context.params.potentialVoterUserId

	var postVotableUserRef = admin.database().ref('/PublicPost-VotableUserTable/' + postId + '/' + potentialVoterUserId)

	postVotableUserRef.set('true');

	console.log('populateVotesTable completed');

	return 0
});



exports.helloWorld = functions.https.onRequest((request, response) => {
	response.send("Hello from Firebase!");
});

exports.test = functions.https.onRequest((request, response) => {
	testPublicPost();
	response.send("HTTP request received");
});



exports.getusers = functions.https.onRequest((request, response) => {
	
	response.send("HTTP request received for ddd");
});


app.post('/publicPost', function(req, res) {
	console.log('publicPost');

	res.status(200).send();

	var postingUserId = '7r2r3UcHGLhpi6CHCnr6GB5VKfh1'
	var voterUserId = 'sn1ER4dPDjRr9rvtl0BzVuVgiZi1'

	var db = admin.database();
	var postsRef = db.ref("Post");

	var newPostRef = postsRef.push();
	var postId = newPostRef.key;
	newPostRef.set({
		userId: req.body.userId,
		timestamp: req.body.timestamp,
		image1Url: req.body.image1Url,
		image2Url: req.body.image2Url,
		totalVotesNeeded: req.body.totalVotesNeeded,
		voteType: req.body.voteType,
		'image1VoteCount': 0,
		'image2VoteCount': 0
	});

	console.log('publicPost completed');

	return 0;
});

exports.app = functions.https.onRequest(app);








