import { apiClient } from './client';
import { ApiResponse, EmergencyContact, QueryParams } from '../types';

export const emergencyApi = {
  getEmergencyContacts: (params?: QueryParams): Promise<ApiResponse<EmergencyContact[]>> =>
    apiClient.get('/emergency-contacts', { params }),

  getEmergencyContact: (id: string): Promise<ApiResponse<EmergencyContact>> =>
    apiClient.get(`/emergency-contacts/${id}`),

  getByCategory: (category: string, area?: string): Promise<ApiResponse<EmergencyContact[]>> =>
    apiClient.get(`/emergency-contacts/category/${category}`, { params: { area } }),

  createEmergencyContact: (data: Partial<EmergencyContact>): Promise<ApiResponse<EmergencyContact>> =>
    apiClient.post('/emergency-contacts', data),

  updateEmergencyContact: (id: string, data: Partial<EmergencyContact>): Promise<ApiResponse<EmergencyContact>> =>
    apiClient.put(`/emergency-contacts/${id}`, data),

  deleteEmergencyContact: (id: string): Promise<ApiResponse<null>> =>
    apiClient.delete(`/emergency-contacts/${id}`),

  restoreEmergencyContact: (id: string): Promise<ApiResponse<EmergencyContact>> =>
    apiClient.patch(`/emergency-contacts/${id}/restore`),
};

