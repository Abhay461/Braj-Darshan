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
  FormControlLabel,
  Switch,
  Grid2 as Grid,
  Divider,
  Chip,
  OutlinedInput,
  Checkbox,
  ListItemText,
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
import { useFacilities } from '../../hooks/useFacilities';
import { GalleryImage, Category, Location, Facility } from '../../types';

const templeSchema = z.object({
  name: z.string().min(1, 'Temple name is required').max(200),
  shortDescription: z.string().min(1, 'Short description is required').max(500),
  history: z.string().optional(),
  importance: z.string().optional(),
  categoryId: z.string().min(1, 'Category is required'),
  locationId: z.string().min(1, 'Location is required'),
  coverImage: z.string().min(1, 'Cover image is required'),
  thumbnailImage: z.string().optional(),
  galleryImages: z.array(z.any()).optional().default([]),
  darshanTiming: z.string().optional(),
  phone: z.string().optional(),
  website: z.string().optional(),
  visitDuration: z.string().optional().default('1-2 hours'),
  parkingAvailable: z.boolean().default(false),
  wheelchairAccessible: z.boolean().default(false),
  address: z
    .object({
      street: z.string().optional(),
      area: z.string().optional(),
      city: z.string().optional(),
      state: z.string().optional(),
      pincode: z.string().optional(),
    })
    .optional(),
  latitude: z.coerce.number().min(-90).max(90, 'Latitude must be between -90 and 90'),
  longitude: z.coerce.number().min(-180).max(180, 'Longitude must be between -180 and 180'),
  facilities: z.array(z.string()).optional().default([]),
  tags: z.string().optional(),
  keywords: z.string().optional(),
  isFeatured: z.boolean().default(false),
  isPopular: z.boolean().default(false),
  status: z.enum(['active', 'inactive', 'draft']).default('active'),
  seoTitle: z.string().optional(),
  seoDescription: z.string().optional(),
});

type TempleFormData = z.infer<typeof templeSchema>;

export const TempleForm: React.FC = () => {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const isEdit = Boolean(id);

  const { data: templeRes, isLoading: loadingTemple } = useTemple(id || '');
  const { data: categoriesRes } = useCategories();
  const { data: locationsRes } = useLocations();
  const { data: facilitiesRes } = useFacilities();

  const { createTemple, updateTemple, isCreating, isUpdating } = useTempleMutations();

  const categories = categoriesRes?.data || [];
  const locations = locationsRes?.data || [];
  const facilities = facilitiesRes?.data || [];

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
      shortDescription: '',
      history: '',
      importance: '',
      categoryId: '',
      locationId: '',
      coverImage: '',
      thumbnailImage: '',
      galleryImages: [],
      darshanTiming: '',
      phone: '',
      website: '',
      visitDuration: '1-2 hours',
      parkingAvailable: false,
      wheelchairAccessible: false,
      address: { street: '', area: '', city: '', state: 'Uttar Pradesh', pincode: '' },
      latitude: 27.5830,
      longitude: 77.7000,
      facilities: [],
      tags: '',
      keywords: '',
      isFeatured: false,
      isPopular: false,
      status: 'active',
      seoTitle: '',
      seoDescription: '',
    },
  });

  const templeData = templeRes?.data;
  const nameValue = watch('name');
  const coverImageValue = watch('coverImage');
  const galleryImagesValue = (watch('galleryImages') || []) as GalleryImage[];
  const selectedFacilityIds = watch('facilities') || [];

  useEffect(() => {
    if (templeData) {
      const catId = typeof templeData.categoryId === 'object' ? (templeData.categoryId as Category)._id : templeData.categoryId;
      const locId = typeof templeData.locationId === 'object' ? (templeData.locationId as Location)._id : templeData.locationId;
      const facIds = (templeData.facilities || []).map((f) => (typeof f === 'object' ? (f as Facility)._id : f));

      reset({
        name: templeData.name || '',
        shortDescription: templeData.shortDescription || '',
        history: templeData.history || '',
        importance: templeData.importance || '',
        categoryId: catId || '',
        locationId: locId || '',
        coverImage: templeData.coverImage || '',
        thumbnailImage: templeData.thumbnailImage || '',
        galleryImages: templeData.galleryImages || [],
        darshanTiming: templeData.darshanTiming || '',
        phone: templeData.phone || '',
        website: templeData.website || '',
        visitDuration: templeData.visitDuration || '1-2 hours',
        parkingAvailable: !!templeData.parkingAvailable,
        wheelchairAccessible: !!templeData.wheelchairAccessible,
        address: {
          street: templeData.address?.street || '',
          area: templeData.address?.area || '',
          city: templeData.address?.city || '',
          state: templeData.address?.state || 'Uttar Pradesh',
          pincode: templeData.address?.pincode || '',
        },
        latitude: templeData.latitude || 27.5830,
        longitude: templeData.longitude || 77.7000,
        facilities: facIds,
        tags: (templeData.tags || []).join(', '),
        keywords: (templeData.keywords || []).join(', '),
        isFeatured: !!templeData.isFeatured,
        isPopular: !!templeData.isPopular,
        status: templeData.status || 'active',
        seoTitle: templeData.seoTitle || '',
        seoDescription: templeData.seoDescription || '',
      });
    }
  }, [templeData, reset]);

  const handleFormSubmit = async (data: TempleFormData) => {
    const payload: Partial<Temple> = {
      ...data,
      tags: data.tags ? data.tags.split(',').map((t) => t.trim()).filter(Boolean) : [],
      keywords: data.keywords ? data.keywords.split(',').map((k) => k.trim()).filter(Boolean) : [],
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
        subtitle="Manage shrine details, Cloudinary media, geolocation, and SEO"
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
                General Information
              </Typography>

              <Grid container spacing={2.5}>
                <Grid size={{ xs: 12 }}>
                  <Controller
                    name="name"
                    control={control}
                    render={({ field }) => (
                      <TextField
                        {...field}
                        label="Temple Name *"
                        fullWidth
                        error={!!errors.name}
                        helperText={errors.name?.message}
                      />
                    )}
                  />
                </Grid>

                <Grid size={{ xs: 12 }}>
                  <Controller
                    name="shortDescription"
                    control={control}
                    render={({ field }) => (
                      <TextField
                        {...field}
                        label="Short Description *"
                        fullWidth
                        multiline
                        rows={3}
                        error={!!errors.shortDescription}
                        helperText={errors.shortDescription?.message}
                      />
                    )}
                  />
                </Grid>

                <Grid size={{ xs: 12 }}>
                  <Controller
                    name="history"
                    control={control}
                    render={({ field }) => (
                      <TextField {...field} label="History & Heritage" fullWidth multiline rows={4} />
                    )}
                  />
                </Grid>

                <Grid size={{ xs: 12 }}>
                  <Controller
                    name="importance"
                    control={control}
                    render={({ field }) => (
                      <TextField {...field} label="Spiritual Significance" fullWidth multiline rows={4} />
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
                label="Cover Image (Auto-Compress & WebP/AVIF) *"
                value={coverImageValue}
                onChange={(url) => setValue('coverImage', url)}
                type="cover"
                slug={nameValue ? nameValue.toLowerCase().replace(/[^a-z0-9]/g, '-') : 'temple'}
              />

              <Divider sx={{ my: 3 }} />

              <GalleryManager
                images={galleryImagesValue}
                onChange={(updated) => setValue('galleryImages', updated)}
                slug={nameValue ? nameValue.toLowerCase().replace(/[^a-z0-9]/g, '-') : 'temple'}
              />
            </CardContent>
          </Card>

          {/* Address & Geolocation */}
          <Card sx={{ p: 1, mb: 3 }}>
            <CardContent>
              <Typography variant="h4" sx={{ mb: 2.5, fontWeight: 700 }}>
                Address & Coordinates
              </Typography>

              <Grid container spacing={2}>
                <Grid size={{ xs: 12, sm: 6 }}>
                  <Controller
                    name="address.street"
                    control={control}
                    render={({ field }) => <TextField {...field} label="Street Address" fullWidth />}
                  />
                </Grid>
                <Grid size={{ xs: 12, sm: 6 }}>
                  <Controller
                    name="address.area"
                    control={control}
                    render={({ field }) => <TextField {...field} label="Area / Locality" fullWidth />}
                  />
                </Grid>
                <Grid size={{ xs: 12, sm: 4 }}>
                  <Controller
                    name="address.city"
                    control={control}
                    render={({ field }) => <TextField {...field} label="City" fullWidth />}
                  />
                </Grid>
                <Grid size={{ xs: 12, sm: 4 }}>
                  <Controller
                    name="address.state"
                    control={control}
                    render={({ field }) => <TextField {...field} label="State" fullWidth />}
                  />
                </Grid>
                <Grid size={{ xs: 12, sm: 4 }}>
                  <Controller
                    name="address.pincode"
                    control={control}
                    render={({ field }) => <TextField {...field} label="Pincode" fullWidth />}
                  />
                </Grid>

                <Grid size={{ xs: 12, sm: 6 }}>
                  <Controller
                    name="latitude"
                    control={control}
                    render={({ field }) => (
                      <TextField
                        {...field}
                        type="number"
                        label="Latitude *"
                        fullWidth
                        error={!!errors.latitude}
                        helperText={errors.latitude?.message}
                      />
                    )}
                  />
                </Grid>
                <Grid size={{ xs: 12, sm: 6 }}>
                  <Controller
                    name="longitude"
                    control={control}
                    render={({ field }) => (
                      <TextField
                        {...field}
                        type="number"
                        label="Longitude *"
                        fullWidth
                        error={!!errors.longitude}
                        helperText={errors.longitude?.message}
                      />
                    )}
                  />
                </Grid>
              </Grid>
            </CardContent>
          </Card>
        </Grid>

        {/* Right Sidebar Column */}
        <Grid size={{ xs: 12, md: 4 }}>
          {/* Status & Discovery Flags */}
          <Card sx={{ p: 1, mb: 3 }}>
            <CardContent>
              <Typography variant="h4" sx={{ mb: 2, fontWeight: 700 }}>
                Status & Organization
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

              <FormControl fullWidth sx={{ mb: 2.5 }}>
                <InputLabel>Facilities</InputLabel>
                <Controller
                  name="facilities"
                  control={control}
                  render={({ field }) => (
                    <Select
                      {...field}
                      multiple
                      input={<OutlinedInput label="Facilities" />}
                      renderValue={(selected) =>
                        facilities
                          .filter((f) => (selected as string[]).includes(f._id))
                          .map((f) => f.name)
                          .join(', ')
                      }
                    >
                      {facilities.map((fac) => (
                        <MenuItem key={fac._id} value={fac._id}>
                          <Checkbox checked={selectedFacilityIds.indexOf(fac._id) > -1} />
                          <ListItemText primary={fac.name} />
                        </MenuItem>
                      ))}
                    </Select>
                  )}
                />
              </FormControl>

              <Box sx={{ display: 'flex', flexDirection: 'column', gap: 1 }}>
                <Controller
                  name="isFeatured"
                  control={control}
                  render={({ field }) => (
                    <FormControlLabel
                      control={<Switch checked={field.value} onChange={field.onChange} />}
                      label="Featured Shrine"
                    />
                  )}
                />
                <Controller
                  name="isPopular"
                  control={control}
                  render={({ field }) => (
                    <FormControlLabel
                      control={<Switch checked={field.value} onChange={field.onChange} />}
                      label="Popular Shrine"
                    />
                  )}
                />
                <Controller
                  name="parkingAvailable"
                  control={control}
                  render={({ field }) => (
                    <FormControlLabel
                      control={<Switch checked={field.value} onChange={field.onChange} />}
                      label="Parking Available"
                    />
                  )}
                />
                <Controller
                  name="wheelchairAccessible"
                  control={control}
                  render={({ field }) => (
                    <FormControlLabel
                      control={<Switch checked={field.value} onChange={field.onChange} />}
                      label="Wheelchair Accessible"
                    />
                  )}
                />
              </Box>
            </CardContent>
          </Card>

          {/* Darshan & Contact Info */}
          <Card sx={{ p: 1, mb: 3 }}>
            <CardContent>
              <Typography variant="h4" sx={{ mb: 2, fontWeight: 700 }}>
                Visitor Information
              </Typography>

              <Controller
                name="darshanTiming"
                control={control}
                render={({ field }) => (
                  <TextField {...field} label="Darshan Timings" fullWidth sx={{ mb: 2 }} />
                )}
              />

              <Controller
                name="visitDuration"
                control={control}
                render={({ field }) => (
                  <TextField {...field} label="Average Visit Duration" fullWidth sx={{ mb: 2 }} />
                )}
              />

              <Controller
                name="phone"
                control={control}
                render={({ field }) => (
                  <TextField {...field} label="Contact Phone" fullWidth sx={{ mb: 2 }} />
                )}
              />

              <Controller
                name="website"
                control={control}
                render={({ field }) => <TextField {...field} label="Official Website" fullWidth />}
              />
            </CardContent>
          </Card>

          {/* Tagging & SEO */}
          <Card sx={{ p: 1 }}>
            <CardContent>
              <Typography variant="h4" sx={{ mb: 2, fontWeight: 700 }}>
                SEO & Tags
              </Typography>

              <Controller
                name="tags"
                control={control}
                render={({ field }) => (
                  <TextField
                    {...field}
                    label="Tags (comma separated)"
                    placeholder="krishna, vrindavan, ancient"
                    fullWidth
                    sx={{ mb: 2 }}
                  />
                )}
              />

              <Controller
                name="keywords"
                control={control}
                render={({ field }) => (
                  <TextField
                    {...field}
                    label="Keywords (comma separated)"
                    placeholder="banke bihari darshan, vrindavan temple"
                    fullWidth
                    sx={{ mb: 2 }}
                  />
                )}
              />

              <Controller
                name="seoTitle"
                control={control}
                render={({ field }) => <TextField {...field} label="SEO Title" fullWidth sx={{ mb: 2 }} />}
              />

              <Controller
                name="seoDescription"
                control={control}
                render={({ field }) => (
                  <TextField {...field} label="SEO Description" fullWidth multiline rows={2} />
                )}
              />
            </CardContent>
          </Card>
        </Grid>
      </Grid>
    </Box>
  );
};
