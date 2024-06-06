import { NOTIFICATION_QUEUE } from "./config";
import mqConnection from "./connection";

export type INotification = {
  op: string;
  nid: string;
  data: string;
};

export const sendNotification = async (notification: INotification) => {
  await mqConnection.sendToQueue(NOTIFICATION_QUEUE, notification);

  console.log(`Sent the notification to consumer`);
};