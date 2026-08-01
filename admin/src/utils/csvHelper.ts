import { Temple } from '../types';

export const exportToJson = (data: unknown, filename: string) => {
  const jsonString = `data:text/json;charset=utf-8,${encodeURIComponent(
    JSON.stringify(data, null, 2)
  )}`;
  const downloadAnchor = document.createElement('a');
  downloadAnchor.setAttribute('href', jsonString);
  downloadAnchor.setAttribute('download', `${filename}.json`);
  document.body.appendChild(downloadAnchor);
  downloadAnchor.click();
  downloadAnchor.remove();
};

export const parseCsvTemples = (csvText: string): Partial<Temple>[] => {
  const lines = csvText.split('\n').filter((l) => l.trim().length > 0);
  if (lines.length <= 1) return [];

  const headers = lines[0].split(',').map((h) => h.trim().replace(/^"|"$/g, ''));
  const temples: Partial<Temple>[] = [];

  for (let i = 1; i < lines.length; i++) {
    const values = lines[i].split(',').map((v) => v.trim().replace(/^"|"$/g, ''));
    if (values.length < 3) continue;

    const templeObj: Record<string, unknown> = {};
    headers.forEach((header, index) => {
      if (values[index] !== undefined) {
        templeObj[header] = values[index];
      }
    });

    temples.push({
      name: (templeObj.name as string) || 'Imported Temple',
      shortDescription: (templeObj.shortDescription as string) || (templeObj.description as string) || '',
      history: (templeObj.history as string) || '',
      importance: (templeObj.importance as string) || '',
      coverImage: (templeObj.coverImage as string) || 'https://res.cloudinary.com/demo/image/upload/v1/braj-darshan/misc/cover.jpg',
      latitude: parseFloat(templeObj.latitude as string) || 27.5830,
      longitude: parseFloat(templeObj.longitude as string) || 77.7000,
      darshanTiming: (templeObj.darshanTiming as string) || '',
      phone: (templeObj.phone as string) || '',
      website: (templeObj.website as string) || '',
      status: 'active',
    });
  }

  return temples;
};
