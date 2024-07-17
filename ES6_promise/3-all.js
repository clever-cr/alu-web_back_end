import { uploadPhoto, createUser } from './utils';

export default async function handleProfileSignup() {
  try {
    const body = await uploadPhoto();
    const user = await createUser();
    console.log(`${body.body} ${user.firstName} ${user.lastName}`);
  } catch (error) {
    console.log('Signup system offline');
  }
}
