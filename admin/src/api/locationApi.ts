import { apiClient } from './client';
import { ApiResponse, Location, QueryParams } from '../types';

export const locationApi = {
  getLocations: (params?: QueryParams): Promise<ApiResponse<Location[]>> =>
    apiClient.get('/locations', { params }),

  getLocation: (idOrSlug: string): Promise<ApiResponse<Location>> =>
    apiClient.get(`/locations/${idOrSlug}`),

  createLocation: (data: Partial<Location>): Promise<ApiResponse<Location>> =>
    apiClient.post('/locations', data),

  updateLocation: (id: string, data: Partial<Location>): Promise<ApiResponse<Location>> =>
    apiClient.put(`/locations/${id}`, data),

  deleteLocation: (id: string): Promise<ApiResponse<null>> =>
    apiClient.delete(`/locations/${id}`),

  restoreLocation: (id: string): Promise<ApiResponse<Location>> =>
    apiClient.patch(`/locations/${id}/restore`),
};
