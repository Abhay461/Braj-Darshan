import { apiClient } from './client';
import { ApiResponse, Temple, QueryParams } from '../types';

export const templeApi = {
  getTemples: (params?: QueryParams): Promise<ApiResponse<Temple[]>> =>
    apiClient.get('/temples', { params }),

  getTemple: (idOrSlug: string): Promise<ApiResponse<Temple>> =>
    apiClient.get(`/temples/${idOrSlug}`),

  getFeatured: (limit = 10): Promise<ApiResponse<Temple[]>> =>
    apiClient.get('/temples/featured', { params: { limit } }),

  getPopular: (limit = 10): Promise<ApiResponse<Temple[]>> =>
    apiClient.get('/temples/popular', { params: { limit } }),

  getRecent: (limit = 10): Promise<ApiResponse<Temple[]>> =>
    apiClient.get('/temples/recent', { params: { limit } }),

  getNearby: (lat: number, lng: number, radius = 0.05, limit = 10): Promise<ApiResponse<Temple[]>> =>
    apiClient.get('/temples/nearby', { params: { lat, lng, radius, limit } }),

  createTemple: (data: Partial<Temple>): Promise<ApiResponse<Temple>> =>
    apiClient.post('/temples', data),

  updateTemple: (id: string, data: Partial<Temple>): Promise<ApiResponse<Temple>> =>
    apiClient.put(`/temples/${id}`, data),

  deleteTemple: (id: string): Promise<ApiResponse<null>> =>
    apiClient.delete(`/temples/${id}`),

  restoreTemple: (id: string): Promise<ApiResponse<Temple>> =>
    apiClient.patch(`/temples/${id}/restore`),
};
