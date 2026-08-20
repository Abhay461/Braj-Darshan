import { apiClient } from './client';
import { ApiResponse, MapSettings } from '../types';

export const mapSettingsApi = {
  getMapSettings: (): Promise<ApiResponse<MapSettings>> =>
    apiClient.get('/map-settings'),

  updateMapSettings: (data: Partial<MapSettings>): Promise<ApiResponse<MapSettings>> =>
    apiClient.put('/map-settings', data),

  resetMapSettings: (): Promise<ApiResponse<MapSettings>> =>
    apiClient.post('/map-settings/reset'),
};
