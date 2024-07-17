import signUpUser from './4-user-promise';
import uploadPhoto from './5-photo-reject';

export default async function handleProfileSignup(
  firstName,
  lastName,
  filename,
) {
  const data = await Promise.allSettled([
    signUpUser(firstName, lastName),
    uploadPhoto(filename),
  ]);
  return data.map((item) => ({
    status: item.status,
    value:
      item.status === 'fulfilled'
        ? item.value
        : `${item.reason.name}: ${item.reason.message}`,
  }));
}
