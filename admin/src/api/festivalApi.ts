import { apiClient } from './client';
import { ApiResponse, Festival, QueryParams } from '../types';

export const festivalApi = {
  getFestivals: (params?: QueryParams): Promise<ApiResponse<Festival[]>> =>
    apiClient.get('/festivals', { params }),

  getFestival: (idOrSlug: string): Promise<ApiResponse<Festival>> =>
    apiClient.get(`/festivals/${idOrSlug}`),

  getUpcoming: (limit = 10): Promise<ApiResponse<Festival[]>> =>
    apiClient.get('/festivals/upcoming', { params: { limit } }),

  getByTemple: (templeId: string): Promise<ApiResponse<Festival[]>> =>
    apiClient.get(`/festivals/temple/${templeId}`),

  createFestival: (data: Partial<Festival>): Promise<ApiResponse<Festival>> =>
    apiClient.post('/festivals', data),

  updateFestival: (id: string, data: Partial<Festival>): Promise<ApiResponse<Festival>> =>
    apiClient.put(`/festivals/${id}`, data),

  deleteFestival: (id: string): Promise<ApiResponse<null>> =>
    apiClient.delete(`/festivals/${id}`),

  restoreFestival: (id: string): Promise<ApiResponse<Festival>> =>
    apiClient.patch(`/festivals/${id}/restore`),
};
