import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { mapSettingsApi } from '../api/mapSettingsApi';
import { MapSettings } from '../types';
import { useSnackbar } from 'notistack';

const DEFAULT_MAP_SETTINGS: MapSettings = {
  defaultZoom: 14.0,
  minZoom: 5.0,
  maxZoom: 18.0,
  defaultCenterLat: 27.5830,
  defaultCenterLng: 77.7000,
  defaultPinIconStyle: 'location_on',
  defaultPinColor: '#C5221F',
  defaultPinSize: 42,
  mapStyle: 'standard',
  availablePinIcons: [
    { name: 'Default Pin', iconClass: 'location_on', isDefault: true },
    { name: 'Place Pin', iconClass: 'place', isDefault: false },
    { name: 'Temple Icon', iconClass: 'temple_hindu', isDefault: false },
    { name: 'Location Pin', iconClass: 'location_pin', isDefault: false },
    { name: 'My Location', iconClass: 'my_location', isDefault: false },
    { name: 'Flag', iconClass: 'flag', isDefault: false },
    { name: 'Landscape', iconClass: 'landscape', isDefault: false },
    { name: 'Terrain', iconClass: 'terrain', isDefault: false },
  ],
};

export const useMapSettings = () => {
  return useQuery({
    queryKey: ['mapSettings'],
    queryFn: async () => {
      try {
        const res = await mapSettingsApi.getMapSettings();
        return res;
      } catch (err) {
        console.warn('Map settings API endpoint unreachable/not deployed, falling back to defaults:', err);
        return {
          success: true,
          message: 'Using default local map settings',
          data: DEFAULT_MAP_SETTINGS,
          isFallback: true,
        };
      }
    },
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
