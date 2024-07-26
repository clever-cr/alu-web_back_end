const express = require('express');
const fs = require('fs');

const app = express();

app.get('/', (req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
  res.send('Hello Holberton School!');
});

const readDb = async (path) =>
  new Promise((resolve, reject) => {
    fs.readFile(path, { encoding: 'utf8' }, (err, data) => {
      if (err) {
        reject(new Error('Cannot load the database'));
        return;
      }
      resolve(data);
    });
  });

app.get('/students', async (req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
  let returnText = 'This is the list of our students\n';
  res.write(returnText);
  try {
    const data = await readDb(process.argv[2]);

    const lines = data
      .toString()
      .split('\n')
      .filter((line) => line.length > 0)
      .slice(1);
    const fields = lines.map((line) => line.split(','));
    const fieldNames = fields.map((field) => field[3]).flat();
    const uniqueFieldNames = [...new Set(fieldNames)];
    returnText += `Number of students: ${fields.length}\n`;
    uniqueFieldNames.forEach((field, index) => {
      const students = fields.filter((student) => student[3] === field);
      const studentNames = students.map((student) => student[0]);
      if (index === uniqueFieldNames.length - 1) {
        returnText += `Number of students in ${field}: ${
          students.length
        }. List: ${studentNames.join(', ')}`;
        return;
      }
      returnText += `Number of students in ${field}: ${
        students.length
      }. List: ${studentNames.join(', ')}\n`;
    });
    res.write(returnText);
    res.end();
  } catch (error) {
    res.statusCode = 404;
    res.end('Cannot load the database');
  }
});

app.listen(1245);

module.exports = app;
