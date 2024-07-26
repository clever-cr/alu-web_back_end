import { promises as fs } from 'fs';

export default function readDatabase(path) {
  return fs.readFile(path, 'utf-8');
}
