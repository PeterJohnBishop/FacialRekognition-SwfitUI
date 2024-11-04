import { Server } from 'socket.io';
import express from 'express';
import http from 'http';
import bodyParser from 'body-parser';
import dotenv from 'dotenv';
import cors from 'cors';
import authRoutes from './routes/AuthenticationRoutes.js';
import userRoutes from './routes/UserRoutes.js';
import rekognitionRoutes from './routes/RekognitionRoutes.js';

dotenv.config();

const app = express();
const port = process.env.PORT || 4000;

app.use(bodyParser.json());

// CORS configuration
const allowedOrigins = [
  /^http:\/\/localhost(:\d+)?$/,
  'http://192.168.0.165',
  'http://localhost:3000',
  'http://192.168.0.165:3000',
];
const corsOptions = {
  origin: (origin, callback) => {
    if (!origin || allowedOrigins.some(o => typeof o === 'string' ? o === origin : o.test(origin))) {
      callback(null, true);
    } else {
      callback(new Error('Not allowed by CORS'));
    }
  },
  credentials: true,
};

app.use(cors(corsOptions));

app.get('/', (req, res) => {
  res.send('Welcome to my Node server!');
});

app.use('/authentication', authRoutes);
app.use('/users', userRoutes);
app.use('/rekognition', rekognitionRoutes);

// Create HTTP server and initialize Socket.IO on the same port
const server = http.createServer(app);
const io = new Server(server, {
  cors: {
    origin: allowedOrigins,
    methods: ["GET", "PUT", "POST", "DELETE"],
    credentials: true,
  },
});

// Configure Socket.IO
const configureSocketIO = (io) => {
  io.on('connection', (socket) => {
    console.log('A user connected on port:', io.httpServer.address().port);

    socket.on('ios', (data) => {
      console.log(`Message received on port ${io.httpServer.address().port}:`, data);
    });

    socket.on('fromFlutter', (data) => {
      console.log(`Message received on port ${io.httpServer.address().port}:`, data);
    });

    socket.on('fromReact', (data) => {
      console.log(`Message received on port ${io.httpServer.address().port}:`, data);
    });

    socket.on('disconnect', () => {
      console.log(`User disconnected from port ${io.httpServer.address().port}`);
    });
  });
};

configureSocketIO(io); // Attach Socket.IO event handlers

// Start the server
server.listen(port, () => {
  console.log(`Server with listening on port ${port}`);
});