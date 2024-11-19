const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.Intrusion = functions.database.ref('/Intrusions').onWrite((change, context) => {
    const payload = {
        notification: {
            title: 'Intrusion Detected!',
            body: 'Tap here for details',
        }
    };

    return admin.database().ref('fcm-token').once('value').then(allToken => {
        if (allToken.val()) {
            console.log('Token available');
            const tokens = Object.keys(allToken.val());
            return admin.messaging().sendToDevice(tokens, payload);
        } else {
            console.log('No token available');
            return null;
        }
    }).catch(error => {
        console.error('Error sending message:', error);
    });
});

exports.Doorbell = functions.database.ref('/Doorbell').onWrite((change, context) => {
    const payload = {
        notification: {
            title: 'Someone is at the door!',
            body: 'Tap here for details',
        }
    };

    return admin.database().ref('fcm-token').once('value').then(allToken => {
        if (allToken.val()) {
            console.log('Token available');
            const tokens = Object.keys(allToken.val());
            return admin.messaging().sendToDevice(tokens, payload);
        } else {
            console.log('No token available');
            return null;
        }
    }).catch(error => {
        console.error('Error sending message:', error);
    });
});