import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { emergencyApi } from '../api/emergencyApi';
import { EmergencyContact, QueryParams } from '../types';
import { useSnackbar } from 'notistack';

export const useEmergencyContacts = (params?: QueryParams) => {
  return useQuery({
    queryKey: ['emergency-contacts', params],
    queryFn: () => emergencyApi.getEmergencyContacts(params),
  });
};

export const useEmergencyContactsByCategory = (category: string, area?: string) => {
  return useQuery({
    queryKey: ['emergency-contacts', 'category', category, area],
    queryFn: () => emergencyApi.getByCategory(category, area),
    enabled: !!category,
  });
};

export const useEmergencyContactMutations = () => {
  const queryClient = useQueryClient();
  const { enqueueSnackbar } = useSnackbar();

  const createMutation = useMutation({
    mutationFn: (data: Partial<EmergencyContact>) => emergencyApi.createEmergencyContact(data),
    onSuccess: (res) => {
      queryClient.invalidateQueries({ queryKey: ['emergency-contacts'] });
      enqueueSnackbar(res.message || 'Emergency contact created', { variant: 'success' });
    },
    onError: (err: Error) => enqueueSnackbar(err.message, { variant: 'error' }),
  });

  const updateMutation = useMutation({
    mutationFn: ({ id, data }: { id: string; data: Partial<EmergencyContact> }) => emergencyApi.updateEmergencyContact(id, data),
    onSuccess: (res) => {
      queryClient.invalidateQueries({ queryKey: ['emergency-contacts'] });
      enqueueSnackbar(res.message || 'Emergency contact updated', { variant: 'success' });
    },
    onError: (err: Error) => enqueueSnackbar(err.message, { variant: 'error' }),
  });

  const deleteMutation = useMutation({
    mutationFn: (id: string) => emergencyApi.deleteEmergencyContact(id),
    onSuccess: (res) => {
      queryClient.invalidateQueries({ queryKey: ['emergency-contacts'] });
      enqueueSnackbar(res.message || 'Emergency contact deleted', { variant: 'success' });
    },
    onError: (err: Error) => enqueueSnackbar(err.message, { variant: 'error' }),
  });

  return {
    createContact: createMutation.mutateAsync,
    updateContact: updateMutation.mutateAsync,
    deleteContact: deleteMutation.mutateAsync,
    isCreating: createMutation.isPending,
    isUpdating: updateMutation.isPending,
  };
};
