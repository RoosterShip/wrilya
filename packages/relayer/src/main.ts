// Import the 'express' module
import express from 'express';
import { setup } from './mud/setup';

import mqConnection from "./connection";
import { sendNotification } from "./notification";

// Connect to MUD
const {
  components,
} = await setup();


// Create an Express application
const app = express();

// Set the port number for the server
const port = 6000;

// Define a route for the root path ('/')
app.get('/', (req, res) => {
  // Send a response to the client
  res.send('Hello, TypeScript + Node.js + Express!');
});

// Start the server and listen on the specified port
app.listen(port, () => {
  // Log a message when the server is successfully running
  console.log(`Server is running on http://localhost:${port}`);
});

await mqConnection.connect();

const { NotificationTable } = components!;

NotificationTable.update$.subscribe((update) => {
  const { operation: op, data: data, nid: nid } = update.value[0]!;
  const newNotification = {
    op: op,
    nid: nid,
    data: data
  };
  sendNotification(newNotification);
});