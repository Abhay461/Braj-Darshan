import React, { useEffect } from 'react';
import { useParams, useNavigate, Link as RouterLink } from 'react-router-dom';
import { useForm, Controller } from 'react-hook-form';
import { z } from 'zod';
import { zodResolver } from '@hookform/resolvers/zod';
import {
  Box,
  Card,
  CardContent,
  Typography,
  TextField,
  Button,
  FormControl,
  InputLabel,
  Select,
  MenuItem,
  Grid2 as Grid,
  Divider,
} from '@mui/material';
import SaveIcon from '@mui/icons-material/SaveOutlined';
import ArrowBackIcon from '@mui/icons-material/ArrowBack';

import { PageHeader } from '../../components/common/PageHeader';
import { ImageUploader } from '../../components/forms/ImageUploader';
import { GalleryManager } from '../../components/forms/GalleryManager';
import { LoadingSkeleton } from '../../components/common/LoadingSkeleton';
import { useTemple, useTempleMutations } from '../../hooks/useTemples';
import { useCategories } from '../../hooks/useCategories';
import { useLocations } from '../../hooks/useLocations';
import { GalleryImage, Category, Location, Temple } from '../../types';

const templeSchema = z.object({
  name: z.string().min(1, 'Temple name is required').max(200),
  nameHindi: z.string().optional().default(''),
  history: z.string().optional().default(''),
  historyHindi: z.string().optional().default(''),
  darshanTiming: z.string().optional().default(''),
  donationUrl: z.string().optional().default(''),
  guestHouseBookingUrl: z.string().optional().default(''),
  liveDarshanUrl: z.string().optional().default(''),
  directionsUrl: z.string().optional().default(''),
  categoryId: z.string().min(1, 'Category is required'),
  locationId: z.string().min(1, 'Location is required'),
  coverImage: z.string().min(1, 'Cover image is required'),
  thumbnailImage: z.string().optional(),
  galleryImages: z.array(z.any()).optional().default([]),
  status: z.enum(['active', 'inactive', 'draft']).default('active'),
});

type TempleFormData = z.infer<typeof templeSchema>;

export const TempleForm: React.FC = () => {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const isEdit = Boolean(id);

  const { data: templeRes, isLoading: loadingTemple } = useTemple(id || '');
  const { data: categoriesRes } = useCategories({ limit: 100 });
  const { data: locationsRes } = useLocations({ limit: 100 });

  const { createTemple, updateTemple, isCreating, isUpdating } = useTempleMutations();

  const categories = categoriesRes?.data || [];
  const locations = locationsRes?.data || [];

  const {
    control,
    handleSubmit,
    reset,
    setValue,
    watch,
    formState: { errors },
  } = useForm<TempleFormData>({
    resolver: zodResolver(templeSchema),
    defaultValues: {
      name: '',
      nameHindi: '',
      history: '',
      historyHindi: '',
      darshanTiming: '',
      donationUrl: '',
      guestHouseBookingUrl: '',
      liveDarshanUrl: '',
      directionsUrl: '',
      categoryId: '',
      locationId: '',
      coverImage: '',
      thumbnailImage: '',
      galleryImages: [],
      status: 'active',
    },
  });

  const templeData = templeRes?.data;
  const nameValue = watch('name');
  const coverImageValue = watch('coverImage');
  const galleryImagesValue = (watch('galleryImages') || []) as GalleryImage[];

  useEffect(() => {
    if (templeData) {
      const catId = typeof templeData.categoryId === 'object' ? (templeData.categoryId as Category)._id : templeData.categoryId;
      const locId = typeof templeData.locationId === 'object' ? (templeData.locationId as Location)._id : templeData.locationId;

      reset({
        name: templeData.name || '',
        nameHindi: (templeData as any).nameHindi || '',
        history: templeData.history || '',
        historyHindi: (templeData as any).historyHindi || '',
        darshanTiming: templeData.darshanTiming || '',
        donationUrl: templeData.donationUrl || '',
        guestHouseBookingUrl: templeData.guestHouseBookingUrl || '',
        liveDarshanUrl: templeData.liveDarshanUrl || '',
        directionsUrl: templeData.directionsUrl || '',
        categoryId: catId || '',
        locationId: locId || '',
        coverImage: templeData.coverImage || '',
        thumbnailImage: templeData.thumbnailImage || '',
        galleryImages: templeData.galleryImages || [],
        status: templeData.status || 'active',
      });
    }
  }, [templeData, reset]);

  const handleFormSubmit = async (data: TempleFormData) => {
    const payload: Partial<Temple> = {
      ...data,
      shortDescription: data.history || data.name,
      latitude: 27.5830,
      longitude: 77.7000,
      isFeatured: true,
      isPopular: false,
      parkingAvailable: false,
      wheelchairAccessible: false,
      facilities: [],
      tags: [],
      keywords: [],
      address: { street: '', area: '', city: '', state: 'Uttar Pradesh', pincode: '' },
      seoTitle: '',
      seoDescription: '',
    };

    if (isEdit && id) {
      await updateTemple({ id, data: payload });
    } else {
      await createTemple(payload);
    }
    navigate('/temples');
  };

  if (isEdit && loadingTemple) {
    return <LoadingSkeleton rows={10} />;
  }

  return (
    <Box component="form" onSubmit={handleSubmit(handleFormSubmit)}>
      <PageHeader
        title={isEdit ? `Edit Temple: ${templeData?.name || ''}` : 'Add New Temple'}
        subtitle="Manage English & Hindi shrine details and Cloudinary media"
        breadcrumbs={[
          { label: 'Dashboard', path: '/' },
          { label: 'Temples', path: '/temples' },
          { label: isEdit ? 'Edit Temple' : 'New Temple' },
        ]}
        actions={
          <Box sx={{ display: 'flex', gap: 1.5 }}>
            <Button
              component={RouterLink}
              to="/temples"
              variant="outlined"
              startIcon={<ArrowBackIcon />}
            >
              Cancel
            </Button>
            <Button
              type="submit"
              variant="contained"
              startIcon={<SaveIcon />}
              disabled={isCreating || isUpdating}
            >
              {isCreating || isUpdating ? 'Saving...' : 'Save Temple'}
            </Button>
          </Box>
        }
      />

      <Grid container spacing={3}>
        {/* Left Form Column */}
        <Grid size={{ xs: 12, md: 8 }}>
          <Card sx={{ p: 1, mb: 3 }}>
            <CardContent>
              <Typography variant="h4" sx={{ mb: 2.5, fontWeight: 700 }}>
                General Information (English & Hindi)
              </Typography>

              <Grid container spacing={2.5}>
                {/* Temple Name (English) */}
                <Grid size={{ xs: 12, sm: 6 }}>
                  <Controller
                    name="name"
                    control={control}
                    render={({ field }) => (
                      <TextField
                        {...field}
                        label="Temple Name (English) *"
                        fullWidth
                        error={!!errors.name}
                        helperText={errors.name?.message}
                      />
                    )}
                  />
                </Grid>

                {/* Temple Name (Hindi) */}
                <Grid size={{ xs: 12, sm: 6 }}>
                  <Controller
                    name="nameHindi"
                    control={control}
                    render={({ field }) => (
                      <TextField
                        {...field}
                        label="हिंदी नाम (Temple Name in Hindi)"
                        placeholder="उदा: श्री बांके बिहारी जी"
                        fullWidth
                      />
                    )}
                  />
                </Grid>

                {/* History (English) */}
                <Grid size={{ xs: 12 }}>
                  <Controller
                    name="history"
                    control={control}
                    render={({ field }) => (
                      <TextField {...field} label="History & Details (English)" fullWidth multiline rows={3} />
                    )}
                  />
                </Grid>

                {/* History (Hindi) */}
                <Grid size={{ xs: 12 }}>
                  <Controller
                    name="historyHindi"
                    control={control}
                    render={({ field }) => (
                      <TextField
                        {...field}
                        label="हिंदी विवरण (History & Details in Hindi)"
                        placeholder="उदा: मंदिर का प्राचीन इतिहास एवं दर्शन महिमा..."
                        fullWidth
                        multiline
                        rows={3}
                      />
                    )}
                  />
                </Grid>

                {/* Darshan & Aarti Open/Close Timings */}
                <Grid size={{ xs: 12 }}>
                  <Controller
                    name="darshanTiming"
                    control={control}
                    render={({ field }) => (
                      <TextField
                        {...field}
                        label="Darshan Open & Close Timings (दर्शन एवं आरती समय)"
                        placeholder="Morning: 05:00 AM – 12:00 PM | Evening: 04:00 PM – 09:00 PM"
                        fullWidth
                        helperText="Mandir khulne aur band hone ka samay (e.g. Morning: 05:00 AM - 12:00 PM, Evening: 04:00 PM - 09:00 PM)"
                      />
                    )}
                  />
                </Grid>
              </Grid>
            </CardContent>
          </Card>

          {/* Special External Action Links */}
          <Card sx={{ p: 1, mb: 3 }}>
            <CardContent>
              <Typography variant="h4" sx={{ mb: 1, fontWeight: 700 }}>
                Special Action Links (Live Darshan, Donation, Guest House)
              </Typography>
              <Typography variant="body2" sx={{ mb: 2.5, color: 'text.secondary' }}>
                Note: In the app's 3-dot menu, buttons for Live Darshan, Donate, or Guest House will ONLY appear when you enter a valid URL below.
              </Typography>

              <Grid container spacing={2.5}>
                {/* Live Darshan URL */}
                <Grid size={{ xs: 12 }}>
                  <Controller
                    name="liveDarshanUrl"
                    control={control}
                    render={({ field }) => (
                      <TextField
                        {...field}
                        label="Live Darshan Link (YouTube / Live Stream URL)"
                        placeholder="https://www.youtube.com/watch?v=..."
                        fullWidth
                      />
                    )}
                  />
                </Grid>

                {/* Donation URL */}
                <Grid size={{ xs: 12, sm: 6 }}>
                  <Controller
                    name="donationUrl"
                    control={control}
                    render={({ field }) => (
                      <TextField
                        {...field}
                        label="Donation / Seva Link"
                        placeholder="https://..."
                        fullWidth
                      />
                    )}
                  />
                </Grid>

                {/* Guest House Booking URL */}
                <Grid size={{ xs: 12, sm: 6 }}>
                  <Controller
                    name="guestHouseBookingUrl"
                    control={control}
                    render={({ field }) => (
                      <TextField
                        {...field}
                        label="Guest House / Dharamshala Booking Link"
                        placeholder="https://..."
                        fullWidth
                      />
                    )}
                  />
                </Grid>

                {/* Custom Directions / Google Maps URL */}
                <Grid size={{ xs: 12 }}>
                  <Controller
                    name="directionsUrl"
                    control={control}
                    render={({ field }) => (
                      <TextField
                        {...field}
                        label="Custom Directions / Google Maps Link (Optional)"
                        placeholder="https://maps.google.com/..."
                        fullWidth
                      />
                    )}
                  />
                </Grid>
              </Grid>
            </CardContent>
          </Card>

          {/* Media & Gallery Manager */}
          <Card sx={{ p: 1, mb: 3 }}>
            <CardContent>
              <Typography variant="h4" sx={{ mb: 2.5, fontWeight: 700 }}>
                Media & Cloudinary Images
              </Typography>

              <ImageUploader
                label="Cover Image *"
                value={coverImageValue}
                onChange={(url) => setValue('coverImage', url)}
                type="cover"
                slug={nameValue ? nameValue.toLowerCase().replace(/[^a-z0-9]/g, '-') : 'temple'}
              />
            </CardContent>
          </Card>
        </Grid>

        {/* Right Sidebar Column */}
        <Grid size={{ xs: 12, md: 4 }}>
          {/* Status & Organization */}
          <Card sx={{ p: 1, mb: 3 }}>
            <CardContent>
              <Typography variant="h4" sx={{ mb: 2, fontWeight: 700 }}>
                Organization & Status
              </Typography>

              <Controller
                name="status"
                control={control}
                render={({ field }) => (
                  <FormControl fullWidth sx={{ mb: 2.5 }}>
                    <InputLabel>Publishing Status</InputLabel>
                    <Select {...field} label="Publishing Status">
                      <MenuItem value="active">Active (Published)</MenuItem>
                      <MenuItem value="inactive">Inactive</MenuItem>
                      <MenuItem value="draft">Draft</MenuItem>
                    </Select>
                  </FormControl>
                )}
              />

              <Controller
                name="categoryId"
                control={control}
                render={({ field }) => (
                  <FormControl fullWidth error={!!errors.categoryId} sx={{ mb: 2.5 }}>
                    <InputLabel>Category *</InputLabel>
                    <Select {...field} label="Category *">
                      {categories.map((cat) => (
                        <MenuItem key={cat._id} value={cat._id}>
                          {cat.name}
                        </MenuItem>
                      ))}
                    </Select>
                  </FormControl>
                )}
              />

              <Controller
                name="locationId"
                control={control}
                render={({ field }) => (
                  <FormControl fullWidth error={!!errors.locationId} sx={{ mb: 2.5 }}>
                    <InputLabel>Location *</InputLabel>
                    <Select {...field} label="Location *">
                      {locations.map((loc) => (
                        <MenuItem key={loc._id} value={loc._id}>
                          {loc.name}
                        </MenuItem>
                      ))}
                    </Select>
                  </FormControl>
                )}
              />
            </CardContent>
          </Card>
        </Grid>
      </Grid>
    </Box>
  );
};
