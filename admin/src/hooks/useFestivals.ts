import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { festivalApi } from '../api/festivalApi';
import { Festival, QueryParams } from '../types';
import { useSnackbar } from 'notistack';

export const useFestivals = (params?: QueryParams) => {
  return useQuery({
    queryKey: ['festivals', params],
    queryFn: () => festivalApi.getFestivals(params),
  });
};

export const useUpcomingFestivals = (limit = 10) => {
  return useQuery({
    queryKey: ['festivals', 'upcoming', limit],
    queryFn: () => festivalApi.getUpcoming(limit),
  });
};

export const useFestivalMutations = () => {
  const queryClient = useQueryClient();
  const { enqueueSnackbar } = useSnackbar();

  const createMutation = useMutation({
    mutationFn: (data: Partial<Festival>) => festivalApi.createFestival(data),
    onSuccess: (res) => {
      queryClient.invalidateQueries({ queryKey: ['festivals'] });
      enqueueSnackbar(res.message || 'Festival created', { variant: 'success' });
    },
    onError: (err: Error) => enqueueSnackbar(err.message, { variant: 'error' }),
  });

  const updateMutation = useMutation({
    mutationFn: ({ id, data }: { id: string; data: Partial<Festival> }) => festivalApi.updateFestival(id, data),
    onSuccess: (res) => {
      queryClient.invalidateQueries({ queryKey: ['festivals'] });
      enqueueSnackbar(res.message || 'Festival updated', { variant: 'success' });
    },
    onError: (err: Error) => enqueueSnackbar(err.message, { variant: 'error' }),
  });

  const deleteMutation = useMutation({
    mutationFn: (id: string) => festivalApi.deleteFestival(id),
    onSuccess: (res) => {
      queryClient.invalidateQueries({ queryKey: ['festivals'] });
      enqueueSnackbar(res.message || 'Festival deleted', { variant: 'success' });
    },
    onError: (err: Error) => enqueueSnackbar(err.message, { variant: 'error' }),
  });

  return {
    createFestival: createMutation.mutateAsync,
    updateFestival: updateMutation.mutateAsync,
    deleteFestival: deleteMutation.mutateAsync,
    isCreating: createMutation.isPending,
    isUpdating: updateMutation.isPending,
  };
};
