import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { facilityApi } from '../api/facilityApi';
import { Facility, QueryParams } from '../types';
import { useSnackbar } from 'notistack';

export const useFacilities = (params?: QueryParams) => {
  return useQuery({
    queryKey: ['facilities', params],
    queryFn: () => facilityApi.getFacilities(params),
  });
};

export const useFacilityMutations = () => {
  const queryClient = useQueryClient();
  const { enqueueSnackbar } = useSnackbar();

  const createMutation = useMutation({
    mutationFn: (data: Partial<Facility>) => facilityApi.createFacility(data),
    onSuccess: (res) => {
      queryClient.invalidateQueries({ queryKey: ['facilities'] });
      enqueueSnackbar(res.message || 'Facility created', { variant: 'success' });
    },
    onError: (err: Error) => enqueueSnackbar(err.message, { variant: 'error' }),
  });

  const updateMutation = useMutation({
    mutationFn: ({ id, data }: { id: string; data: Partial<Facility> }) => facilityApi.updateFacility(id, data),
    onSuccess: (res) => {
      queryClient.invalidateQueries({ queryKey: ['facilities'] });
      enqueueSnackbar(res.message || 'Facility updated', { variant: 'success' });
    },
    onError: (err: Error) => enqueueSnackbar(err.message, { variant: 'error' }),
  });

  const deleteMutation = useMutation({
    mutationFn: (id: string) => facilityApi.deleteFacility(id),
    onSuccess: (res) => {
      queryClient.invalidateQueries({ queryKey: ['facilities'] });
      enqueueSnackbar(res.message || 'Facility deleted', { variant: 'success' });
    },
    onError: (err: Error) => enqueueSnackbar(err.message, { variant: 'error' }),
  });

  return {
    createFacility: createMutation.mutateAsync,
    updateFacility: updateMutation.mutateAsync,
    deleteFacility: deleteMutation.mutateAsync,
    isCreating: createMutation.isPending,
    isUpdating: updateMutation.isPending,
  };
};
