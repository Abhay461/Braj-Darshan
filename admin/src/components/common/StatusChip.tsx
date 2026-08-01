import React from 'react';
import { Chip } from '@mui/material';

interface StatusChipProps {
  status: 'active' | 'inactive' | 'draft' | string;
  isDeleted?: boolean;
}

export const StatusChip: React.FC<StatusChipProps> = ({ status, isDeleted }) => {
  if (isDeleted) {
    return (
      <Chip
        label="Deleted"
        size="small"
        sx={{
          backgroundColor: '#F4F4F5',
          color: '#71717A',
          border: '1px dashed #A1A1AA',
          fontWeight: 600,
        }}
      />
    );
  }

  switch (status) {
    case 'active':
      return (
        <Chip
          label="Active"
          size="small"
          sx={{
            backgroundColor: '#F4F4F5',
            color: '#18181B',
            border: '1px solid #18181B',
            fontWeight: 600,
          }}
        />
      );
    case 'inactive':
      return (
        <Chip
          label="Inactive"
          size="small"
          sx={{
            backgroundColor: '#FAFAFA',
            color: '#71717A',
            border: '1px solid #E4E4E7',
            fontWeight: 500,
          }}
        />
      );
    case 'draft':
      return (
        <Chip
          label="Draft"
          size="small"
          sx={{
            backgroundColor: '#F4F4F5',
            color: '#52525B',
            border: '1px dotted #A1A1AA',
            fontWeight: 500,
          }}
        />
      );
    default:
      return <Chip label={status} size="small" variant="outlined" />;
  }
};
