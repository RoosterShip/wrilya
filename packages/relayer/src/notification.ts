import mqConnection from "./connection";

export type INotification = {
  op: string;
  nid: string;
  data: string;
};

export const sendNotification = async (notification: INotification) => {
  await mqConnection.sendToQueue(process.env.NOTIFICATION_QUEUE!, notification);

  console.log(`Sent the notification to consumer`);
};