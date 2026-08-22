import React from 'react';
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
  FormControlLabel,
  Typography,
  InputLabel,
  Select,
  MenuItem,
  Checkbox,
  ListItemText,
  OutlinedInput,
  Grid2 as Grid,
} from '@mui/material';
import { EmergencyContact } from '../../types';

const locationSchema = z.object({
  lat: z.number().optional(),
  lng: z.number().optional(),
  address: z.string().optional(),
  name: z.string().optional(),
});

const emergencyContactSchema = z.object({
  name: z.string().min(1, 'Name is required').max(100),
  category: z.enum(['police', 'medical', 'fire', 'helpline', 'hospital', 'ambulance', 'tourist_police', 'other']),
  phone: z.string().min(1, 'Phone is required').regex(/^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$/, 'Invalid phone format'),
  description: z.string().optional().default(''),
  location: locationSchema.optional(),
  isActive: z.boolean().optional().default(true),
  sortOrder: z.number().int().min(0).optional().default(0),
  area: z.string().optional().default('Braj'),
  isVerified: z.boolean().optional().default(false),
});

type EmergencyContactFormData = z.infer<typeof emergencyContactSchema>;

interface EmergencyModalProps {
  open: boolean;
  contact: EmergencyContact | null;
  loading?: boolean;
  onClose: () => void;
  onSubmit: (data: EmergencyContactFormData) => Promise<void>;
}

export const EmergencyModal: React.FC<EmergencyModalProps> = ({
  open,
  contact,
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
  } = useForm<EmergencyContactFormData>({
    resolver: zodResolver(emergencyContactSchema),
    defaultValues: {
      name: '',
      category: 'helpline',
      phone: '',
      description: '',
      location: { lat: 0, lng: 0, address: '', name: '' },
      isActive: true,
      sortOrder: 0,
      area: 'Braj',
      isVerified: false,
    },
  });

  React.useEffect(() => {
    if (contact) {
      reset({
        name: contact.name || '',
        category: contact.category || 'helpline',
        phone: contact.phone || '',
        description: contact.description || '',
        location: contact.location || { lat: 0, lng: 0, address: '', name: '' },
        isActive: contact.isActive ?? true,
        sortOrder: contact.sortOrder ?? 0,
        area: contact.area || 'Braj',
        isVerified: contact.isVerified ?? false,
      });
    } else {
      reset({
        name: '',
        category: 'helpline',
        phone: '',
        description: '',
        location: { lat: 0, lng: 0, address: '', name: '' },
        isActive: true,
        sortOrder: 0,
        area: 'Braj',
        isVerified: false,
      });
    }
  }, [contact, reset, open]);

  const handleFormSubmit = async (data: EmergencyContactFormData) => {
    await onSubmit(data);
    onClose();
  };

  const categoryLabels: Record<string, string> = {
    police: 'Police',
    tourist_police: 'Tourist Police',
    medical: 'Medical',
    hospital: 'Hospital',
    ambulance: 'Ambulance',
    fire: 'Fire',
    helpline: 'Helpline',
    other: 'Other',
  };

  return (
    <Dialog open={open} onClose={onClose} maxWidth="md" fullWidth PaperProps={{ sx: { borderRadius: '18px', p: 1 } }}>
      <DialogTitle sx={{ fontWeight: 700 }}>
        {contact ? 'Edit Emergency Contact' : 'Create New Emergency Contact'}
      </DialogTitle>
      <form onSubmit={handleSubmit(handleFormSubmit)}>
        <DialogContent>
          <Grid container spacing={2}>
            <Grid size={{ xs: 12, sm: 6 }}>
              <Controller
                name="name"
                control={control}
                render={({ field }) => (
                  <TextField
                    {...field}
                    label="Contact Name *"
                    fullWidth
                    error={!!errors.name}
                    helperText={errors.name?.message}
                  />
                )}
              />
            </Grid>

            <Grid size={{ xs: 12, sm: 6 }}>
              <Controller
                name="category"
                control={control}
                render={({ field }) => (
                  <FormControl fullWidth error={!!errors.category}>
                    <InputLabel>Category *</InputLabel>
                    <Select {...field} label="Category *">
                      <MenuItem value="police">Police</MenuItem>
                      <MenuItem value="tourist_police">Tourist Police</MenuItem>
                      <MenuItem value="medical">Medical</MenuItem>
                      <MenuItem value="hospital">Hospital</MenuItem>
                      <MenuItem value="ambulance">Ambulance</MenuItem>
                      <MenuItem value="fire">Fire</MenuItem>
                      <MenuItem value="helpline">Helpline</MenuItem>
                      <MenuItem value="other">Other</MenuItem>
                    </Select>
                  </FormControl>
                )}
              />
            </Grid>

            <Grid size={{ xs: 12, sm: 6 }}>
              <Controller
                name="phone"
                control={control}
                render={({ field }) => (
                  <TextField
                    {...field}
                    label="Phone Number *"
                    placeholder="+91-XXXXXXXXXX"
                    fullWidth
                    error={!!errors.phone}
                    helperText={errors.phone?.message || 'Format: +91-XXXXXXXXXX or 108, 102, 112'}
                  />
                )}
              />
            </Grid>

            <Grid size={{ xs: 12, sm: 6 }}>
              <Controller
                name="area"
                control={control}
                render={({ field }) => (
                  <TextField
                    {...field}
                    label="Area/Region"
                    placeholder="Vrindavan, Mathura, Braj"
                    fullWidth
                  />
                )}
              />
            </Grid>

            <Grid size={{ xs: 12 }}>
              <Controller
                name="description"
                control={control}
                render={({ field }) => (
                  <TextField {...field} label="Description" fullWidth multiline rows={2} />
                )}
              />
            </Grid>

            <Grid size={{ xs: 12 }}>
              <Typography variant="h6" sx={{ mb: 1, fontWeight: 600, color: '#E65100' }}>
                Location (For Hospitals & Police Stations)
              </Typography>
              <Typography variant="body2" sx={{ mb: 2, color: 'text.secondary' }}>
                Optional: Add coordinates and address for map integration
              </Typography>
            </Grid>

            <Grid size={{ xs: 12, sm: 6 }}>
              <Controller
                name="location.lat"
                control={control}
                render={({ field }) => (
                  <TextField
                    {...field}
                    label="Latitude"
                    type="number"
                    inputProps={{ step: 'any' }}
                    fullWidth
                  />
                )}
              />
            </Grid>

            <Grid size={{ xs: 12, sm: 6 }}>
              <Controller
                name="location.lng"
                control={control}
                render={({ field }) => (
                  <TextField
                    {...field}
                    label="Longitude"
                    type="number"
                    inputProps={{ step: 'any' }}
                    fullWidth
                  />
                )}
              />
            </Grid>

            <Grid size={{ xs: 12, sm: 6 }}>
              <Controller
                name="location.name"
                control={control}
                render={({ field }) => (
                  <TextField
                    {...field}
                    label="Location Name"
                    placeholder="e.g. Vrindavan District Hospital"
                    fullWidth
                  />
                )}
              />
            </Grid>

            <Grid size={{ xs: 12, sm: 6 }}>
              <Controller
                name="location.address"
                control={control}
                render={({ field }) => (
                  <TextField
                    {...field}
                    label="Address"
                    placeholder="Full address"
                    fullWidth
                  />
                )}
              />
            </Grid>

            <Grid size={{ xs: 12, sm: 6 }}>
              <Controller
                name="sortOrder"
                control={control}
                render={({ field }) => (
                  <TextField
                    {...field}
                    type="number"
                    label="Sort Order"
                    fullWidth
                    inputProps={{ min: 0 }}
                  />
                )}
              />
            </Grid>

            <Grid size={{ xs: 12, sm: 6 }}>
              <Controller
                name="isActive"
                control={control}
                render={({ field }) => (
                  <FormControlLabel
                    control={
                      <Checkbox {...field} color="warning" />
                    }
                    label="Active"
                  />
                )}
              />
            </Grid>

            <Grid size={{ xs: 12, sm: 6 }}>
              <Controller
                name="isVerified"
                control={control}
                render={({ field }) => (
                  <FormControlLabel
                    control={
                      <Checkbox {...field} color="success" />
                    }
                    label="Verified Number"
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
            {loading ? 'Saving...' : contact ? 'Update Contact' : 'Create Contact'}
          </Button>
        </DialogActions>
      </form>
    </Dialog>
  );
};