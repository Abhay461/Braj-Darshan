import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { templeApi } from '../api/templeApi';
import { QueryParams, Temple } from '../types';
import { useSnackbar } from 'notistack';

export const useTemples = (params?: QueryParams) => {
  return useQuery({
    queryKey: ['temples', params],
    queryFn: () => templeApi.getTemples(params),
  });
};

export const useTemple = (idOrSlug: string) => {
  return useQuery({
    queryKey: ['temple', idOrSlug],
    queryFn: () => templeApi.getTemple(idOrSlug),
    enabled: !!idOrSlug,
  });
};

export const useFeaturedTemples = (limit = 10) => {
  return useQuery({
    queryKey: ['temples', 'featured', limit],
    queryFn: () => templeApi.getFeatured(limit),
  });
};

export const usePopularTemples = (limit = 10) => {
  return useQuery({
    queryKey: ['temples', 'popular', limit],
    queryFn: () => templeApi.getPopular(limit),
  });
};

export const useRecentTemples = (limit = 10) => {
  return useQuery({
    queryKey: ['temples', 'recent', limit],
    queryFn: () => templeApi.getRecent(limit),
  });
};

export const useTempleMutations = () => {
  const queryClient = useQueryClient();
  const { enqueueSnackbar } = useSnackbar();

  const createMutation = useMutation({
    mutationFn: (data: Partial<Temple>) => templeApi.createTemple(data),
    onSuccess: (res) => {
      queryClient.invalidateQueries({ queryKey: ['temples'] });
      enqueueSnackbar(res.message || 'Temple created successfully', { variant: 'success' });
    },
    onError: (err: Error) => {
      enqueueSnackbar(err.message || 'Failed to create temple', { variant: 'error' });
    },
  });

  const updateMutation = useMutation({
    mutationFn: ({ id, data }: { id: string; data: Partial<Temple> }) => templeApi.updateTemple(id, data),
    onSuccess: (res) => {
      queryClient.invalidateQueries({ queryKey: ['temples'] });
      enqueueSnackbar(res.message || 'Temple updated successfully', { variant: 'success' });
    },
    onError: (err: Error) => {
      enqueueSnackbar(err.message || 'Failed to update temple', { variant: 'error' });
    },
  });

  const deleteMutation = useMutation({
    mutationFn: (id: string) => templeApi.deleteTemple(id),
    onSuccess: (res) => {
      queryClient.invalidateQueries({ queryKey: ['temples'] });
      enqueueSnackbar(res.message || 'Temple soft-deleted successfully', { variant: 'success' });
    },
    onError: (err: Error) => {
      enqueueSnackbar(err.message || 'Failed to delete temple', { variant: 'error' });
    },
  });

  const restoreMutation = useMutation({
    mutationFn: (id: string) => templeApi.restoreTemple(id),
    onSuccess: (res) => {
      queryClient.invalidateQueries({ queryKey: ['temples'] });
      enqueueSnackbar(res.message || 'Temple restored successfully', { variant: 'success' });
    },
    onError: (err: Error) => {
      enqueueSnackbar(err.message || 'Failed to restore temple', { variant: 'error' });
    },
  });

  return {
    createTemple: createMutation.mutateAsync,
    updateTemple: updateMutation.mutateAsync,
    deleteTemple: deleteMutation.mutateAsync,
    restoreTemple: restoreMutation.mutateAsync,
    isCreating: createMutation.isPending,
    isUpdating: updateMutation.isPending,
    isDeleting: deleteMutation.isPending,
    isRestoring: restoreMutation.isPending,
  };
};
