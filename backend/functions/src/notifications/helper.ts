import { firestore, messaging } from "firebase-admin";

const getTokens = async (uid: string): Promise<string[]> => {
  const tokens: string[] = [];

  try {
    const usersRef = firestore().doc(`users/${uid}`);
    const devicesRef = usersRef.collection("devices");

    const devicesSnap = await devicesRef.get();
    if (!devicesSnap.empty) {
      for (const devicesDoc of devicesSnap.docs) {
        if (devicesDoc.exists) {
          const devicesData = devicesDoc.data();
          if (typeof devicesData !== "undefined") {
            const { token } = devicesData;
            tokens.push(token);
          }
        }
      }
    }
  } catch (error) {
    console.log("Error!!!: Getting tokens", error);
  }

  return tokens;
};

const prepareNotification = (
  title: string,
  body: string,
  data: any
): Object => {
  return {
    notification: {
      title,
      body,
    },
    data,
    android: {
      notification: {
        click_action: "FLUTTER_NOTIFICATION_CLICK",
      },
    },
    token: "",
  };
};

const sendNotification = async (
  tokens: string[],
  notif: any
): Promise<void> => {
  try {
    for (const token of tokens) {
      if (typeof notif !== "undefined") {
        notif.token = token;
        await messaging().send(notif);
      }
    }
    console.log("Success: Sending notification");
  } catch (error) {
    console.log("Error!!!: Sending notification", error);
  }
};

const sendNotificationToCol = async (
  userId: string,
  data: any
): Promise<void> => {
  try {
    const fs = firestore();
    const userRef = fs.doc(`users/${userId}`);
    const notifRef = userRef.collection("notifications").doc();
    const currentDate = Date.now();

    await notifRef.set({ ...data, id: notifRef.id, updated_at: currentDate });

    console.log(`Success: Sending to notif collection of ${userId}`);
  } catch (error) {
    console.log(`Error!!!: Sending to notif collection of ${userId}`, error);
  }
};

export {
  getTokens,
  sendNotification,
  prepareNotification,
  sendNotificationToCol,
};
