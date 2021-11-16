const functions = require("firebase-functions");
const admin= require('firebase-admin');

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions


admin.initializeApp();
exports.onMessageSend = functions.firestore.document('/chatRooms/{roomId}/chats/{document}').onCreate((snapshot, context) => {
    let roomId = context.params.roomId;
    const sendUserId = snapshot.data().sendBy;
    const message = snapshot.data().message;
    const fileUrl = snapshot.data().fileUrl;
    const messageType = snapshot.data().type;
    const type = [
        "Text",
        "Image",
        "Document",
        "Contact",
        "Location",
    ];
    
    
    const receiveUserId = roomId.replace('_','').replace(sendUserId,"");
    return admin.firestore().collection('users').doc(receiveUserId).get().then(result => {
        const data  = result.data();
        const tokenId = data.notificationId;
        
        const notificationContent = {
            notification: {
                title: `New Message from ${data.displayName}`,
                body: type[messageType] != "Text" && message == "" ?  `Sent you ${type[messageType]}` : message,
                icon: "default",
                sound : "default"
            }
        };
        admin.messaging().sendToDevice(tokenId,notificationContent).then(result => {
            console.log("Notification sent!");
            return null;
        });
    });
});

// not working
exports.onStoryUpload = functions.firestore.document('/users/{userId}').onUpdate(async (change,context) => {
    const userId = context.params.userId;
    const userAfterData = change.after.data();
    console.log(` userId: ${userId}`);
    if (userAfterData.story == null) return;
    const notificationContent = {
        notification: {
            title: "Story",
            body: `${userAfterData.displayName != "" ? userAfterData.displayName : userAfterData.userName} upload story`,
            icon: "default",
            sound : "default"
        }
    };
    await admin.messaging().sendToTopic("story",notificationContent).then(result => {
        console.log("Story notification sent!");
        return null;
    });
});

