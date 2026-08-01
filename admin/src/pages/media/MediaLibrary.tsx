import React, { useState } from 'react';
import {
  Box,
  Card,
  CardContent,
  Typography,
  Grid2 as Grid,
  Button,
  IconButton,
  Tooltip,
} from '@mui/material';
import ContentCopyIcon from '@mui/icons-material/ContentCopyOutlined';
import DeleteIcon from '@mui/icons-material/DeleteOutlined';
import FileUploadIcon from '@mui/icons-material/FileUploadOutlined';

import { PageHeader } from '../../components/common/PageHeader';
import { ImageUploader } from '../../components/forms/ImageUploader';
import { uploadApi } from '../../api/uploadApi';
import { useSnackbar } from 'notistack';

export const MediaLibrary: React.FC = () => {
  const [uploadedUrl, setUploadedUrl] = useState<string>('');
  const [mediaList, setMediaList] = useState<string[]>([
    'https://res.cloudinary.com/demo/image/upload/v1/braj-darshan/banke-bihari.jpg',
    'https://res.cloudinary.com/demo/image/upload/v1/braj-darshan/prem-mandir.jpg',
    'https://res.cloudinary.com/demo/image/upload/v1/braj-darshan/iskcon-vrindavan.jpg',
    'https://res.cloudinary.com/demo/image/upload/v1/braj-darshan/radha-raman.jpg',
  ]);
  const { enqueueSnackbar } = useSnackbar();

  const handleUploadSuccess = (url: string) => {
    setUploadedUrl(url);
    if (url) {
      setMediaList((prev) => [url, ...prev]);
    }
  };

  const handleCopy = (url: string) => {
    navigator.clipboard.writeText(url);
    enqueueSnackbar('Cloudinary image URL copied to clipboard', { variant: 'info' });
  };

  const handleDelete = async (url: string) => {
    try {
      await uploadApi.deleteImage(url);
      setMediaList((prev) => prev.filter((item) => item !== url));
      enqueueSnackbar('Image deleted from Cloudinary CDN', { variant: 'success' });
    } catch {
      enqueueSnackbar('Image deletion failed', { variant: 'error' });
    }
  };

  return (
    <Box>
      <PageHeader
        title="Cloudinary Media Library"
        subtitle="Manage, upload, and compress image assets stored on Cloudinary"
        breadcrumbs={[{ label: 'Dashboard', path: '/' }, { label: 'Media Library' }]}
      />

      {/* Upload Zone Card */}
      <Card sx={{ p: 1, mb: 4 }}>
        <CardContent>
          <Typography variant="h4" sx={{ mb: 2, fontWeight: 700 }}>
            Upload Asset to Cloudinary CDN
          </Typography>
          <ImageUploader
            label="Drag & Drop image file for automatic WebP/AVIF compression"
            value={uploadedUrl}
            onChange={handleUploadSuccess}
            folder="media-library"
          />
        </CardContent>
      </Card>

      {/* Media Grid */}
      <Typography variant="h4" sx={{ mb: 2, fontWeight: 700 }}>
        Uploaded Media Assets ({mediaList.length})
      </Typography>

      <Grid container spacing={3}>
        {mediaList.map((url, idx) => (
          <Grid key={idx} size={{ xs: 12, sm: 6, md: 3 }}>
            <Card sx={{ borderRadius: '16px', overflow: 'hidden', border: '1px solid #E4E4E7' }}>
              <Box
                component="img"
                src={url}
                alt={`Media ${idx + 1}`}
                sx={{ width: '100%', height: 180, objectFit: 'cover' }}
              />
              <Box sx={{ p: 1.5, display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                <Typography variant="caption" color="text.secondary" sx={{ maxWidth: 160, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
                  {url.split('/').pop()}
                </Typography>
                <Box>
                  <Tooltip title="Copy URL">
                    <IconButton size="small" onClick={() => handleCopy(url)}>
                      <ContentCopyIcon fontSize="small" />
                    </IconButton>
                  </Tooltip>
                  <Tooltip title="Delete">
                    <IconButton size="small" color="error" onClick={() => handleDelete(url)}>
                      <DeleteIcon fontSize="small" />
                    </IconButton>
                  </Tooltip>
                </Box>
              </Box>
            </Card>
          </Grid>
        ))}
      </Grid>
    </Box>
  );
};
