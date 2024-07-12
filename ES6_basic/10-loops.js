export default function appendToEachArrayValue(array, appendString) {
  const result = [];
  for (const item of array) {
    result.push(appendString + item);
  }

  return result;
}
