/* eslint-disable no-console */
import express from 'express';
import router from './routes';

const app = express();

app.use(express.json());

app.use(express.urlencoded({ extended: true }));
app.use(router);

app.listen(1245, () => console.log('Server is running on port 1245'));

export default app;
