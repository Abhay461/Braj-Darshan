import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { locationApi } from '../api/locationApi';
import { Location, QueryParams } from '../types';
import { useSnackbar } from 'notistack';

export const useLocations = (params?: QueryParams) => {
  return useQuery({
    queryKey: ['locations', params],
    queryFn: () => locationApi.getLocations(params),
  });
};

export const useLocationMutations = () => {
  const queryClient = useQueryClient();
  const { enqueueSnackbar } = useSnackbar();

  const createMutation = useMutation({
    mutationFn: (data: Partial<Location>) => locationApi.createLocation(data),
    onSuccess: (res) => {
      queryClient.invalidateQueries({ queryKey: ['locations'] });
      enqueueSnackbar(res.message || 'Location created', { variant: 'success' });
    },
    onError: (err: Error) => enqueueSnackbar(err.message, { variant: 'error' }),
  });

  const updateMutation = useMutation({
    mutationFn: ({ id, data }: { id: string; data: Partial<Location> }) => locationApi.updateLocation(id, data),
    onSuccess: (res) => {
      queryClient.invalidateQueries({ queryKey: ['locations'] });
      enqueueSnackbar(res.message || 'Location updated', { variant: 'success' });
    },
    onError: (err: Error) => enqueueSnackbar(err.message, { variant: 'error' }),
  });

  const deleteMutation = useMutation({
    mutationFn: (id: string) => locationApi.deleteLocation(id),
    onSuccess: (res) => {
      queryClient.invalidateQueries({ queryKey: ['locations'] });
      enqueueSnackbar(res.message || 'Location deleted', { variant: 'success' });
    },
    onError: (err: Error) => enqueueSnackbar(err.message, { variant: 'error' }),
  });

  return {
    createLocation: createMutation.mutateAsync,
    updateLocation: updateMutation.mutateAsync,
    deleteLocation: deleteMutation.mutateAsync,
    isCreating: createMutation.isPending,
    isUpdating: updateMutation.isPending,
  };
};
