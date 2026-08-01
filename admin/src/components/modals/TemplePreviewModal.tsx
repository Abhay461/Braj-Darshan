import React from 'react';
import {
  Dialog,
  DialogTitle,
  DialogContent,
  Box,
  Typography,
  Chip,
  IconButton,
  Divider,
  Grid2 as Grid,
} from '@mui/material';
import CloseIcon from '@mui/icons-material/Close';
import LocationIcon from '@mui/icons-material/LocationOnOutlined';
import AccessTimeIcon from '@mui/icons-material/AccessTimeOutlined';
import PhoneIcon from '@mui/icons-material/PhoneOutlined';
import LanguageIcon from '@mui/icons-material/LanguageOutlined';
import ParkingIcon from '@mui/icons-material/LocalParkingOutlined';
import AccessibleIcon from '@mui/icons-material/AccessibleOutlined';
import { Temple, Category, Location } from '../../types';
import { StatusChip } from '../common/StatusChip';

interface TemplePreviewModalProps {
  open: boolean;
  temple: Temple | null;
  onClose: () => void;
}

export const TemplePreviewModal: React.FC<TemplePreviewModalProps> = ({ open, temple, onClose }) => {
  if (!temple) return null;

  const categoryName = typeof temple.categoryId === 'object' ? (temple.categoryId as Category).name : 'Category';
  const locationName = typeof temple.locationId === 'object' ? (temple.locationId as Location).name : 'Location';

  return (
    <Dialog open={open} onClose={onClose} maxWidth="md" fullWidth PaperProps={{ sx: { borderRadius: '20px', p: 1 } }}>
      <DialogTitle sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', pb: 1 }}>
        <Typography variant="h3">{temple.name}</Typography>
        <IconButton onClick={onClose} size="small">
          <CloseIcon />
        </IconButton>
      </DialogTitle>

      <DialogContent dividers sx={{ p: 3 }}>
        {/* Hero Cover Image */}
        {temple.coverImage && (
          <Box
            component="img"
            src={temple.coverImage}
            alt={temple.name}
            sx={{
              width: '100%',
              height: 280,
              objectFit: 'cover',
              borderRadius: '16px',
              mb: 3,
              border: '1px solid #E4E4E7',
            }}
          />
        )}

        {/* Quick Badges */}
        <Box sx={{ display: 'flex', gap: 1, flexWrap: 'wrap', mb: 2 }}>
          <StatusChip status={temple.status} isDeleted={temple.isDeleted} />
          {temple.isFeatured && <Chip label="Featured" size="small" color="primary" sx={{ fontWeight: 600 }} />}
          {temple.isPopular && <Chip label="Popular" size="small" variant="outlined" sx={{ fontWeight: 600 }} />}
          <Chip label={categoryName} size="small" variant="outlined" />
          <Chip label={locationName} size="small" variant="outlined" />
        </Box>

        {/* Short Description */}
        <Typography variant="subtitle1" sx={{ fontWeight: 500, color: 'text.primary', mb: 3 }}>
          {temple.shortDescription}
        </Typography>

        <Divider sx={{ my: 2 }} />

        {/* Details Grid */}
        <Grid container spacing={3} sx={{ mb: 3 }}>
          <Grid size={{ xs: 12, sm: 6 }}>
            <Box sx={{ display: 'flex', alignItems: 'center', gap: 1, mb: 1.5 }}>
              <AccessTimeIcon color="action" fontSize="small" />
              <Typography variant="body2" sx={{ fontWeight: 600 }}>Darshan Timings:</Typography>
            </Box>
            <Typography variant="body2" color="text.secondary" sx={{ pl: 3.5 }}>
              {temple.darshanTiming || 'Not specified'}
            </Typography>
          </Grid>

          <Grid size={{ xs: 12, sm: 6 }}>
            <Box sx={{ display: 'flex', alignItems: 'center', gap: 1, mb: 1.5 }}>
              <LocationIcon color="action" fontSize="small" />
              <Typography variant="body2" sx={{ fontWeight: 600 }}>Address:</Typography>
            </Box>
            <Typography variant="body2" color="text.secondary" sx={{ pl: 3.5 }}>
              {temple.address?.full || `${temple.address?.area || ''}, ${locationName}`}
            </Typography>
          </Grid>

          {temple.phone && (
            <Grid size={{ xs: 12, sm: 6 }}>
              <Box sx={{ display: 'flex', alignItems: 'center', gap: 1, mb: 0.5 }}>
                <PhoneIcon color="action" fontSize="small" />
                <Typography variant="body2" sx={{ fontWeight: 600 }}>Phone:</Typography>
              </Box>
              <Typography variant="body2" color="text.secondary" sx={{ pl: 3.5 }}>
                {temple.phone}
              </Typography>
            </Grid>
          )}

          {temple.website && (
            <Grid size={{ xs: 12, sm: 6 }}>
              <Box sx={{ display: 'flex', alignItems: 'center', gap: 1, mb: 0.5 }}>
                <LanguageIcon color="action" fontSize="small" />
                <Typography variant="body2" sx={{ fontWeight: 600 }}>Website:</Typography>
              </Box>
              <Typography variant="body2" color="text.secondary" sx={{ pl: 3.5 }}>
                {temple.website}
              </Typography>
            </Grid>
          )}
        </Grid>

        {/* Features & Accessibility */}
        <Box sx={{ display: 'flex', gap: 2, mb: 3 }}>
          {temple.parkingAvailable && (
            <Chip icon={<ParkingIcon fontSize="small" />} label="Parking Available" size="small" variant="outlined" />
          )}
          {temple.wheelchairAccessible && (
            <Chip icon={<AccessibleIcon fontSize="small" />} label="Wheelchair Accessible" size="small" variant="outlined" />
          )}
        </Box>

        {/* History */}
        {temple.history && (
          <Box sx={{ mb: 3 }}>
            <Typography variant="h5" sx={{ mb: 1, fontWeight: 600 }}>History & Origins</Typography>
            <Typography variant="body2" color="text.secondary" sx={{ whiteSpace: 'pre-line' }}>
              {temple.history}
            </Typography>
          </Box>
        )}

        {/* Importance */}
        {temple.importance && (
          <Box sx={{ mb: 3 }}>
            <Typography variant="h5" sx={{ mb: 1, fontWeight: 600 }}>Spiritual Significance</Typography>
            <Typography variant="body2" color="text.secondary" sx={{ whiteSpace: 'pre-line' }}>
              {temple.importance}
            </Typography>
          </Box>
        )}

        {/* Gallery */}
        {temple.galleryImages && temple.galleryImages.length > 0 && (
          <Box sx={{ mt: 3 }}>
            <Typography variant="h5" sx={{ mb: 2, fontWeight: 600 }}>Gallery ({temple.galleryImages.length})</Typography>
            <Grid container spacing={2}>
              {temple.galleryImages.map((img, idx) => (
                <Grid key={idx} size={{ xs: 6, sm: 4, md: 3 }}>
                  <Box
                    component="img"
                    src={img.thumbnailUrl || img.imageUrl}
                    alt={img.caption || `Gallery ${idx + 1}`}
                    sx={{ width: '100%', height: 120, objectFit: 'cover', borderRadius: '12px', border: '1px solid #E4E4E7' }}
                  />
                </Grid>
              ))}
            </Grid>
          </Box>
        )}
      </DialogContent>
    </Dialog>
  );
};
