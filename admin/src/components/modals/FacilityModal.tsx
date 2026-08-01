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
  Grid2 as Grid,
} from '@mui/material';
import { Facility } from '../../types';

const facilitySchema = z.object({
  name: z.string().min(1, 'Facility name is required').max(100),
  icon: z.string().optional().default('check_circle'),
});

type FacilityFormData = z.infer<typeof facilitySchema>;

interface FacilityModalProps {
  open: boolean;
  facility: Facility | null;
  loading?: boolean;
  onClose: () => void;
  onSubmit: (data: FacilityFormData) => Promise<void>;
}

export const FacilityModal: React.FC<FacilityModalProps> = ({
  open,
  facility,
  loading = false,
  onClose,
  onSubmit,
}) => {
  const {
    control,
    handleSubmit,
    reset,
    formState: { errors },
  } = useForm<FacilityFormData>({
    resolver: zodResolver(facilitySchema),
    defaultValues: {
      name: '',
      icon: 'check_circle',
    },
  });

  useEffect(() => {
    if (facility) {
      reset({
        name: facility.name || '',
        icon: facility.icon || 'check_circle',
      });
    } else {
      reset({
        name: '',
        icon: 'check_circle',
      });
    }
  }, [facility, reset, open]);

  const handleFormSubmit = async (data: FacilityFormData) => {
    await onSubmit(data);
    onClose();
  };

  return (
    <Dialog open={open} onClose={onClose} maxWidth="xs" fullWidth PaperProps={{ sx: { borderRadius: '18px', p: 1 } }}>
      <DialogTitle sx={{ fontWeight: 700 }}>
        {facility ? 'Edit Facility' : 'Create New Facility'}
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
                    label="Facility Name *"
                    fullWidth
                    error={!!errors.name}
                    helperText={errors.name?.message}
                  />
                )}
              />
            </Grid>

            <Grid size={{ xs: 12 }}>
              <Controller
                name="icon"
                control={control}
                render={({ field }) => (
                  <TextField {...field} label="Material Icon Identifier" fullWidth placeholder="accessible, local_parking, etc." />
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
            {loading ? 'Saving...' : facility ? 'Update Facility' : 'Create Facility'}
          </Button>
        </DialogActions>
      </form>
    </Dialog>
  );
};
