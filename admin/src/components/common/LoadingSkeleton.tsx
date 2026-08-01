import React from 'react';
import { Box, Skeleton, Grid2 as Grid } from '@mui/material';

export const LoadingSkeleton: React.FC<{ rows?: number }> = ({ rows = 5 }) => {
  return (
    <Box sx={{ width: '100%', p: 2 }}>
      <Skeleton variant="rounded" height={60} sx={{ borderRadius: '14px', mb: 2 }} />
      {Array.from({ length: rows }).map((_, index) => (
        <Skeleton key={index} variant="rounded" height={48} sx={{ borderRadius: '10px', mb: 1 }} />
      ))}
    </Box>
  );
};

export const CardSkeleton: React.FC = () => {
  return (
    <Grid container spacing={3}>
      {[1, 2, 3, 4].map((item) => (
        <Grid key={item} size={{ xs: 12, sm: 6, md: 3 }}>
          <Skeleton variant="rounded" height={130} sx={{ borderRadius: '18px' }} />
        </Grid>
      ))}
    </Grid>
  );
};
