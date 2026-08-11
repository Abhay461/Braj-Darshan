import React, { useState } from 'react';
import { useDropzone } from 'react-dropzone';
import {
  Box,
  Typography,
  Grid2 as Grid,
  Card,
  CardMedia,
  CardContent,
  IconButton,
  TextField,
  CircularProgress,
  Chip,
} from '@mui/material';
import DeleteIcon from '@mui/icons-material/DeleteOutlined';
import CloudUploadIcon from '@mui/icons-material/CloudUploadOutlined';
import ContentCopyIcon from '@mui/icons-material/ContentCopyOutlined';
import ArrowUpwardIcon from '@mui/icons-material/ArrowUpward';
import ArrowDownwardIcon from '@mui/icons-material/ArrowDownward';
import AspectRatioIcon from '@mui/icons-material/AspectRatioOutlined';
import { GalleryImage } from '../../types';
import { uploadApi } from '../../api/uploadApi';
import { useSnackbar } from 'notistack';

interface GalleryManagerProps {
  images: GalleryImage[];
  onChange: (images: GalleryImage[]) => void;
  slug?: string;
  recommendation?: string;
}

export const GalleryManager: React.FC<GalleryManagerProps> = ({
  images = [],
  onChange,
  slug = 'general',
  recommendation = 'Recommended Size: 1080 x 720 px (3:2 Aspect Ratio)',
}) => {
  const [uploading, setUploading] = useState(false);
  const { enqueueSnackbar } = useSnackbar();

  const onDrop = async (acceptedFiles: File[]) => {
    if (acceptedFiles.length === 0) return;

    try {
      setUploading(true);
      const res = await uploadApi.uploadMultipleGallery(acceptedFiles, slug);

      if (res.data && Array.isArray(res.data)) {
        const newGalleryImages: GalleryImage[] = res.data.map((item, idx) => ({
          imageUrl: item.imageUrl,
          thumbnailUrl: item.thumbnailUrl || item.imageUrl,
          publicId: item.publicId || '',
          caption: '',
          order: images.length + idx + 1,
        }));

        onChange([...images, ...newGalleryImages]);
        enqueueSnackbar(`${res.data.length} gallery image(s) uploaded successfully`, {
          variant: 'success',
        });
      }
    } catch (err: unknown) {
      const message = err instanceof Error ? err.message : 'Gallery upload failed';
      enqueueSnackbar(message, { variant: 'error' });
    } finally {
      setUploading(false);
    }
  };

  const { getRootProps, getInputProps, isDragActive } = useDropzone({
    onDrop,
    accept: { 'image/*': ['.jpeg', '.jpg', '.png', '.webp', '.avif'] },
    multiple: true,
  });

  const handleRemove = (index: number) => {
    const updated = images.filter((_, i) => i !== index);
    onChange(updated);
  };

  const handleCaptionChange = (index: number, caption: string) => {
    const updated = [...images];
    updated[index] = { ...updated[index], caption };
    onChange(updated);
  };

  const handleMove = (index: number, direction: 'up' | 'down') => {
    const targetIndex = direction === 'up' ? index - 1 : index + 1;
    if (targetIndex < 0 || targetIndex >= images.length) return;

    const updated = [...images];
    const temp = updated[index];
    updated[index] = updated[targetIndex];
    updated[targetIndex] = temp;

    // Update orders
    updated.forEach((img, idx) => {
      img.order = idx + 1;
    });

    onChange(updated);
  };

  const handleCopyUrl = (url: string) => {
    navigator.clipboard.writeText(url);
    enqueueSnackbar('Image URL copied to clipboard', { variant: 'info' });
  };

  return (
    <Box sx={{ mb: 3 }}>
      <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', mb: 1.5 }}>
        <Typography variant="subtitle2" sx={{ fontWeight: 700 }}>
          Temple Gallery Images ({images.length})
        </Typography>
        <Chip
          icon={<AspectRatioIcon style={{ fontSize: 14 }} />}
          label={recommendation}
          size="small"
          color="primary"
          variant="outlined"
          sx={{ fontWeight: 600, fontSize: '0.75rem', height: 24 }}
        />
      </Box>

      <Box
        {...getRootProps()}
        sx={{
          border: '2px dashed',
          borderColor: isDragActive ? '#18181B' : '#E4E4E7',
          borderRadius: '14px',
          p: 3,
          textAlign: 'center',
          backgroundColor: isDragActive ? '#F4F4F5' : '#FFFFFF',
          cursor: 'pointer',
          mb: 3,
          transition: 'all 0.2s ease',
          '&:hover': {
            borderColor: '#18181B',
            backgroundColor: '#FAFAFA',
          },
        }}
      >
        <input {...getInputProps()} />
        {uploading ? (
          <Box sx={{ py: 2 }}>
            <CircularProgress size={32} sx={{ color: '#18181B', mb: 1 }} />
            <Typography variant="body2" color="text.secondary">
              Uploading images to Cloudinary...
            </Typography>
          </Box>
        ) : (
          <Box>
            <CloudUploadIcon sx={{ fontSize: 32, color: '#71717A', mb: 1 }} />
            <Typography variant="body2" sx={{ fontWeight: 700 }}>
              Drag & drop multiple gallery images or click to select
            </Typography>
            <Typography variant="caption" color="text.secondary" sx={{ display: 'block', mt: 0.5 }}>
              Automatic WebP compression & thumbnail generation
            </Typography>
          </Box>
        )}
      </Box>

      {images.length > 0 && (
        <Grid container spacing={2}>
          {images.map((img, idx) => (
            <Grid key={idx} size={{ xs: 12, sm: 6, md: 4 }}>
              <Card sx={{ borderRadius: '14px', border: '1px solid #E4E4E7' }}>
                <Box sx={{ position: 'relative' }}>
                  <CardMedia
                    component="img"
                    height="160"
                    image={img.thumbnailUrl || img.imageUrl}
                    alt={img.caption || `Gallery ${idx + 1}`}
                    sx={{ objectFit: 'cover' }}
                  />
                  <Box
                    sx={{
                      position: 'absolute',
                      top: 6,
                      right: 6,
                      display: 'flex',
                      gap: 0.5,
                      backgroundColor: 'rgba(255, 255, 255, 0.9)',
                      backdropFilter: 'blur(4px)',
                      borderRadius: '8px',
                      p: 0.5,
                    }}
                  >
                    <IconButton size="small" onClick={() => handleMove(idx, 'up')} disabled={idx === 0}>
                      <ArrowUpwardIcon fontSize="small" />
                    </IconButton>
                    <IconButton size="small" onClick={() => handleMove(idx, 'down')} disabled={idx === images.length - 1}>
                      <ArrowDownwardIcon fontSize="small" />
                    </IconButton>
                    <IconButton size="small" onClick={() => handleCopyUrl(img.imageUrl)}>
                      <ContentCopyIcon fontSize="small" />
                    </IconButton>
                    <IconButton size="small" onClick={() => handleRemove(idx)} color="error">
                      <DeleteIcon fontSize="small" />
                    </IconButton>
                  </Box>
                </Box>
                <CardContent sx={{ p: 1.5, '&:last-child': { pb: 1.5 } }}>
                  <TextField
                    fullWidth
                    size="small"
                    placeholder="Add caption..."
                    value={img.caption || ''}
                    onChange={(e) => handleCaptionChange(idx, e.target.value)}
                  />
                </CardContent>
              </Card>
            </Grid>
          ))}
        </Grid>
      )}
    </Box>
  );
};
