import { apiClient } from './client';
import { ApiResponse, Category, QueryParams } from '../types';

export const categoryApi = {
  getCategories: (params?: QueryParams): Promise<ApiResponse<Category[]>> =>
    apiClient.get('/categories', { params }),

  getCategory: (idOrSlug: string): Promise<ApiResponse<Category>> =>
    apiClient.get(`/categories/${idOrSlug}`),

  createCategory: (data: Partial<Category>): Promise<ApiResponse<Category>> =>
    apiClient.post('/categories', data),

  updateCategory: (id: string, data: Partial<Category>): Promise<ApiResponse<Category>> =>
    apiClient.put(`/categories/${id}`, data),

  deleteCategory: (id: string): Promise<ApiResponse<null>> =>
    apiClient.delete(`/categories/${id}`),

  restoreCategory: (id: string): Promise<ApiResponse<Category>> =>
    apiClient.patch(`/categories/${id}/restore`),
};
