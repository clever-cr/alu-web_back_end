export default class AppController {
  static getHomePage(req, res) {
    return res.status(200).end('Hello Holberton School!');
  }
}
