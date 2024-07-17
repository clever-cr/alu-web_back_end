export default function guardrail(mathFunction) {
  const queque = [];
  try {
    queque.push(mathFunction());
  } catch (error) {
    queque.push(`Error: ${error.message}`);
  } finally {
    queque.push('Guardrail was processed');
  }
  return queque;
}
