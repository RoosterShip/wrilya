import client, { Connection, Channel } from "amqplib";

class RabbitMQConnection {
  connection!: Connection;
  channel!: Channel;
  private connected!: boolean;

  async connect() {
    if (this.connected && this.channel) return;
    else this.connected = true;

    try {

      const server = `amqp://${process.env.RABBITMQ_USER}:${process.env.RABBITMQ_PASS}@${process.env.RABBITMQ_HOST}:${process.env.RABBITMQ_PORT}`;
      console.log(`⌛️ Connecting to Rabbit-MQ Server ${server}`);
      this.connection = await client.connect(server);

      console.log(`✅ Rabbit MQ Connection is ready`);
      this.channel = await this.connection.createChannel();
      console.log(`🛸 Created RabbitMQ Channel successfully`);
    } catch (error) {
      console.error(error);
      console.error(`Not connected to MQ Server`);
    }
  }

  isConnected(): boolean { return this.connected; }

  async sendToQueue(queue: string, message: object) {
    try {
      if (!this.channel) {
        await this.connect();
      }

      this.channel.sendToQueue(queue, Buffer.from(JSON.stringify(message)));
    } catch (error) {
      console.error(error);
      throw error;
    }
  }
}

const mqConnection = new RabbitMQConnection();

export default mqConnection;