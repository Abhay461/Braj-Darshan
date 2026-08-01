import { apiClient } from './client';
import { ApiResponse, GalleryImage } from '../types';

export const uploadApi = {
  uploadCover: (file: File, slug = 'general'): Promise<ApiResponse<{ imageUrl: string; thumbnailUrl: string; publicId: string }>> => {
    const formData = new FormData();
    formData.append('image', file);
    formData.append('slug', slug);
    return apiClient.post('/upload/cover', formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
    });
  },

  uploadGallery: (file: File, slug = 'general', caption = '', order = 0): Promise<ApiResponse<GalleryImage>> => {
    const formData = new FormData();
    formData.append('image', file);
    formData.append('slug', slug);
    formData.append('caption', caption);
    formData.append('order', order.toString());
    return apiClient.post('/upload/gallery', formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
    });
  },

  uploadMultipleGallery: (files: File[], slug = 'general'): Promise<ApiResponse<GalleryImage[]>> => {
    const formData = new FormData();
    files.forEach((file) => formData.append('images', file));
    formData.append('slug', slug);
    return apiClient.post('/upload/gallery-multiple', formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
    });
  },

  uploadGeneric: (file: File, folder = 'misc'): Promise<ApiResponse<{ imageUrl: string; thumbnailUrl: string; publicId: string }>> => {
    const formData = new FormData();
    formData.append('image', file);
    formData.append('folder', folder);
    return apiClient.post('/upload/image', formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
    });
  },

  deleteImage: (urlOrPublicId: string): Promise<ApiResponse<null>> =>
    apiClient.delete('/upload', { data: { publicId: urlOrPublicId, url: urlOrPublicId } }),
};
