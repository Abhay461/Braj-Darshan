import { apiClient } from './client';
import { ApiResponse, Facility, QueryParams } from '../types';

export const facilityApi = {
  getFacilities: (params?: QueryParams): Promise<ApiResponse<Facility[]>> =>
    apiClient.get('/facilities', { params }),

  getFacility: (idOrSlug: string): Promise<ApiResponse<Facility>> =>
    apiClient.get(`/facilities/${idOrSlug}`),

  createFacility: (data: Partial<Facility>): Promise<ApiResponse<Facility>> =>
    apiClient.post('/facilities', data),

  updateFacility: (id: string, data: Partial<Facility>): Promise<ApiResponse<Facility>> =>
    apiClient.put(`/facilities/${id}`, data),

  deleteFacility: (id: string): Promise<ApiResponse<null>> =>
    apiClient.delete(`/facilities/${id}`),

  restoreFacility: (id: string): Promise<ApiResponse<Facility>> =>
    apiClient.patch(`/facilities/${id}/restore`),
};
