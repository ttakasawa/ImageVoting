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

// Function fopr the test
function testFunction(postId){

	console.log('testFunction completed');
	// increment '/Test3/{idCandidate}/count'

	var db = admin.database();
	var userRecordRef = db.ref("Test3/" + postId + "/count/");

	console.log('hit')

	userRecordRef.once('value', function(snap)  {
		var voteCounter = snap.val()
		console.log(voteCounter)
		voteCounter = voteCounter + 1
		userRecordRef.set(voteCounter)
	});

	return 0;

}

exports.countlikechange = functions.database.ref("/posts/{postid}/likes/{likeid}").onWrite((event) => {
  var collectionRef = event.data.ref.parent;
  var countRef = collectionRef.parent.child('likes_count');

  return countRef.transaction(function(current) {
    if (event.data.exists() && !event.data.previous.exists()) {
      return (current || 0) + 1;
    }
    else if (!event.data.exists() && event.data.previous.exists()) {
      return (current || 0) - 1;
    }
  });
});


// function to increment the vote count for the post
function incrementVote(postId, isImage1){

	var db = admin.database();
	var postCounterRef = db.ref("Post/" + postId + "/image1VoteCount/");

	if (isImage1 === true) {
		postCounterRef = db.ref("Post/" + postId + "/image1VoteCount/");
	}else{
		postCounterRef = db.ref("Post/" + postId + "/image2VoteCount/");
	}

	console.log('hit')

	postCounterRef.once('value', function(snap)  {
		var voteCounter = snap.val()
		console.log(voteCounter)
		voteCounter = voteCounter + 1
		postCounterRef.set(voteCounter)
	});

	return 0;

}


// place post Id to given users' voting table. 
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


// This function grabs ALL (<-need fix for scalability) potential voters' userId
// and call placePostOnUserTable function 
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


// function to place the post record to user's data
function appendPostIdToPosterTable(userId, postId){
	var db = admin.database();
	var userRecordRef = db.ref("User/" + userId + "/records/" + postId);
	//var newuserRecordRef = userRecordRef.push();

	userRecordRef.set(true);

	return 0;
}


// function to copy one table to another
function copyTableFromDefault(userId) {
	var db = admin.database();
	var userTableRef = db.ref("User-VotablePublicPostTable/" + userId);
	var defaultTableRef = db.ref("User-VotablePublicPostTable/7r2r3UcHGLhpi6CHCnr6GB5VKfh1");
	
	return copyFbRecord(defaultTableRef, userTableRef);
}


// helper function to copy one node to another on the real time database
function copyFbRecord(oldRef, newRef) {    
     oldRef.once('value', function(snap)  {
          newRef.set( snap.val(), function(error) {
               if( typeof(console) !== 'undefined' && console.error ) {  console.error(error); }
          });
     });
}






function deletePostKeyFromTable(potentialVoterUserIdArray, postId){

	async.each(potentialVoterUserIdArray, function(i, callback){
		console.log('update userPost');
		console.log(i);

	    var userPublicVotableRef = admin.database().ref('User-VotablePublicPostTable/' + i + '/' + postId);
		userPublicVotableRef.set(null);


	}, function(err){

	    if(err) throw err;
	    return 0;
	});

	var PostUserTableRef = admin.database().ref('PublicPost-VotableUserTable/' + postId);
	PostUserTableRef.set(null);

	return 0;
}



function getUserIdsToRemoveFrom(postId){

	console.log('activated');

	var userIds = []
	
	users = admin.database().ref('PublicPost-VotableUserTable/' + postId).once('value').then((results) => {

		results.forEach(function(childSnapshot) {
			const userKey = childSnapshot.key;
			userIds.push(userKey);
		});

		return deletePostKeyFromTable(userIds, postId);
	});

	users.catch(function(error) {
	    console.log(error);
	    return [];
	});
}





// user make a post
app.post('/publicPost', function(req, res) {
	console.log('publicPost');

	res.status(200).send();

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


// copy the default voting table for a new user
app.post('/copyVotableTable', function(req, res) {

	var userId = req.body.userId;
	console.log('copyVotableTable hit');
	copyTableFromDefault(userId);
	res.status(200).send();
});

exports.app = functions.https.onRequest(app);






exports.helloWorld = functions.https.onRequest((request, response) => {
	response.send("Hello from Firebase!");
});

exports.test = functions.https.onRequest((request, response) => {
	testFunction('id');
	response.send("HTTP request received");
});


// When new post is added, this function will get post key and call function to append the key under the potential voters
exports.populateUsersTable = functions.database.ref('/Post/{postKey}').onCreate((snapshot, context) => {

	console.log('populateUsersTable activated');


	const postId = context.params.postKey;
	const postPublished = snapshot.val();
	const posterId = postPublished.userId;

	if (postPublished.voteType === 'publicSelection') {
		getUserIdsToVote(posterId, postId);
	}else{
		console.log('not implemented yet');
	}

	console.log('populateUsersTable completed');

	return appendPostIdToPosterTable(posterId, postId);
});


// When user's table is filled with new post key, this will call a function to insert the userId under postKey
exports.populateVotesTableForPublicPost = functions.database.ref('/User-VotablePublicPostTable/{potentialVoterUserId}/{postId}').onCreate((snapshot, context) => {

	console.log('populateVotesTable activated');

	const postId = context.params.postId
	const potentialVoterUserId = context.params.potentialVoterUserId

	var postVotableUserRef = admin.database().ref('/PublicPost-VotableUserTable/' + postId + '/' + potentialVoterUserId)

	postVotableUserRef.set('true');

	console.log('populateVotesTable completed');

	return 0
});


// TODO: function to get counter of post and call getUserIdsToRemoveFrom
exports.removePostFromUserTable = functions.database.ref('/Post/{postId}/voteCount').onUpdate((snapshot, context) => {

	console.log('populateVotesTable activated');

	const postId = context.params.postId;
	const voteCounter = snapshot.after.val();

	console.log(voteCounter)

	if (voteCounter > 9) {
		getUserIdsToRemoveFrom(postId)
	}
	

	return 0
});

exports.deletePostIdFromUserTable = functions.database.ref('/Post/{postKey}').onCreate((snapshot, context) => {

	//call functuon 

	return 0
});


