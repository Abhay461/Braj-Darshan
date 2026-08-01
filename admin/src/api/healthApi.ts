import { apiClient } from './client';
import { ApiResponse, HealthData } from '../types';

export const healthApi = {
  getHealth: (): Promise<ApiResponse<HealthData>> => apiClient.get('/health'),
};
