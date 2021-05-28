import * as functions from "firebase-functions";
import {
  getTokens,
  prepareNotification,
  sendNotification,
  sendNotificationToCol,
} from "../helper";

const roundWinLoseNotif = functions.firestore
  .document("round_win_lose_triggers/{round_win_lose_id}")
  .onCreate(async (snap) => {
    if (snap.exists) {
      try {
        const snapData = snap.data();
        if (typeof snapData !== "undefined") {
          const { winners, losers, tournament_id } = snapData;

          for (const winner of winners) {
            const tokens = await getTokens(winner);
            const notifData = {
              notif_title: "Round Won !",
              notif_body: "Congrats! your team has won this round.",
              extra_id: tournament_id,
            };

            const fcm = prepareNotification(
              notifData.notif_title,
              notifData.notif_body,
              {}
            );

            await sendNotification(tokens, fcm);

            await sendNotificationToCol(winner, notifData);
          }

          for (const loser of losers) {
            const tokens = await getTokens(loser);
            const fcm = prepareNotification(
              "Round Lost !",
              "Sorry you have lost the round. Please try again later",
              {}
            );

            await sendNotification(tokens, fcm);
          }
        }
      } catch ({ message }) {
        console.log("Error!!!: Sending round win lose notification", message);
      }
    }
    return true;
  });

export default roundWinLoseNotif;
