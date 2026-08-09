import axios from 'axios';

const API_BASE_URL = 'https://braj-darshan-wdw9.onrender.com/api/v1';
const DEFAULT_ADMIN_KEY = 'braj_darshan_admin_secret_key_2026';

export const apiClient = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
  timeout: 60000,
});

apiClient.interceptors.request.use((config) => {
  config.headers['x-admin-api-key'] = import.meta.env.VITE_ADMIN_API_KEY || DEFAULT_ADMIN_KEY;
  return config;
});

apiClient.interceptors.response.use(
  (response) => response.data,
  (error) => {
    const message =
      error.response?.data?.message || error.message || 'An unexpected error occurred';
    return Promise.reject(new Error(message));
  }
);
