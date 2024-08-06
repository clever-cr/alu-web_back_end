const fs = require('fs');

function countStudents(path) {
  try {
    const data = fs.readFileSync(path, { encoding: 'utf8' });
    const lines = data
      .split('\n')
      .filter((line) => line.length > 0)
      .slice(1);
    const fields = lines.map((line) => line.split(','));
    const fieldNames = fields.map((field) => field[3]).flat();
    const uniqueFieldNames = [...new Set(fieldNames)];
    console.log(`Number of students: ${fields.length}`);
    uniqueFieldNames.forEach((field) => {
      const students = fields.filter((student) => student[3] === field);
      const studentNames = students.map((student) => student[0]);
      console.log(
        `Number of students in ${field}: ${
          students.length
        }. List: ${studentNames.join(', ')}`,
      );
    });
  } catch (error) {
    throw new Error('Cannot load the database');
  }
}

module.exports = countStudents;
