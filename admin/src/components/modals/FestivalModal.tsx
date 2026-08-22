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
import { Festival, Temple } from '../../types';
import { ImageUploader } from '../forms/ImageUploader';

const themeConfigSchema = z.object({
  bannerImage: z.string().optional().default(''),
  accentColor: z.string().regex(/^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$/).optional().default(''),
  showPetals: z.boolean().optional().default(false),
  petalType: z.enum(['gulal', 'flower', 'diya', 'none']).optional().default('none'),
});

const festivalSchema = z.object({
  name: z.string().min(1, 'Festival name is required').max(200),
  description: z.string().optional(),
  bannerImage: z.string().optional(),
  startDate: z.string().optional(),
  endDate: z.string().optional(),
  templeIds: z.array(z.string()).optional().default([]),
  themeConfig: themeConfigSchema.optional().default({}),
  status: z.enum(['active', 'inactive']).default('active'),
});

type ThemeConfig = z.infer<typeof themeConfigSchema>;
type FestivalFormData = z.infer<typeof festivalSchema>;

interface FestivalModalProps {
  open: boolean;
  festival: Festival | null;
  temples: Temple[];
  loading?: boolean;
  onClose: () => void;
  onSubmit: (data: FestivalFormData) => Promise<void>;
}

export const FestivalModal: React.FC<FestivalModalProps> = ({
  open,
  festival,
  temples = [],
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
  } = useForm<FestivalFormData>({
    resolver: zodResolver(festivalSchema),
    defaultValues: {
      name: '',
      description: '',
      bannerImage: '',
      startDate: '',
      endDate: '',
      templeIds: [],
      themeConfig: {
        bannerImage: '',
        accentColor: '',
        showPetals: false,
        petalType: 'none',
      },
      status: 'active',
    },
  });

  const bannerValue = watch('bannerImage');
  const selectedTempleIds = watch('templeIds') || [];

  useEffect(() => {
    if (festival) {
      const existingIds = (festival.templeIds || []).map((t) =>
        typeof t === 'object' ? t._id : t
      );
      reset({
        name: festival.name || '',
        description: festival.description || '',
        bannerImage: festival.bannerImage || '',
        startDate: festival.startDate ? festival.startDate.split('T')[0] : '',
        endDate: festival.endDate ? festival.endDate.split('T')[0] : '',
        templeIds: existingIds,
        themeConfig: festival.themeConfig || {
          bannerImage: '',
          accentColor: '',
          showPetals: false,
          petalType: 'none',
        },
        status: festival.status || 'active',
      });
    } else {
      reset({
        name: '',
        description: '',
        bannerImage: '',
        startDate: '',
        endDate: '',
        templeIds: [],
        themeConfig: {
          bannerImage: '',
          accentColor: '',
          showPetals: false,
          petalType: 'none',
        },
        status: 'active',
      });
    }
  }, [festival, reset, open]);

  const handleFormSubmit = async (data: FestivalFormData) => {
    await onSubmit(data);
    onClose();
  };

  return (
    <Dialog open={open} onClose={onClose} maxWidth="sm" fullWidth PaperProps={{ sx: { borderRadius: '18px', p: 1 } }}>
      <DialogTitle sx={{ fontWeight: 700 }}>
        {festival ? 'Edit Festival' : 'Create New Festival'}
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
                    label="Festival Name *"
                    fullWidth
                    error={!!errors.name}
                    helperText={errors.name?.message}
                  />
                )}
              />
            </Grid>

            <Grid size={{ xs: 12 }}>
              <ImageUploader
                label="Banner Image"
                value={bannerValue}
                onChange={(url) => setValue('bannerImage', url)}
                folder="banners"
              />
            </Grid>

            <Grid size={{ xs: 12 }}>
              <Controller
                name="description"
                control={control}
                render={({ field }) => (
                  <TextField {...field} label="Description" fullWidth multiline rows={3} />
                )}
              />
            </Grid>

            <Grid size={{ xs: 12, sm: 6 }}>
              <Controller
                name="startDate"
                control={control}
                render={({ field }) => (
                  <TextField {...field} type="date" label="Start Date" fullWidth slotProps={{ inputLabel: { shrink: true } }} />
                )}
              />
            </Grid>

            <Grid size={{ xs: 12, sm: 6 }}>
              <Controller
                name="endDate"
                control={control}
                render={({ field }) => (
                  <TextField {...field} type="date" label="End Date" fullWidth slotProps={{ inputLabel: { shrink: true } }} />
                )}
              />
            </Grid>

            {/* Theme Configuration for Home Screen Festival Effects */}
            <Grid size={{ xs: 12 }}>
              <Typography variant="h6" sx={{ mb: 2, fontWeight: 700, color: '#E65100' }}>
                Theme Configuration (Home Screen Effects)
              </Typography>
              <Typography variant="body2" sx={{ mb: 2, color: 'text.secondary' }}>
                Optional visual effects for the Home Screen during this festival period.
              </Typography>
            </Grid>

            <Grid size={{ xs: 12, sm: 6 }}>
              <Controller
                name="themeConfig.accentColor"
                control={control}
                render={({ field }) => (
                  <TextField
                    {...field}
                    label="Accent Color (Hex)"
                    placeholder="#E65100"
                    fullWidth
                    helperText="Custom accent color for festival period (e.g., #E65100 for Saffron, #D4AF37 for Gold)"
                  />
                )}
              />
            </Grid>

            <Grid size={{ xs: 12, sm: 6 }}>
              <Controller
                name="themeConfig.bannerImage"
                control={control}
                render={({ field }) => (
                  <TextField
                    {...field}
                    label="Theme Banner Image URL"
                    placeholder="https://..."
                    fullWidth
                    helperText="Optional banner image for festival theme"
                  />
                )}
              />
            </Grid>

            <Grid size={{ xs: 12, sm: 6 }}>
              <Controller
                name="themeConfig.showPetals"
                control={control}
                render={({ field }) => (
                  <FormControlLabel
                    control={
                      <Checkbox {...field} color="warning" />
                    }
                    label="Show Petals/Gulal Effect"
                  />
                )}
              />
            </Grid>

            <Grid size={{ xs: 12, sm: 6 }}>
              <Controller
                name="themeConfig.petalType"
                control={control}
                render={({ field }) => (
                  <FormControl fullWidth>
                    <InputLabel>Petal Effect Type</InputLabel>
                    <Select {...field} label="Petal Effect Type">
                      <MenuItem value="none">None</MenuItem>
                      <MenuItem value="gulal">Gulal (Colored Powder)</MenuItem>
                      <MenuItem value="flower">Flower Petals</MenuItem>
                      <MenuItem value="diya">Diya (Lamps)</MenuItem>
                    </Select>
                  </FormControl>
                )}
              />
            </Grid>

            <Grid size={{ xs: 12 }}>
              <FormControl fullWidth>
                <InputLabel>Associated Temples</InputLabel>
                <Controller
                  name="templeIds"
                  control={control}
                  render={({ field }) => (
                    <Select
                      {...field}
                      multiple
                      input={<OutlinedInput label="Associated Temples" />}
                      renderValue={(selected) =>
                        temples
                          .filter((t) => (selected as string[]).includes(t._id))
                          .map((t) => t.name)
                          .join(', ')
                      }
                    >
                      {temples.map((temple) => (
                        <MenuItem key={temple._id} value={temple._id}>
                          <Checkbox checked={selectedTempleIds.indexOf(temple._id) > -1} />
                          <ListItemText primary={temple.name} />
                        </MenuItem>
                      ))}
                    </Select>
                  )}
                />
              </FormControl>
            </Grid>
          </Grid>
        </DialogContent>
        <DialogActions sx={{ px: 3, pb: 2 }}>
          <Button onClick={onClose} disabled={loading} variant="outlined" color="inherit">
            Cancel
          </Button>
          <Button type="submit" disabled={loading} variant="contained">
            {loading ? 'Saving...' : festival ? 'Update Festival' : 'Create Festival'}
          </Button>
        </DialogActions>
      </form>
    </Dialog>
  );
};
