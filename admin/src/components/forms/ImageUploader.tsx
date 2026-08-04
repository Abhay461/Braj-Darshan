import React, { useState } from 'react';
import { useDropzone } from 'react-dropzone';
import { Box, Typography, CircularProgress, IconButton, Chip } from '@mui/material';
import CloudUploadIcon from '@mui/icons-material/CloudUploadOutlined';
import DeleteIcon from '@mui/icons-material/DeleteOutlined';
import ContentCopyIcon from '@mui/icons-material/ContentCopyOutlined';
import AspectRatioIcon from '@mui/icons-material/AspectRatioOutlined';
import { uploadApi } from '../../api/uploadApi';
import { useSnackbar } from 'notistack';

interface ImageUploaderProps {
  label?: string;
  value?: string;
  onChange: (url: string) => void;
  folder?: string;
  slug?: string;
  type?: 'cover' | 'generic';
  recommendation?: string;
}

export const ImageUploader: React.FC<ImageUploaderProps> = ({
  label = 'Upload Image',
  value = '',
  onChange,
  folder = 'misc',
  slug = 'general',
  type = 'generic',
  recommendation,
}) => {
  const [uploading, setUploading] = useState(false);
  const { enqueueSnackbar } = useSnackbar();

  const defaultRecommendation =
    type === 'cover'
      ? 'Recommended Size: 1200 x 675 px (16:9 Aspect Ratio)'
      : 'Recommended Size: 800 x 600 px (4:3 Aspect Ratio)';

  const displayRecommendation = recommendation || defaultRecommendation;

  const onDrop = async (acceptedFiles: File[]) => {
    if (acceptedFiles.length === 0) return;
    const file = acceptedFiles[0];

    try {
      setUploading(true);
      let res;
      if (type === 'cover') {
        res = await uploadApi.uploadCover(file, slug);
      } else {
        res = await uploadApi.uploadGeneric(file, folder);
      }

      if (res.data?.imageUrl) {
        onChange(res.data.imageUrl);
        enqueueSnackbar('Image uploaded successfully to Cloudinary', { variant: 'success' });
      }
    } catch (err: unknown) {
      const message = err instanceof Error ? err.message : 'Upload failed';
      enqueueSnackbar(message, { variant: 'error' });
    } finally {
      setUploading(false);
    }
  };

  const { getRootProps, getInputProps, isDragActive } = useDropzone({
    onDrop,
    accept: { 'image/*': ['.jpeg', '.jpg', '.png', '.webp', '.avif'] },
    maxFiles: 1,
  });

  const handleCopy = () => {
    if (value) {
      navigator.clipboard.writeText(value);
      enqueueSnackbar('Image URL copied to clipboard', { variant: 'info' });
    }
  };

  return (
    <Box sx={{ mb: 2 }}>
      {label && (
        <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', mb: 1 }}>
          <Typography variant="subtitle2" sx={{ fontWeight: 700 }}>
            {label}
          </Typography>
          <Chip
            icon={<AspectRatioIcon style={{ fontSize: 14 }} />}
            label={displayRecommendation}
            size="small"
            color="primary"
            variant="outlined"
            sx={{ fontWeight: 600, fontSize: '0.75rem', height: 24 }}
          />
        </Box>
      )}

      {value ? (
        <Box
          sx={{
            position: 'relative',
            width: '100%',
            height: 200,
            borderRadius: '14px',
            overflow: 'hidden',
            border: '1px solid #E4E4E7',
            backgroundColor: '#FAFAFA',
          }}
        >
          <Box
            component="img"
            src={value}
            alt="Preview"
            sx={{ width: '100%', height: '100%', objectFit: 'cover' }}
          />
          <Box
            sx={{
              position: 'absolute',
              top: 8,
              right: 8,
              display: 'flex',
              gap: 1,
              backgroundColor: 'rgba(255, 255, 255, 0.9)',
              backdropFilter: 'blur(4px)',
              borderRadius: '10px',
              p: 0.5,
            }}
          >
            <IconButton size="small" onClick={handleCopy} title="Copy URL">
              <ContentCopyIcon fontSize="small" />
            </IconButton>
            <IconButton size="small" onClick={() => onChange('')} color="error" title="Remove">
              <DeleteIcon fontSize="small" />
            </IconButton>
          </Box>
          <Box
            sx={{
              position: 'absolute',
              bottom: 8,
              left: 8,
              backgroundColor: 'rgba(0, 0, 0, 0.75)',
              color: '#FFFFFF',
              px: 1.2,
              py: 0.4,
              borderRadius: '6px',
              fontSize: '0.75rem',
              fontWeight: 600,
            }}
          >
            📐 {displayRecommendation}
          </Box>
        </Box>
      ) : (
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
            transition: 'border-color 0.2s ease, background-color 0.2s ease',
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
                Uploading to Cloudinary...
              </Typography>
            </Box>
          ) : (
            <Box>
              <CloudUploadIcon sx={{ fontSize: 36, color: '#71717A', mb: 1 }} />
              <Typography variant="body2" sx={{ fontWeight: 700, color: '#18181B' }}>
                Drag & drop or click to upload
              </Typography>
              <Typography variant="caption" color="text.secondary" sx={{ mt: 0.5, display: 'block' }}>
                JPEG, PNG, WebP or AVIF (Max 10MB)
              </Typography>

              {/* Recommended Size Chip Box */}
              <Box
                sx={{
                  mt: 1.5,
                  display: 'inline-flex',
                  alignItems: 'center',
                  gap: 0.5,
                  backgroundColor: '#EFF6FF',
                  color: '#1D4ED8',
                  px: 1.5,
                  py: 0.5,
                  borderRadius: '8px',
                  fontWeight: 700,
                  fontSize: '0.8rem',
                  border: '1px solid #BFDBFE',
                }}
              >
                <AspectRatioIcon style={{ fontSize: 16 }} />
                <span>{displayRecommendation}</span>
              </Box>
            </Box>
          )}
        </Box>
      )}
    </Box>
  );
};
