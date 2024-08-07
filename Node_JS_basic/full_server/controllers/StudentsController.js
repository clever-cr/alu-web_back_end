import readDatabase from '../utils';

export default class StudentsController {
  static async getAllStudents(req, res) {
    try {
      const path = process.argv[2];
      const data = await readDatabase(path);

      let returnText = 'This is the list of our students\n';
      const lines = data
        .toString()
        .split('\n')
        .filter((line) => line.length > 0)
        .slice(1);
      const fields = lines.map((line) => line.split(','));
      const fieldNames = fields.map((field) => field[3]).flat();
      const uniqueFieldNames = [...new Set(fieldNames)];
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
      return res.status(200).end(returnText);
    } catch (error) {
      return res.status(500).end('Cannot load the database');
    }
  }

  static async getAllStudentsByMajor(req, res) {
    const { major } = req.params;
    if (major !== 'CS' && major !== 'SWE') {
      return res.status(500).end('Major parameter must be CS or SWE');
    }
    const path = process.argv[2];
    try {
      const data = await readDatabase(path);
      const lines = data
        .toString()
        .split('\n')
        .filter((line) => line.length > 0)
        .slice(1);
      const majorStudents = lines.filter(
        (line) => line.split(',')[3] === major,
      );
      const students = majorStudents.map((student) => student.split(',')[0]);
      const responseText = `List: ${students.join(', ')}`;
      return res.status(200).end(responseText);
    } catch (error) {
      return res.status(500).end('Cannot load the database');
    }
  }
}
