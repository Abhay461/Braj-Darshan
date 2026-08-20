import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { mapSettingsApi } from '../api/mapSettingsApi';
import { MapSettings } from '../types';
import { useSnackbar } from 'notistack';

export const useMapSettings = () => {
  return useQuery({
    queryKey: ['mapSettings'],
    queryFn: () => mapSettingsApi.getMapSettings(),
  });
};

export const useMapSettingsMutations = () => {
  const queryClient = useQueryClient();
  const { enqueueSnackbar } = useSnackbar();

  const updateMutation = useMutation({
    mutationFn: (data: Partial<MapSettings>) => mapSettingsApi.updateMapSettings(data),
    onSuccess: (res) => {
      queryClient.invalidateQueries({ queryKey: ['mapSettings'] });
      enqueueSnackbar(res.message || 'Map settings updated successfully', { variant: 'success' });
    },
    onError: (err: Error) => enqueueSnackbar(err.message || 'Failed to update map settings', { variant: 'error' }),
  });

  const resetMutation = useMutation({
    mutationFn: () => mapSettingsApi.resetMapSettings(),
    onSuccess: (res) => {
      queryClient.invalidateQueries({ queryKey: ['mapSettings'] });
      enqueueSnackbar(res.message || 'Map settings reset to defaults', { variant: 'success' });
    },
    onError: (err: Error) => enqueueSnackbar(err.message || 'Failed to reset map settings', { variant: 'error' }),
  });

  return {
    updateMapSettings: updateMutation.mutateAsync,
    resetMapSettings: resetMutation.mutateAsync,
    isUpdating: updateMutation.isPending,
    isResetting: resetMutation.isPending,
  };
};
