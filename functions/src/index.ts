import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();

// const db = admin.firestore();
const fcm = admin.messaging();

export const sendToTopic = functions.firestore
  .document('xpert_admin/{XpertID}/tokens')
  .onCreate(async snapshot => {
    const token = snapshot.data();

    const payload: admin.messaging.MessagingPayload = {
      notification: {
        title: 'New Order!',
        body: `${token} is ready for adoption`,
        click_action: 'FLUTTER_NOTIFICATION_CLICK' // required only for onResume or onLaunch callbacks
      }
    };

    return fcm.sendToTopic('orders', payload);
  });

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });
