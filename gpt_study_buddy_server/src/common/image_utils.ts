import axios from 'axios';

export const imageUrlToBase64 = async (url: string) => {
  try {
    const response = await axios.get(url, { responseType: 'arraybuffer' });
    const buffer = Buffer.from(response.data, 'binary');
    const base64 = buffer.toString('base64');
    const dataUri = `data:${response.headers['content-type']};base64,${base64}`;
    return dataUri;
  } catch (error) {
    console.error('Error fetching or converting image:', error.message);
    throw error;
  }
};
