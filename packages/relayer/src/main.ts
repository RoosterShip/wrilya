import { config } from 'dotenv';
config();

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
app.get('/ping', (req, res) => {
  // Send a response to the client
  res.send('poing');
});

app.get('/healthy', (req, res) => {
  // Send a response to the client
  res.send('OK');
});

app.get('/ready', (req, res) => {
  res.send('OK');
});

// Start the server and listen on the specified port
app.listen(port, () => {
  // Log a message when the server is successfully running
  console.log(`Server is running on http://localhost:${port}`);
});

await mqConnection.connect();

const { NotificationTable } = components!;

NotificationTable.update$.subscribe((update: { value: { operation: string, data: string, nid: string }[] }) => {
  const { operation: op, data: data, nid: nid } = update.value[0]!;
  const newNotification = {
    op: op,
    nid: nid,
    data: data
  };
  sendNotification(newNotification);
});