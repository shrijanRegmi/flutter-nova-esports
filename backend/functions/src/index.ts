import { initializeApp } from "firebase-admin";
import roundWinLoseNotif from "./notifications/tournament/round_win_lose_notif";
initializeApp();

exports.roundWinLoseNotif = roundWinLoseNotif;
