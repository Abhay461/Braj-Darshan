import React, { useEffect } from 'react';
import { useForm, Controller } from 'react-hook-form';
import { z } from 'zod';
import { zodResolver } from '@hookform/resolvers/zod';
import {
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  Button,
  TextField,
  FormControl,
  InputLabel,
  Select,
  MenuItem,
  Grid2 as Grid,
} from '@mui/material';
import { Location } from '../../types';
import { ImageUploader } from '../forms/ImageUploader';

const locationSchema = z.object({
  name: z.string().min(1, 'Location name is required').max(100),
  description: z.string().optional(),
  coverImage: z.string().optional(),
  district: z.string().optional().default('Mathura'),
  state: z.string().optional().default('Uttar Pradesh'),
  country: z.string().optional().default('India'),
  latitude: z.coerce.number().min(-90).max(90, 'Latitude must be between -90 and 90'),
  longitude: z.coerce.number().min(-180).max(180, 'Longitude must be between -180 and 180'),
  sortOrder: z.coerce.number().optional().default(0),
  status: z.enum(['active', 'inactive']).default('active'),
});

type LocationFormData = z.infer<typeof locationSchema>;

interface LocationModalProps {
  open: boolean;
  location: Location | null;
  loading?: boolean;
  onClose: () => void;
  onSubmit: (data: LocationFormData) => Promise<void>;
}

export const LocationModal: React.FC<LocationModalProps> = ({
  open,
  location,
  loading = false,
  onClose,
  onSubmit,
}) => {
  const {
    control,
    handleSubmit,
    reset,
    setValue,
    watch,
    formState: { errors },
  } = useForm<LocationFormData>({
    resolver: zodResolver(locationSchema),
    defaultValues: {
      name: '',
      description: '',
      coverImage: '',
      district: 'Mathura',
      state: 'Uttar Pradesh',
      country: 'India',
      latitude: 27.5830,
      longitude: 77.7000,
      sortOrder: 0,
      status: 'active',
    },
  });

  const coverImageValue = watch('coverImage');

  useEffect(() => {
    if (location) {
      reset({
        name: location.name || '',
        description: location.description || '',
        coverImage: location.coverImage || '',
        district: location.district || 'Mathura',
        state: location.state || 'Uttar Pradesh',
        country: location.country || 'India',
        latitude: location.latitude || 27.5830,
        longitude: location.longitude || 77.7000,
        sortOrder: location.sortOrder || 0,
        status: location.status || 'active',
      });
    } else {
      reset({
        name: '',
        description: '',
        coverImage: '',
        district: 'Mathura',
        state: 'Uttar Pradesh',
        country: 'India',
        latitude: 27.5830,
        longitude: 77.7000,
        sortOrder: 0,
        status: 'active',
      });
    }
  }, [location, reset, open]);

  const handleFormSubmit = async (data: LocationFormData) => {
    await onSubmit(data);
    onClose();
  };

  return (
    <Dialog open={open} onClose={onClose} maxWidth="xs" fullWidth PaperProps={{ sx: { borderRadius: '18px', p: 1 } }}>
      <DialogTitle sx={{ fontWeight: 700 }}>
        {location ? 'Edit Location' : 'Create New Location'}
      </DialogTitle>
      <form onSubmit={handleSubmit(handleFormSubmit)}>
        <DialogContent>
          <Grid container spacing={2}>
            <Grid size={{ xs: 12 }}>
              <Controller
                name="name"
                control={control}
                render={({ field }) => (
                  <TextField
                    {...field}
                    label="Location Name *"
                    fullWidth
                    autoFocus
                    placeholder="e.g. Vrindavan, Radha Kund..."
                    error={!!errors.name}
                    helperText={errors.name?.message}
                  />
                )}
              />
            </Grid>
          </Grid>
        </DialogContent>
        <DialogActions sx={{ px: 3, pb: 2 }}>
          <Button onClick={onClose} disabled={loading} variant="outlined" color="inherit">
            Cancel
          </Button>
          <Button type="submit" disabled={loading} variant="contained">
            {loading ? 'Saving...' : location ? 'Update Location' : 'Save Location'}
          </Button>
        </DialogActions>
      </form>
    </Dialog>
  );
};
